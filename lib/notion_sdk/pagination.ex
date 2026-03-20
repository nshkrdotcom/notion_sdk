defmodule NotionSDK.Pagination do
  @moduledoc """
  Cursor-pagination helpers for Notion list APIs.
  """

  @type data_source_template :: %{
          required(:id) => String.t(),
          required(:is_default) => boolean(),
          required(:name) => String.t()
        }
  @type reduce_step(acc) :: {:cont, acc} | {:halt, acc}

  @spec collect_paginated_api(
          (NotionSDK.Client.t(), map() -> {:ok, map()} | {:error, term()}),
          NotionSDK.Client.t(),
          map()
        ) ::
          {:ok, [term()]} | {:error, term()}
  def collect_paginated_api(list_fun, client, first_page_args)
      when is_function(list_fun, 2) and is_map(first_page_args) do
    with {:ok, results} <-
           reduce_paginated_api(list_fun, client, first_page_args, [], fn item, acc ->
             {:cont, [item | acc]}
           end) do
      {:ok, Enum.reverse(results)}
    end
  end

  @spec reduce_paginated_api(
          (NotionSDK.Client.t(), map() -> {:ok, map()} | {:error, term()}),
          NotionSDK.Client.t(),
          map(),
          acc,
          (term(), acc -> reduce_step(acc))
        ) ::
          {:ok, acc} | {:error, term()}
        when acc: var
  def reduce_paginated_api(list_fun, client, first_page_args, acc, reducer)
      when is_function(list_fun, 2) and is_map(first_page_args) and is_function(reducer, 2) do
    first_page_args
    |> reduce_items(acc, reducer, fn params -> fetch_paginated_page(list_fun, client, params) end)
  end

  @spec iterate_paginated_api(
          (NotionSDK.Client.t(), map() -> {:ok, map()} | {:error, term()}),
          NotionSDK.Client.t(),
          map()
        ) ::
          Enumerable.t()
  def iterate_paginated_api(list_fun, client, first_page_args)
      when is_function(list_fun, 2) and is_map(first_page_args) do
    stream_items(first_page_args, fn params -> fetch_paginated_page(list_fun, client, params) end)
  end

  @spec collect_data_source_templates(NotionSDK.Client.t(), map()) ::
          {:ok, [data_source_template()]} | {:error, NotionSDK.Error.t()}
  def collect_data_source_templates(client, args) when is_map(args) do
    with {:ok, templates} <-
           reduce_data_source_templates(client, args, [], fn template, acc ->
             {:cont, [template | acc]}
           end) do
      {:ok, Enum.reverse(templates)}
    end
  end

  @spec reduce_data_source_templates(
          NotionSDK.Client.t(),
          map(),
          acc,
          (data_source_template(), acc -> reduce_step(acc))
        ) ::
          {:ok, acc} | {:error, NotionSDK.Error.t()}
        when acc: var
  def reduce_data_source_templates(client, args, acc, reducer)
      when is_map(args) and is_function(reducer, 2) do
    args
    |> enable_typed_responses()
    |> reduce_items(acc, reducer, &fetch_data_source_template_page(client, &1))
  end

  @spec iterate_data_source_templates(NotionSDK.Client.t(), map()) :: Enumerable.t()
  def iterate_data_source_templates(client, args) when is_map(args) do
    args
    |> enable_typed_responses()
    |> stream_items(&fetch_data_source_template_page(client, &1))
  end

  defp stream_items(first_page_args, fetch_page) do
    Stream.resource(
      fn -> first_page_args end,
      fn
        :done ->
          {:halt, :done}

        params ->
          case fetch_page.(params) do
            {:ok, results, next_params} -> {results, next_params}
            {:error, error} -> raise error
          end
      end,
      fn _state -> :ok end
    )
  end

  defp reduce_items(params, acc, reducer, fetch_page) do
    case fetch_page.(params) do
      {:ok, results, next_params} ->
        case reduce_page(results, acc, reducer) do
          {:cont, next_acc} when next_params == :done ->
            {:ok, next_acc}

          {:cont, next_acc} ->
            reduce_items(next_params, next_acc, reducer, fetch_page)

          {:halt, next_acc} ->
            {:ok, next_acc}
        end

      {:error, _error} = error ->
        error
    end
  end

  defp reduce_page(results, acc, reducer) do
    Enum.reduce_while(results, {:cont, acc}, fn result, {_status, current_acc} ->
      case reducer.(result, current_acc) do
        {:cont, next_acc} -> {:cont, {:cont, next_acc}}
        {:halt, next_acc} -> {:halt, {:halt, next_acc}}
      end
    end)
  end

  defp fetch_paginated_page(list_fun, client, params) do
    case list_fun.(client, params) do
      {:ok, %{"has_more" => true, "next_cursor" => next_cursor, "results" => results}}
      when is_binary(next_cursor) ->
        {:ok, results, put_cursor(params, next_cursor)}

      {:ok, %{"results" => results}} ->
        {:ok, results, :done}

      {:error, _error} = error ->
        error
    end
  end

  defp fetch_data_source_template_page(client, params) do
    case NotionSDK.DataSources.list_templates(client, params) do
      {:ok, page} ->
        normalize_template_page(page, params)

      {:error, _error} = error ->
        error
    end
  end

  defp normalize_template_page(%{next_cursor: next_cursor, templates: templates}, params)
       when is_binary(next_cursor) do
    {:ok, templates, put_cursor(params, next_cursor)}
  end

  defp normalize_template_page(%{templates: templates}, _params) do
    {:ok, templates, :done}
  end

  defp normalize_template_page(%{"templates" => _templates} = page, params) do
    case NotionSDK.DataSources.decode(page, :list_templates_200_json_resp) do
      {:ok, decoded_page} ->
        normalize_template_page(decoded_page, params)

      {:error, _reason} = error ->
        error
    end
  end

  defp enable_typed_responses(params) when is_map(params) do
    Map.put(params, :typed_responses, true)
  end

  defp put_cursor(params, cursor) when is_binary(cursor) do
    Map.put(params, "start_cursor", cursor)
  end
end
