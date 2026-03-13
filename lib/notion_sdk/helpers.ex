defmodule NotionSDK.Helpers do
  @moduledoc """
  Notion-specific ID extraction helpers mirrored from the JS SDK.
  """

  @uuid_regex ~r/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
  @compact_uuid_regex ~r/^[0-9a-f]{32}$/i

  @spec extract_notion_id(String.t()) :: String.t() | nil
  def extract_notion_id(url_or_id) when is_binary(url_or_id) do
    trimmed = String.trim(url_or_id)

    cond do
      trimmed == "" ->
        nil

      Regex.match?(@uuid_regex, trimmed) ->
        String.downcase(trimmed)

      Regex.match?(@compact_uuid_regex, trimmed) ->
        format_uuid(trimmed)

      match =
          Regex.run(~r/\/[^\/?#]*-([0-9a-f]{32})(?:[\/?#]|$)/i, trimmed, capture: :all_but_first) ->
        format_uuid(List.first(match))

      match =
          Regex.run(~r/[?&](?:p|page_id|database_id)=([0-9a-f]{32})/i, trimmed,
            capture: :all_but_first
          ) ->
        format_uuid(List.first(match))

      match = Regex.run(~r/([0-9a-f]{32})/i, trimmed, capture: :all_but_first) ->
        format_uuid(List.first(match))

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
    case Regex.run(~r/#(?:block-)?([0-9a-f]{32})/i, url_with_block, capture: :all_but_first) do
      [compact_id] -> format_uuid(compact_id)
      _ -> nil
    end
  end

  def extract_block_id(_url_with_block), do: nil

  defp format_uuid(compact_id) do
    clean = String.downcase(compact_id)

    case clean do
      <<a::binary-size(8), b::binary-size(4), c::binary-size(4), d::binary-size(4),
        e::binary-size(12)>> ->
        "#{a}-#{b}-#{c}-#{d}-#{e}"

      _ ->
        nil
    end
  end
end
