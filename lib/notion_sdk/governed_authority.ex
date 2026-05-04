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
          base_url_ref: String.t(),
          authority_ref: String.t() | nil,
          tenant_ref: String.t(),
          provider_account_ref: String.t(),
          connector_instance_ref: String.t(),
          credential_handle_ref: String.t(),
          credential_ref: String.t(),
          credential_lease_ref: String.t(),
          target_ref: String.t(),
          request_scope_ref: String.t(),
          operation_policy_ref: String.t(),
          workspace_ref: String.t(),
          header_policy_ref: String.t(),
          redaction_ref: String.t() | nil,
          materialization_kind: String.t(),
          materialization_ref: String.t() | nil,
          bearer_token_ref: String.t() | nil,
          oauth_token_source_ref: String.t() | nil,
          headers: header_map(),
          credential_headers: header_map(),
          allowed_header_names: [String.t()]
        }

  @enforce_keys [
    :base_url,
    :base_url_ref,
    :tenant_ref,
    :provider_account_ref,
    :connector_instance_ref,
    :credential_handle_ref,
    :credential_ref,
    :credential_lease_ref,
    :target_ref,
    :request_scope_ref,
    :operation_policy_ref,
    :workspace_ref,
    :header_policy_ref,
    :materialization_kind,
    :credential_headers,
    :allowed_header_names
  ]
  defstruct base_url: nil,
            base_url_ref: nil,
            authority_ref: nil,
            tenant_ref: nil,
            provider_account_ref: nil,
            connector_instance_ref: nil,
            credential_handle_ref: nil,
            credential_ref: nil,
            credential_lease_ref: nil,
            target_ref: nil,
            request_scope_ref: nil,
            operation_policy_ref: nil,
            workspace_ref: nil,
            header_policy_ref: nil,
            redaction_ref: nil,
            materialization_kind: nil,
            materialization_ref: nil,
            bearer_token_ref: nil,
            oauth_token_source_ref: nil,
            headers: %{},
            credential_headers: %{},
            allowed_header_names: []

  @spec new!(t() | map() | keyword()) :: t()
  def new!(%__MODULE__{} = authority), do: validate!(authority)

  def new!(opts) when is_list(opts) do
    opts
    |> Map.new()
    |> new!()
  end

  def new!(%{} = opts) do
    reject_unmanaged_inputs!(opts)

    credential_handle_ref =
      required_ref!(opts, :credential_handle_ref, [
        "credential-handle://",
        "urn:credential-handle:"
      ])

    authority = %__MODULE__{
      base_url: required_string!(opts, :base_url),
      base_url_ref: required_ref!(opts, :base_url_ref, ["base-url://"]),
      authority_ref: optional_string(opts, :authority_ref),
      tenant_ref: required_ref!(opts, :tenant_ref, ["tenant://"]),
      provider_account_ref: required_ref!(opts, :provider_account_ref, ["provider-account://"]),
      connector_instance_ref:
        required_ref!(opts, :connector_instance_ref, ["connector-instance://"]),
      credential_handle_ref: credential_handle_ref,
      credential_ref: credential_handle_ref,
      credential_lease_ref: required_ref!(opts, :credential_lease_ref, ["credential-lease://"]),
      target_ref: required_ref!(opts, :target_ref, ["target://"]),
      request_scope_ref: required_ref!(opts, :request_scope_ref, ["request-scope://"]),
      operation_policy_ref: required_ref!(opts, :operation_policy_ref, ["operation-policy://"]),
      workspace_ref: required_ref!(opts, :workspace_ref, ["workspace://"]),
      header_policy_ref: required_ref!(opts, :header_policy_ref, ["header-policy://"]),
      redaction_ref: optional_string(opts, :redaction_ref),
      materialization_kind: required_string!(opts, :materialization_kind),
      materialization_ref: optional_string(opts, :materialization_ref),
      bearer_token_ref: optional_string(opts, :bearer_token_ref),
      oauth_token_source_ref: optional_string(opts, :oauth_token_source_ref),
      headers: normalize_headers(fetch_value(opts, :headers, %{})),
      credential_headers: normalize_headers(fetch_value(opts, :credential_headers, %{})),
      allowed_header_names: normalize_header_names(fetch_value(opts, :allowed_header_names, []))
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
      base_url_ref: authority.base_url_ref,
      authority_ref: authority.authority_ref,
      provider_account_ref: authority.provider_account_ref,
      connector_instance_ref: authority.connector_instance_ref,
      credential_handle_ref: authority.credential_handle_ref,
      credential_lease_ref: authority.credential_lease_ref,
      target_ref: authority.target_ref,
      request_scope_ref: authority.request_scope_ref,
      operation_policy_ref: authority.operation_policy_ref,
      header_policy_ref: authority.header_policy_ref,
      redaction_ref: authority.redaction_ref,
      materialization_kind: authority.materialization_kind,
      materialization_ref: authority.materialization_ref,
      bearer_token_ref: authority.bearer_token_ref,
      oauth_token_source_ref: authority.oauth_token_source_ref,
      headers: headers,
      credential_headers: authority.credential_headers,
      allowed_header_names: allowed_header_names(authority, headers)
    )
  end

  defp validate!(%__MODULE__{credential_headers: credential_headers} = authority) do
    if map_size(credential_headers) == 0 do
      raise ArgumentError, "governed authority requires credential_headers"
    end

    authority
  end

  defp reject_unmanaged_inputs!(opts) do
    [
      :api_key,
      :auth,
      :bearer,
      :default_auth,
      :default_client,
      :env,
      :middleware,
      :oauth2,
      :oauth_file,
      :oauth_token_source,
      :request_auth,
      :token,
      :token_file
    ]
    |> Enum.each(fn key ->
      if present?(fetch_value(opts, key, nil)) do
        raise ArgumentError, "governed authority rejects unmanaged #{key}"
      end
    end)
  end

  defp required_ref!(opts, key, allowed_prefixes) do
    value = required_string!(opts, key)

    if Enum.any?(allowed_prefixes, &String.starts_with?(value, &1)) do
      value
    else
      raise ArgumentError, "governed authority requires #{key} with an allowed ref prefix"
    end
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

  defp normalize_header_names(names) when is_list(names) do
    names
    |> Enum.map(&normalize_header_name/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.uniq()
  end

  defp normalize_header_names(_names), do: []

  defp normalize_header_name(name) do
    name
    |> to_string()
    |> String.trim()
    |> String.downcase()
  end

  defp allowed_header_names(%__MODULE__{} = authority, headers) do
    authority.allowed_header_names
    |> Kernel.++(["notion-version", "user-agent"])
    |> Kernel.++(Map.keys(authority.credential_headers))
    |> Kernel.++(Map.keys(headers))
    |> Enum.map(&normalize_header_name/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.uniq()
  end

  defp present?(nil), do: false
  defp present?(""), do: false
  defp present?([]), do: false
  defp present?(value) when is_map(value), do: map_size(value) > 0
  defp present?(_value), do: true
end
