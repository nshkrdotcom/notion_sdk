defmodule NotionSDK.Pagination do
  @moduledoc """
  Cursor-pagination helpers for Notion list APIs.
  """

  @type data_source_template :: NotionSDK.DataSources.list_templates_200_json_resp_templates()

  @spec collect_paginated_api(
          (NotionSDK.Client.t(), map() -> {:ok, map()} | {:error, term()}),
          NotionSDK.Client.t(),
          map()
        ) ::
          {:ok, [term()]} | {:error, term()}
  def collect_paginated_api(list_fun, client, first_page_args)
      when is_function(list_fun, 2) and is_map(first_page_args) do
    do_collect(list_fun, client, first_page_args, [])
  end

  @spec iterate_paginated_api(
          (NotionSDK.Client.t(), map() -> {:ok, map()} | {:error, term()}),
          NotionSDK.Client.t(),
          map()
        ) ::
          Enumerable.t()
  def iterate_paginated_api(list_fun, client, first_page_args)
      when is_function(list_fun, 2) and is_map(first_page_args) do
    Stream.resource(
      fn -> first_page_args end,
      fn
        :done ->
          {:halt, :done}

        params ->
          case list_fun.(client, params) do
            {:ok, %{"has_more" => true, "next_cursor" => next_cursor, "results" => results}} ->
              {results, put_cursor(params, next_cursor)}

            {:ok, %{"results" => results}} ->
              {results, :done}

            {:error, error} ->
              raise error
          end
      end,
      fn _state -> :ok end
    )
  end

  @spec collect_data_source_templates(NotionSDK.Client.t(), map()) ::
          {:ok, [data_source_template()]} | {:error, NotionSDK.Error.t()}
  def collect_data_source_templates(client, args) when is_map(args) do
    do_collect_templates(client, enable_typed_responses(args), [])
  end

  @spec iterate_data_source_templates(NotionSDK.Client.t(), map()) :: Enumerable.t()
  def iterate_data_source_templates(client, args) when is_map(args) do
    Stream.resource(
      fn -> enable_typed_responses(args) end,
      fn
        :done ->
          {:halt, :done}

        params ->
          case NotionSDK.DataSources.list_templates(client, params) do
            {:ok, %{next_cursor: next_cursor, templates: templates}}
            when is_binary(next_cursor) ->
              {templates, put_cursor(params, next_cursor)}

            {:ok, %{templates: templates}} ->
              {templates, :done}

            {:error, error} ->
              raise error
          end
      end,
      fn _state -> :ok end
    )
  end

  defp do_collect(list_fun, client, params, acc) do
    case list_fun.(client, params) do
      {:ok, %{"has_more" => true, "next_cursor" => next_cursor, "results" => results}} ->
        do_collect(list_fun, client, put_cursor(params, next_cursor), acc ++ results)

      {:ok, %{"results" => results}} ->
        {:ok, acc ++ results}

      {:error, _error} = error ->
        error
    end
  end

  defp do_collect_templates(client, params, acc) do
    case NotionSDK.DataSources.list_templates(client, params) do
      {:ok, %{next_cursor: next_cursor, templates: templates}}
      when is_binary(next_cursor) ->
        do_collect_templates(client, put_cursor(params, next_cursor), acc ++ templates)

      {:ok, %{templates: templates}} ->
        {:ok, acc ++ templates}

      {:error, _error} = error ->
        error
    end
  end

  defp enable_typed_responses(params) when is_map(params) do
    Map.put(params, :typed_responses, true)
  end

  defp put_cursor(params, cursor) when is_binary(cursor) do
    Map.put(params, "start_cursor", cursor)
  end

  defp put_cursor(params, _cursor), do: params
end
