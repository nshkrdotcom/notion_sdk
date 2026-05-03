defmodule NotionSDK.GovernedAuthority do
  @moduledoc """
  Authority-materialized Notion inputs for governed execution.

  Standalone Notion SDK usage keeps using direct bearer tokens, OAuth token
  sources, saved token files, app config defaults, and request auth overrides.
  Governed usage passes this value after an external authority has selected the
  credential, lease, target, workspace, redaction policy, base URL, and
  materialized credential headers for one bounded effect.
  """

  @type header_map :: %{optional(String.t()) => String.t()}

  @type t :: %__MODULE__{
          base_url: String.t(),
          credential_ref: String.t(),
          credential_lease_ref: String.t(),
          target_ref: String.t(),
          workspace_ref: String.t(),
          redaction_ref: String.t() | nil,
          headers: header_map(),
          credential_headers: header_map()
        }

  @enforce_keys [
    :base_url,
    :credential_ref,
    :credential_lease_ref,
    :target_ref,
    :workspace_ref,
    :credential_headers
  ]
  defstruct base_url: nil,
            credential_ref: nil,
            credential_lease_ref: nil,
            target_ref: nil,
            workspace_ref: nil,
            redaction_ref: nil,
            headers: %{},
            credential_headers: %{}

  @spec new!(t() | map() | keyword()) :: t()
  def new!(%__MODULE__{} = authority), do: validate!(authority)

  def new!(opts) when is_list(opts) do
    opts
    |> Map.new()
    |> new!()
  end

  def new!(%{} = opts) do
    authority = %__MODULE__{
      base_url: required_string!(opts, :base_url),
      credential_ref: required_string!(opts, :credential_ref),
      credential_lease_ref: required_string!(opts, :credential_lease_ref),
      target_ref: required_string!(opts, :target_ref),
      workspace_ref: required_string!(opts, :workspace_ref),
      redaction_ref: optional_string(opts, :redaction_ref),
      headers: normalize_headers(fetch_value(opts, :headers, %{})),
      credential_headers: normalize_headers(fetch_value(opts, :credential_headers, %{}))
    }

    validate!(authority)
  end

  @spec to_pristine(t(), keyword()) :: Pristine.GovernedAuthority.t()
  def to_pristine(%__MODULE__{} = authority, opts \\ []) when is_list(opts) do
    headers =
      authority.headers
      |> Map.put_new("Notion-Version", Keyword.fetch!(opts, :notion_version))
      |> Map.put_new("User-Agent", Keyword.fetch!(opts, :user_agent))

    Pristine.GovernedAuthority.new!(
      base_url: authority.base_url,
      credential_ref: authority.credential_ref,
      credential_lease_ref: authority.credential_lease_ref,
      target_ref: authority.target_ref,
      redaction_ref: authority.redaction_ref,
      headers: headers,
      credential_headers: authority.credential_headers
    )
  end

  defp validate!(%__MODULE__{credential_headers: credential_headers} = authority) do
    if map_size(credential_headers) == 0 do
      raise ArgumentError, "governed authority requires credential_headers"
    end

    authority
  end

  defp required_string!(opts, key) do
    case optional_string(opts, key) do
      value when is_binary(value) and value != "" ->
        value

      _other ->
        raise ArgumentError, "governed authority requires #{key}"
    end
  end

  defp optional_string(opts, key) do
    case fetch_value(opts, key, nil) do
      value when is_binary(value) -> value
      value when is_atom(value) -> Atom.to_string(value)
      nil -> nil
      value -> to_string(value)
    end
  end

  defp fetch_value(opts, key, default) when is_map(opts) do
    string_key = Atom.to_string(key)

    cond do
      Map.has_key?(opts, key) -> Map.get(opts, key)
      Map.has_key?(opts, string_key) -> Map.get(opts, string_key)
      true -> default
    end
  end

  defp normalize_headers(headers) when is_map(headers) do
    Map.new(headers, fn {name, value} -> {to_string(name), to_string(value)} end)
  end

  defp normalize_headers(headers) when is_list(headers) do
    if Enum.all?(headers, &tuple_pair?/1) do
      Map.new(headers, fn {name, value} -> {to_string(name), to_string(value)} end)
    else
      %{}
    end
  end

  defp normalize_headers(_headers), do: %{}

  defp tuple_pair?({_name, _value}), do: true
  defp tuple_pair?(_entry), do: false
end
