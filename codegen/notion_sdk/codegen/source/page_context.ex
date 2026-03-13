defmodule NotionSDK.Codegen.Source.PageContext do
  @moduledoc """
  Deterministic page-context extracted from a Notion reference markdown page.
  """

  @type entry :: %{
          optional(:heading) => String.t() | nil,
          optional(:title) => String.t() | nil,
          optional(:kind) => String.t() | nil,
          optional(:level) => pos_integer() | nil,
          optional(:body) => String.t() | nil,
          optional(:items) => [String.t()]
        }

  @type resource :: %{
          required(:label) => String.t(),
          required(:url) => String.t(),
          optional(:kind) => String.t()
        }

  @type code_sample :: %{
          optional(:language) => String.t() | nil,
          optional(:label) => String.t() | nil,
          optional(:source) => String.t() | nil
        }

  @type t :: %__MODULE__{
          slug: String.t(),
          title: String.t(),
          method: String.t(),
          path: String.t(),
          operation_id: String.t() | nil,
          lead: String.t() | nil,
          summary: String.t() | nil,
          description: String.t() | nil,
          source_url: String.t(),
          warnings: [entry()],
          info_notes: [entry()],
          limits: [entry()],
          errors: [entry()],
          sections: [entry()],
          code_samples: [code_sample()],
          resources: [resource()]
        }

  @enforce_keys [
    :slug,
    :title,
    :method,
    :path,
    :operation_id,
    :lead,
    :summary,
    :description,
    :source_url,
    :warnings,
    :info_notes,
    :limits,
    :errors,
    :sections,
    :code_samples,
    :resources
  ]
  defstruct [
    :slug,
    :title,
    :method,
    :path,
    :operation_id,
    :lead,
    :summary,
    :description,
    :source_url,
    :warnings,
    :info_notes,
    :limits,
    :errors,
    :sections,
    :code_samples,
    :resources
  ]

  @spec source_url(String.t()) :: String.t()
  def source_url(slug) when is_binary(slug) do
    "https://developers.notion.com/reference/#{slug}"
  end

  @spec to_artifact(t()) :: map()
  def to_artifact(%__MODULE__{} = page_context) do
    page_context
    |> Map.from_struct()
    |> Map.update!(:warnings, fn entries -> Enum.map(entries, &normalize_entry/1) end)
    |> Map.update!(:info_notes, fn entries -> Enum.map(entries, &normalize_entry/1) end)
    |> Map.update!(:limits, fn entries -> Enum.map(entries, &normalize_entry/1) end)
    |> Map.update!(:errors, fn entries -> Enum.map(entries, &normalize_entry/1) end)
    |> Map.update!(:sections, fn entries -> Enum.map(entries, &normalize_entry/1) end)
    |> Map.update!(:code_samples, fn entries -> Enum.map(entries, &normalize_code_sample/1) end)
    |> Map.update!(:resources, fn entries -> Enum.map(entries, &normalize_resource/1) end)
  end

  @spec to_source_context(t()) :: map()
  def to_source_context(%__MODULE__{} = page_context) do
    artifact = to_artifact(page_context)

    %{
      title: page_context.title,
      summary: page_context.summary,
      description: page_context.description,
      source_url: page_context.source_url,
      code_samples: page_context.code_samples,
      slug: page_context.slug,
      method: page_context.method,
      path: page_context.path,
      operation_id: page_context.operation_id,
      lead: page_context.lead,
      warnings: artifact.warnings,
      info_notes: artifact.info_notes,
      limits: artifact.limits,
      errors: artifact.errors,
      sections: artifact.sections,
      resources: artifact.resources
    }
  end

  @spec build_description(t()) :: String.t() | nil
  def build_description(%__MODULE__{} = page_context) do
    [
      present(page_context.lead),
      render_group("Warnings", page_context.warnings),
      render_group("Notes", page_context.info_notes),
      render_sections(page_context.sections),
      render_group("Limits", page_context.limits),
      render_group("Errors", page_context.errors),
      render_resources(page_context.resources)
    ]
    |> Enum.reject(&blank?/1)
    |> Enum.join("\n\n")
    |> present()
  end

  defp render_group(_heading, []), do: nil

  defp render_group(heading, entries) do
    blocks =
      entries
      |> Enum.map(&entry_markdown/1)
      |> Enum.reject(&blank?/1)
      |> Enum.join("\n\n")

    if blank?(blocks) do
      nil
    else
      ["### #{heading}", blocks]
      |> Enum.join("\n\n")
    end
  end

  defp render_sections([]), do: nil

  defp render_sections(sections) do
    sections
    |> Enum.map(fn section ->
      heading =
        case present(section[:heading]) do
          nil -> nil
          title -> "### #{title}"
        end

      [heading, entry_markdown(section)]
      |> Enum.reject(&blank?/1)
      |> Enum.join("\n\n")
    end)
    |> Enum.reject(&blank?/1)
    |> Enum.join("\n\n")
    |> present()
  end

  defp render_resources([]), do: nil

  defp render_resources(resources) do
    items =
      resources
      |> Enum.map(fn resource ->
        label = resource[:label] || resource["label"] || "Resource"
        url = resource[:url] || resource["url"]
        "  * [#{label}](#{url})"
      end)
      |> Enum.join("\n")

    ["### Resources", items]
    |> Enum.join("\n\n")
  end

  defp entry_markdown(entry) do
    lines =
      [
        present(entry[:title] || entry["title"]),
        present(entry[:body] || entry["body"]),
        render_items(entry[:items] || entry["items"] || [])
      ]
      |> Enum.reject(&blank?/1)

    Enum.join(lines, "\n\n")
  end

  defp render_items([]), do: nil

  defp render_items(items) do
    Enum.map_join(items, "\n", &"  * #{&1}")
  end

  defp normalize_entry(entry) when is_map(entry) do
    %{
      heading: present(Map.get(entry, :heading) || Map.get(entry, "heading")),
      title: present(Map.get(entry, :title) || Map.get(entry, "title")),
      kind: present(Map.get(entry, :kind) || Map.get(entry, "kind")),
      level: Map.get(entry, :level) || Map.get(entry, "level"),
      body: present(Map.get(entry, :body) || Map.get(entry, "body")),
      items: normalize_items(Map.get(entry, :items) || Map.get(entry, "items") || [])
    }
    |> Enum.reject(fn {_key, value} -> value in [nil, []] end)
    |> Map.new()
  end

  defp normalize_resource(resource) when is_map(resource) do
    %{
      label: Map.get(resource, :label) || Map.get(resource, "label") || "Resource",
      url: Map.get(resource, :url) || Map.get(resource, "url"),
      kind: present(Map.get(resource, :kind) || Map.get(resource, "kind"))
    }
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp normalize_code_sample(code_sample) when is_map(code_sample) do
    %{
      language:
        present(Map.get(code_sample, :language) || Map.get(code_sample, "language")) ||
          present(Map.get(code_sample, :lang) || Map.get(code_sample, "lang")),
      label: present(Map.get(code_sample, :label) || Map.get(code_sample, "label")),
      source: present(Map.get(code_sample, :source) || Map.get(code_sample, "source"))
    }
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp normalize_items(items) when is_list(items) do
    items
    |> Enum.map(&present/1)
    |> Enum.reject(&is_nil/1)
  end

  defp normalize_items(_items), do: []

  defp blank?(value), do: present(value) in [nil, ""]

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
