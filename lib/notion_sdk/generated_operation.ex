defmodule NotionSDK.GeneratedOperation do
  @moduledoc false

  @type key_spec :: {String.t(), atom()}

  @type payload_spec ::
          %{mode: :keys, keys: [key_spec()]}
          | %{mode: :key, key: key_spec()}
          | %{mode: :remaining}
          | %{mode: :none}

  @type partition_spec :: %{
          optional(:auth) => key_spec(),
          optional(:path) => [key_spec()],
          optional(:query) => [key_spec()],
          optional(:body) => payload_spec(),
          optional(:form_data) => payload_spec()
        }

  @type partition_t :: %{
          path_params: map(),
          query: map(),
          body: term(),
          form_data: term(),
          auth: term()
        }

  @spec partition(map(), partition_spec()) :: partition_t()
  def partition(params, spec) when is_map(params) and is_map(spec) do
    {auth, params} = take_value(params, Map.get(spec, :auth))
    {path_params, params} = take_entries(params, Map.get(spec, :path, []))
    {query, params} = take_entries(params, Map.get(spec, :query, []))
    {body, params} = take_payload(params, Map.get(spec, :body, %{mode: :none}))
    {form_data, _params} = take_payload(params, Map.get(spec, :form_data, %{mode: :none}))

    %{
      path_params: path_params,
      query: query,
      body: body,
      form_data: form_data,
      auth: auth
    }
  end

  @spec render_path(String.t(), map()) :: String.t()
  def render_path(path_template, path_params)
      when is_binary(path_template) and is_map(path_params) do
    Regex.replace(~r/\{([^}]+)\}/, path_template, fn _full, name ->
      case Map.fetch(path_params, name) do
        {:ok, value} when not is_nil(value) -> encode_path_value(value)
        _ -> raise KeyError, key: name, term: path_params
      end
    end)
  end

  defp take_payload(params, %{mode: :none}), do: {%{}, params}
  defp take_payload(params, %{mode: :remaining}), do: {stringify_map(params), %{}}
  defp take_payload(params, %{mode: :keys, keys: keys}), do: take_entries(params, keys)

  defp take_payload(params, %{mode: :key, key: key}) do
    case take_value(params, key) do
      {nil, params} -> {%{}, params}
      {value, params} -> {normalize_payload(value), params}
    end
  end

  defp take_entries(params, keys) do
    Enum.reduce(keys, {%{}, params}, fn key, {acc, remaining_params} ->
      case take_value(remaining_params, key) do
        {nil, updated_params} ->
          {acc, updated_params}

        {value, updated_params} ->
          {Map.put(acc, elem(key, 0), value), updated_params}
      end
    end)
  end

  defp take_value(params, nil), do: {nil, params}

  defp take_value(params, {string_key, atom_key}) do
    cond do
      Map.has_key?(params, atom_key) ->
        {Map.fetch!(params, atom_key), Map.delete(params, atom_key)}

      Map.has_key?(params, string_key) ->
        {Map.fetch!(params, string_key), Map.delete(params, string_key)}

      true ->
        {nil, params}
    end
  end

  defp normalize_payload(value) when is_map(value), do: stringify_map(value)
  defp normalize_payload(value), do: value

  defp stringify_map(value) when is_map(value) do
    Map.new(value, fn {key, item} -> {to_string(key), item} end)
  end

  defp encode_path_value(value) when is_list(value), do: Enum.map_join(value, ",", &to_string/1)
  defp encode_path_value(value), do: to_string(value)
end
