defmodule NotionSDK.Helpers do
  @moduledoc """
  Notion-specific ID extraction helpers mirrored from the JS SDK.
  """

  @spec extract_notion_id(String.t()) :: String.t() | nil
  def extract_notion_id(url_or_id) when is_binary(url_or_id) do
    trimmed = String.trim(url_or_id)

    cond do
      trimmed == "" ->
        nil

      uuid?(trimmed) ->
        String.downcase(trimmed)

      compact_uuid?(trimmed) ->
        format_uuid(trimmed)

      path_id = path_compact_id(trimmed) ->
        format_uuid(path_id)

      query_id = query_compact_id(trimmed) ->
        format_uuid(query_id)

      compact_id = first_compact_uuid(trimmed) ->
        format_uuid(compact_id)

      true ->
        nil
    end
  end

  def extract_notion_id(_url_or_id), do: nil

  @spec extract_database_id(String.t()) :: String.t() | nil
  def extract_database_id(database_url), do: extract_notion_id(database_url)

  @spec extract_page_id(String.t()) :: String.t() | nil
  def extract_page_id(page_url), do: extract_notion_id(page_url)

  @spec extract_block_id(String.t()) :: String.t() | nil
  def extract_block_id(url_with_block) when is_binary(url_with_block) do
    url_with_block
    |> fragment()
    |> block_fragment_compact_id()
    |> format_uuid()
  end

  def extract_block_id(_url_with_block), do: nil

  defp uuid?(value) do
    case String.downcase(value) do
      <<a::binary-size(8), "-", b::binary-size(4), "-", c::binary-size(4), "-", d::binary-size(4),
        "-", e::binary-size(12)>> ->
        Enum.all?([a, b, c, d, e], &hex_binary?/1)

      _ ->
        false
    end
  end

  defp compact_uuid?(value), do: byte_size(value) == 32 and hex_binary?(value)

  defp path_compact_id(value) do
    value
    |> path_without_query_or_fragment()
    |> String.split("/")
    |> Enum.find_value(&segment_compact_id/1)
  end

  defp path_without_query_or_fragment(value) do
    value
    |> String.split("#", parts: 2)
    |> List.first()
    |> String.split("?", parts: 2)
    |> List.first()
  end

  defp segment_compact_id(segment) do
    segment
    |> String.split("-")
    |> List.last()
    |> case do
      value when is_binary(value) ->
        if compact_uuid?(value), do: value

      _ ->
        nil
    end
  end

  defp query_compact_id(value) do
    value
    |> query_string()
    |> String.split("&", trim: true)
    |> Enum.find_value(&query_pair_compact_id/1)
  end

  defp query_string(value) do
    case String.split(value, "?", parts: 2) do
      [_prefix, query_and_fragment] ->
        query_and_fragment
        |> String.split("#", parts: 2)
        |> List.first()

      _ ->
        ""
    end
  end

  defp query_pair_compact_id(pair) do
    case String.split(pair, "=", parts: 2) do
      [key, value] when key in ["p", "page_id", "database_id"] ->
        if compact_uuid?(value), do: value

      [key, value] ->
        key = String.downcase(key)

        if key in ["p", "page_id", "database_id"] and compact_uuid?(value) do
          value
        end

      _ ->
        nil
    end
  end

  defp first_compact_uuid(value) when byte_size(value) < 32, do: nil

  defp first_compact_uuid(value) do
    candidate = binary_part(value, 0, 32)

    if compact_uuid?(candidate) do
      candidate
    else
      <<_first, rest::binary>> = value
      first_compact_uuid(rest)
    end
  end

  defp fragment(value) do
    case String.split(value, "#", parts: 2) do
      [_prefix, fragment] -> fragment
      _ -> ""
    end
  end

  defp block_fragment_compact_id("block-" <> compact_id) do
    if compact_uuid?(compact_id), do: compact_id
  end

  defp block_fragment_compact_id(compact_id) do
    if compact_uuid?(compact_id), do: compact_id
  end

  defp format_uuid(compact_id) do
    clean = compact_id && String.downcase(compact_id)

    case clean do
      <<a::binary-size(8), b::binary-size(4), c::binary-size(4), d::binary-size(4),
        e::binary-size(12)>> ->
        "#{a}-#{b}-#{c}-#{d}-#{e}"

      _ ->
        nil
    end
  end

  defp hex_binary?(value) do
    value
    |> String.downcase()
    |> do_hex_binary?()
  end

  defp do_hex_binary?(""), do: true

  defp do_hex_binary?(<<char, rest::binary>>) do
    hex_char?(char) and do_hex_binary?(rest)
  end

  defp hex_char?(char), do: char in ?0..?9 or char in ?a..?f
end
