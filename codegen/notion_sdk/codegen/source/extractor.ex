defmodule NotionSDK.Codegen.Source.Extractor do
  @moduledoc """
  Extracts OpenAPI YAML and structured page context from Notion markdown pages.
  """

  alias NotionSDK.Codegen.Source.PageContext

  @alert_tags ~w(Warning Info Tip Note)
  @http_methods ~w(get put post delete options head patch trace)
  @relative_link_base "https://developers.notion.com"

  @spec extract_file!(String.t()) :: %{page_context: PageContext.t(), yaml: String.t()}
  def extract_file!(markdown_path) when is_binary(markdown_path) do
    slug = markdown_path |> Path.basename(".md")

    markdown_path
    |> File.read!()
    |> extract_markdown!(slug)
  end

  @spec extract_markdown!(String.t(), String.t()) :: %{
          page_context: PageContext.t(),
          yaml: String.t()
        }
  def extract_markdown!(markdown, slug) when is_binary(markdown) and is_binary(slug) do
    markdown = normalize_newlines(markdown)
    {yaml, _metadata} = extract_yaml_block!(markdown)
    {preamble, _rest} = split_openapi(markdown)
    variables = parse_variables(preamble)
    preamble = strip_documentation_index(preamble)
    spec = YamlElixir.read_from_string!(yaml)
    {method, path, operation} = extract_operation!(spec)

    sections =
      preamble
      |> String.split("\n", trim: false)
      |> scan_sections(variables)

    page_context =
      build_page_context(
        slug,
        sections,
        method,
        path,
        operation
      )

    %{yaml: yaml, page_context: page_context}
  end

  defp build_page_context(slug, scan_result, method, path, operation) do
    title = scan_result.title || operation["summary"] || slug
    warnings = Enum.map(scan_result.alerts.warning, &entry_from_alert(&1, "warning"))
    info_notes = Enum.map(scan_result.alerts.info, &entry_from_alert(&1, "info"))

    generic_sections =
      scan_result.named_sections
      |> Enum.reject(&special_heading?/1)
      |> Enum.map(&entry_from_section/1)

    overview_sections =
      case scan_result.overview_blocks do
        [] ->
          []

        blocks ->
          [
            %{
              heading: "Overview",
              level: 2,
              body: join_bodies(Enum.map(blocks, &Map.get(&1, :body))),
              items: Enum.flat_map(blocks, &Map.get(&1, :items, []))
            }
          ]
      end

    rendered_sections = overview_sections ++ generic_sections
    limits = section_group(scan_result.named_sections, "limits")
    errors = section_group(scan_result.named_sections, "errors")
    lead = scan_result.lead
    resources = gather_resources(scan_result, slug)

    page_context =
      %PageContext{
        slug: slug,
        title: title,
        method: method,
        path: path,
        operation_id: operation["operationId"],
        lead: lead,
        summary: nil,
        description: nil,
        source_url: PageContext.source_url(slug),
        warnings: warnings,
        info_notes: info_notes,
        limits: limits,
        errors: errors,
        sections: rendered_sections,
        code_samples: normalize_code_samples(operation["x-codeSamples"] || []),
        resources: resources
      }

    %{page_context | description: PageContext.build_description(page_context)}
  end

  defp extract_yaml_block!(markdown) do
    marker = "````yaml"

    with {start, _size} <- :binary.match(markdown, marker),
         after_marker <-
           binary_part(
             markdown,
             start + byte_size(marker),
             byte_size(markdown) - start - byte_size(marker)
           ),
         [header, rest] <- String.split(after_marker, "\n", parts: 2),
         [yaml, _after_block] <- String.split(rest, "\n````", parts: 2) do
      {String.trim_trailing(yaml) <> "\n", yaml_block_metadata(header, yaml)}
    else
      _ ->
        raise "unable to extract OpenAPI fixture from markdown page"
    end
  end

  defp yaml_block_metadata(header, yaml) do
    header_parts = header |> String.trim() |> String.split(" ", trim: true)
    metadata = %{"yaml" => yaml}

    case header_parts do
      [method, path] -> Map.merge(metadata, %{"method" => method, "path" => path})
      _ -> metadata
    end
  end

  defp split_openapi(markdown) do
    case String.split(markdown, "\n## OpenAPI", parts: 2) do
      [preamble, rest] -> {String.trim_trailing(preamble), rest}
      [preamble] -> {String.trim_trailing(preamble), ""}
    end
  end

  defp extract_operation!(spec) do
    spec
    |> Map.get("paths", %{})
    |> Enum.find_value(fn {path, operations} ->
      Enum.find_value(@http_methods, fn method ->
        case Map.get(operations, method) do
          operation when is_map(operation) -> {method, path, operation}
          _other -> nil
        end
      end)
    end)
    |> case do
      {method, path, operation} ->
        {method, path, operation}

      nil ->
        raise "expected extracted YAML to contain exactly one operation"
    end
  end

  defp parse_variables(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      case parse_variable_line(line) do
        {name, value} -> Map.put(acc, name, value)
        nil -> acc
      end
    end)
  end

  defp parse_variable_line("export const " <> rest) do
    with [name, value_and_suffix] <- String.split(rest, " = \"", parts: 2),
         [value, ""] <- String.split(value_and_suffix, "\";", parts: 2),
         true <- identifier?(name) do
      {name, value}
    else
      _ -> nil
    end
  end

  defp parse_variable_line(_line), do: nil

  defp identifier?(value) when is_binary(value) and value != "" do
    value
    |> String.to_charlist()
    |> Enum.all?(fn char -> char == ?_ or char in ?a..?z or char in ?A..?Z or char in ?0..?9 end)
  end

  defp strip_documentation_index(markdown) do
    case String.split(markdown, "\n", trim: false) do
      ["> ## Documentation Index" <> _rest | remaining] ->
        remaining
        |> Enum.split_while(&String.starts_with?(&1, ">"))
        |> then(fn {_quote_block, rest} -> rest end)
        |> Enum.drop_while(&(String.trim(&1) == ""))
        |> Enum.join("\n")

      _lines ->
        markdown
    end
  end

  defp scan_sections(lines, variables) do
    do_scan(lines, 0, variables, %{
      title: nil,
      lead: nil,
      overview_blocks: [],
      named_sections: [],
      alerts: %{warning: [], info: []},
      resources: []
    })
  end

  defp do_scan(lines, index, _variables, state) when index >= length(lines), do: state

  defp do_scan(lines, index, variables, state) do
    line = Enum.at(lines, index, "")

    cond do
      blank_line?(line) ->
        do_scan(lines, index + 1, variables, state)

      variable_line?(line) ->
        do_scan(lines, index + 1, variables, state)

      alert_open?(line) ->
        {alert, next_index} = consume_alert(lines, index, variables)
        alerts = put_alert(state.alerts, alert)
        resources = state.resources ++ alert.resources
        do_scan(lines, next_index, variables, %{state | alerts: alerts, resources: resources})

      heading = parse_heading(line) ->
        {section, next_index} = consume_section(lines, index, variables, heading)
        state = apply_section(state, section)
        do_scan(lines, next_index, variables, state)

      true ->
        {block, next_index} = consume_free_block(lines, index, variables)
        state = apply_free_block(state, block)
        do_scan(lines, next_index, variables, state)
    end
  end

  defp apply_section(state, %{level: 1, heading: heading}) do
    %{state | title: heading}
  end

  defp apply_section(state, %{heading: "OpenAPI"}), do: state

  defp apply_section(state, section) do
    %{
      state
      | named_sections: state.named_sections ++ [section],
        resources: state.resources ++ section.resources
    }
  end

  defp apply_free_block(state, block) do
    cond do
      state.lead == nil and present(block.body) ->
        %{state | lead: block.body, resources: state.resources ++ block.resources}

      present(block.body) || block.items != [] ->
        %{
          state
          | overview_blocks: state.overview_blocks ++ [block],
            resources: state.resources ++ block.resources
        }

      true ->
        state
    end
  end

  defp consume_alert(lines, index, variables) do
    kind = alert_kind(Enum.at(lines, index))
    {inner_lines, next_index} = take_until(lines, index + 1, &(&1 == "</#{kind}>"))
    block = content_block(inner_lines, variables)
    title_and_body = extract_title(block.body)

    alert = %{
      kind: String.downcase(kind),
      title: title_and_body.title,
      body: title_and_body.body,
      items: block.items,
      resources: block.resources
    }

    {alert, next_index + 1}
  end

  defp consume_section(lines, index, variables, %{level: level, heading: heading}) do
    {inner_lines, next_index} =
      take_until(lines, index + 1, fn line ->
        alert_open?(line) or parse_heading(line) != nil
      end)

    block = content_block(inner_lines, variables)

    section = %{
      heading: heading,
      level: level,
      body: block.body,
      items: block.items,
      resources: block.resources
    }

    {section, next_index}
  end

  defp consume_free_block(lines, index, variables) do
    {inner_lines, next_index} =
      take_until(lines, index, fn line ->
        blank_line?(line) or alert_open?(line) or parse_heading(line) != nil
      end)

    {content_block(inner_lines, variables), next_index}
  end

  defp take_until(lines, index, stop_fun) do
    take_until(lines, index, stop_fun, [])
  end

  defp take_until(lines, index, _stop_fun, acc) when index >= length(lines) do
    {Enum.reverse(acc), index}
  end

  defp take_until(lines, index, stop_fun, acc) do
    line = Enum.at(lines, index, "")

    if stop_fun.(line) do
      {Enum.reverse(acc), index}
    else
      take_until(lines, index + 1, stop_fun, [line | acc])
    end
  end

  defp content_block(lines, variables) do
    normalized_lines =
      lines
      |> Enum.map(&normalize_line(&1, variables))
      |> Enum.reject(&is_nil/1)

    {item_lines, paragraph_lines} =
      Enum.reduce(normalized_lines, {[], []}, fn line, {items, paragraphs} ->
        if String.starts_with?(line, "* ") or String.starts_with?(line, "- ") do
          {[line | items], paragraphs}
        else
          {items, [line | paragraphs]}
        end
      end)

    item_lines = Enum.reverse(item_lines)
    paragraph_lines = Enum.reverse(paragraph_lines)

    body =
      paragraph_lines
      |> Enum.reject(&blank_line?/1)
      |> Enum.join("\n")
      |> String.trim()
      |> present()

    items =
      item_lines
      |> Enum.map(&String.replace_prefix(&1, "* ", ""))
      |> Enum.map(&String.replace_prefix(&1, "- ", ""))
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))

    resources = extract_resources(normalized_lines)

    %{body: body, items: items, resources: resources}
  end

  defp normalize_line(line, variables) do
    line
    |> replace_anchor_links(variables)
    |> replace_markdown_relative_links()
    |> strip_quote_prefix()
    |> String.trim()
    |> case do
      "" -> nil
      trimmed -> trimmed
    end
  end

  defp strip_quote_prefix(">" <> rest) do
    String.replace_prefix(rest, " ", "")
  end

  defp strip_quote_prefix(line), do: line

  defp replace_anchor_links(line, variables) do
    replace_anchor_links(line, variables, "")
  end

  defp replace_anchor_links("", _variables, acc), do: acc

  defp replace_anchor_links(line, variables, acc) do
    case String.split(line, "<a href={", parts: 2) do
      [prefix, rest] ->
        case String.split(rest, "}>", parts: 2) do
          [variable, label_and_rest] ->
            case String.split(label_and_rest, "</a>", parts: 2) do
              [label, suffix] ->
                replacement =
                  case Map.get(variables, variable) do
                    nil -> label
                    url -> "[#{label}](#{url})"
                  end

                replace_anchor_links(suffix, variables, acc <> prefix <> replacement)

              _ ->
                acc <> line
            end

          _ ->
            acc <> line
        end

      [_no_anchor] ->
        acc <> line
    end
  end

  defp replace_markdown_relative_links(line) do
    replace_markdown_relative_links(line, "")
  end

  defp replace_markdown_relative_links("", acc), do: acc

  defp replace_markdown_relative_links(line, acc) do
    case String.split(line, "](/", parts: 2) do
      [prefix, rest] ->
        case String.split(rest, ")", parts: 2) do
          [relative_path, suffix] ->
            replacement = "](#{@relative_link_base}/#{relative_path})"
            replace_markdown_relative_links(suffix, acc <> prefix <> replacement)

          _ ->
            acc <> line
        end

      [_no_relative_link] ->
        acc <> line
    end
  end

  defp extract_resources(lines) when is_list(lines) do
    lines
    |> Enum.flat_map(&extract_resources_from_line/1)
    |> uniq_resources()
  end

  defp extract_resources_from_line(line) do
    normalized_line = neutralize_inline_code_brackets(line)

    normalized_line
    |> markdown_links()
    |> Enum.map(fn {label, url} ->
      %{label: label, url: normalize_url(url), kind: resource_kind(url)}
    end)
  end

  defp markdown_links(line), do: markdown_links(line, [])

  defp markdown_links("", acc), do: Enum.reverse(acc)

  defp markdown_links(line, acc) do
    case String.split(line, "[", parts: 2) do
      [_before, label_and_rest] ->
        case String.split(label_and_rest, "](", parts: 2) do
          [label, url_and_rest] ->
            case String.split(url_and_rest, ")", parts: 2) do
              [url, rest] -> markdown_links(rest, [{label, url} | acc])
              _ -> Enum.reverse(acc)
            end

          _ ->
            Enum.reverse(acc)
        end

      [_no_link] ->
        Enum.reverse(acc)
    end
  end

  defp neutralize_inline_code_brackets(line) do
    neutralize_inline_code_brackets(line, "")
  end

  defp neutralize_inline_code_brackets("", acc), do: acc

  defp neutralize_inline_code_brackets(line, acc) do
    case String.split(line, "`", parts: 2) do
      [prefix, rest] ->
        case String.split(rest, "`", parts: 2) do
          [code, suffix] ->
            neutralized =
              code
              |> String.replace("[", "")
              |> String.replace("]", "")

            neutralize_inline_code_brackets(suffix, acc <> prefix <> neutralized)

          _ ->
            acc <> line
        end

      [_no_code] ->
        acc <> line
    end
  end

  defp gather_resources(scan_result, slug) do
    source_resource = %{
      label: scan_result.title || slug,
      url: PageContext.source_url(slug),
      kind: "source"
    }

    (scan_result.resources ++ [source_resource])
    |> uniq_resources()
  end

  defp uniq_resources(resources) do
    {resources, _seen} =
      Enum.reduce(resources, {[], MapSet.new()}, fn resource, {acc, seen} ->
        key = {resource.label, resource.url}

        if MapSet.member?(seen, key) or present(resource.url) == nil do
          {acc, seen}
        else
          {acc ++ [resource], MapSet.put(seen, key)}
        end
      end)

    resources
  end

  defp normalize_url("/" <> _rest = url), do: @relative_link_base <> url
  defp normalize_url(url), do: url

  defp resource_kind("/reference/" <> _rest), do: "reference"
  defp resource_kind("/guides/" <> _rest), do: "guide"
  defp resource_kind("https://developers.notion.com/reference/" <> _rest), do: "reference"
  defp resource_kind("https://developers.notion.com/guides/" <> _rest), do: "guide"
  defp resource_kind(_url), do: "link"

  defp section_group(sections, heading) do
    sections
    |> Enum.filter(&(String.downcase(&1.heading) == heading))
    |> Enum.map(&entry_from_section/1)
  end

  defp entry_from_section(section) do
    %{
      heading: section.heading,
      level: section.level,
      body: section.body,
      items: section.items
    }
    |> Enum.reject(fn {_key, value} -> value in [nil, []] end)
    |> Map.new()
  end

  defp entry_from_alert(alert, kind) do
    %{
      kind: kind,
      title: alert.title,
      body: alert.body,
      items: alert.items
    }
    |> Enum.reject(fn {_key, value} -> value in [nil, []] end)
    |> Map.new()
  end

  defp normalize_code_samples(code_samples) when is_list(code_samples) do
    Enum.map(code_samples, fn code_sample ->
      %{
        language: present(code_sample["lang"] || code_sample[:lang]),
        label: present(code_sample["label"] || code_sample[:label]),
        source: present(code_sample["source"] || code_sample[:source])
      }
      |> Enum.reject(fn {_key, value} -> is_nil(value) end)
      |> Map.new()
    end)
  end

  defp normalize_code_samples(_code_samples), do: []

  defp alert_kind(line) do
    Enum.find(@alert_tags, fn tag -> line == "<#{tag}>" end)
  end

  defp put_alert(alerts, %{kind: "warning"} = alert),
    do: %{alerts | warning: alerts.warning ++ [alert]}

  defp put_alert(alerts, alert), do: %{alerts | info: alerts.info ++ [alert]}

  defp parse_heading(line) do
    {hashes, rest} = String.split_at(line, leading_hash_count(line))

    cond do
      hashes == "" ->
        nil

      String.starts_with?(rest, " ") ->
        %{level: String.length(hashes), heading: String.trim(rest)}

      true ->
        nil
    end
  end

  defp leading_hash_count(line), do: leading_hash_count(line, 0)

  defp leading_hash_count(<<"#", rest::binary>>, count), do: leading_hash_count(rest, count + 1)
  defp leading_hash_count(_line, count), do: count

  defp special_heading?(heading) do
    String.downcase(heading.heading || heading["heading"] || "") in ["limits", "errors"]
  end

  defp extract_title(body) when is_binary(body) do
    case String.split(body, "**", parts: 3) do
      ["", title, rest] ->
        %{title: String.trim(title), body: rest |> String.trim_leading() |> present()}

      _ ->
        %{title: nil, body: present(body)}
    end
  end

  defp extract_title(_body), do: %{title: nil, body: nil}

  defp join_bodies(bodies) do
    bodies
    |> Enum.map(&present/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n\n")
    |> present()
  end

  defp variable_line?(line), do: String.starts_with?(line, "export const ")
  defp alert_open?(line), do: line in Enum.map(@alert_tags, &"<#{&1}>")
  defp blank_line?(line), do: String.trim(line) == ""

  defp normalize_newlines(markdown) do
    String.replace(markdown, "\r\n", "\n")
  end

  defp present(value) when is_binary(value) do
    value
    |> String.trim()
    |> case do
      "" -> nil
      trimmed -> trimmed
    end
  end

  defp present(value), do: value
end
