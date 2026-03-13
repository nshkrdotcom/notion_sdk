defmodule NotionSDK.Client do
  @moduledoc """
  Thin Notion client configuration layered on top of Pristine runtime execution.
  """

  alias Pristine.Adapters.Auth.{Bearer, OAuth2}
  alias Pristine.Core.Context
  alias Pristine.Manifest.Endpoint

  @default_base_url "https://api.notion.com"
  @default_log_level :warn
  @default_notion_version "2025-09-03"
  @default_timeout_ms 60_000
  @default_breaker_group "core_api"
  @default_retry %{
    max_retries: 2,
    initial_retry_delay_ms: 1_000,
    max_retry_delay_ms: 60_000
  }
  @retry_groups [
    "notion.read",
    "notion.delete",
    "notion.write",
    "notion.file_upload_send",
    "notion.oauth_control"
  ]

  @type retry_settings :: %{
          required(:initial_retry_delay_ms) => pos_integer(),
          required(:max_retries) => non_neg_integer(),
          required(:max_retry_delay_ms) => pos_integer()
        }

  @type retry_config :: false | retry_settings()

  @type oauth2_config ::
          [
            {:token_source, {module(), keyword()} | module()}
            | {:allow_stale?, boolean()}
          ]

  @type generated_request_t :: %{
          required(:args) => map(),
          required(:call) => {module(), atom()},
          required(:method) => atom(),
          required(:path_template) => String.t(),
          required(:url) => String.t(),
          required(:path_params) => map(),
          required(:query) => map(),
          required(:body) => term(),
          required(:form_data) => term(),
          optional(:auth) => term(),
          optional(:circuit_breaker) => String.t(),
          optional(:security) => [map()] | nil,
          optional(:headers) => map(),
          optional(:rate_limit) => String.t(),
          optional(:resource) => String.t(),
          optional(:request) => [{String.t(), term()}],
          optional(:response) => [{integer() | :default, term()}],
          optional(:retry) => String.t(),
          optional(:retry_opts) => keyword(),
          optional(:telemetry) => String.t(),
          optional(:timeout) => pos_integer()
        }

  @type raw_request_t :: %{
          required(:method) => atom(),
          required(:path) => String.t(),
          optional(:path_params) => map(),
          optional(:query) => map(),
          optional(:body) => term() | nil,
          optional(:form_data) => term() | nil,
          optional(:headers) => map(),
          optional(:auth) => term(),
          optional(:security) => [map()] | nil,
          optional(:request_schema) => term() | nil,
          optional(:response_schema) => term() | nil,
          optional(:id) => String.t() | nil,
          optional(:typed_responses) => boolean(),
          optional(:circuit_breaker) => String.t() | nil,
          optional(:rate_limit) => String.t() | nil,
          optional(:resource) => String.t() | nil,
          optional(:retry) => String.t() | nil,
          optional(:retry_opts) => keyword(),
          optional(:telemetry) => String.t() | nil,
          optional(:timeout) => pos_integer()
        }

  @type request_t :: generated_request_t() | raw_request_t()

  @type t :: %__MODULE__{
          auth: String.t() | nil,
          base_url: String.t(),
          context: Context.t(),
          foundation: map() | nil,
          log_level: :debug | :info | :warn | :error | nil,
          logger: (atom(), String.t(), map() -> term()) | nil,
          notion_version: String.t(),
          retry: retry_config(),
          timeout_ms: pos_integer(),
          transport: module(),
          transport_opts: keyword(),
          oauth2: oauth2_config() | nil,
          typed_responses: boolean(),
          user_agent: String.t()
        }

  defstruct [
    :auth,
    :base_url,
    :context,
    :foundation,
    :log_level,
    :logger,
    :notion_version,
    :retry,
    :timeout_ms,
    :transport,
    :transport_opts,
    :oauth2,
    :typed_responses,
    :user_agent
  ]

  @spec default_notion_version() :: String.t()
  def default_notion_version, do: @default_notion_version

  @spec new(String.t(), keyword()) :: t()
  def new(auth, opts) when is_binary(auth) and is_list(opts) do
    new(Keyword.put(opts, :auth, auth))
  end

  @spec new(keyword()) :: t()
  def new(opts \\ []) when is_list(opts) do
    auth = Keyword.get(opts, :auth)
    base_url = Keyword.get(opts, :base_url, config(:base_url, @default_base_url))

    notion_version =
      Keyword.get(opts, :notion_version, config(:notion_version, @default_notion_version))

    timeout_ms = Keyword.get(opts, :timeout_ms, config(:timeout_ms, @default_timeout_ms))
    log_level = Keyword.get(opts, :log_level, @default_log_level)
    logger = Keyword.get(opts, :logger)
    transport = Keyword.get(opts, :transport, Pristine.Adapters.Transport.Finch)

    transport_opts =
      normalize_transport_opts(
        transport,
        Keyword.get(opts, :transport_opts, []),
        Keyword.get(opts, :finch, NotionSDK.Finch)
      )

    typed_responses = Keyword.get(opts, :typed_responses, false)
    user_agent = Keyword.get(opts, :user_agent, config(:user_agent, default_user_agent()))
    retry = normalize_retry(Keyword.get(opts, :retry, config(:retry, @default_retry)))
    oauth2 = normalize_oauth2(Keyword.get(opts, :oauth2))
    foundation = normalize_foundation(Keyword.get(opts, :foundation), auth, oauth2)

    client = %__MODULE__{
      auth: auth,
      base_url: base_url,
      log_level: log_level,
      logger: logger,
      notion_version: notion_version,
      foundation: foundation,
      retry: retry,
      timeout_ms: timeout_ms,
      transport: transport,
      transport_opts: transport_opts,
      oauth2: oauth2,
      typed_responses: typed_responses,
      user_agent: user_agent
    }

    %{client | context: build_context(client)}
  end

  @spec request(t(), request_t()) :: {:ok, term()} | {:error, NotionSDK.Error.t()}
  def request(%__MODULE__{} = client, request) when is_map(request) do
    cond do
      generated_request?(request) ->
        execute_generated_request(client, request)

      raw_request?(request) ->
        execute_raw_request(client, request)

      true ->
        raise ArgumentError,
              "expected generated request shape or raw request spec, got: #{inspect(request)}"
    end
  end

  def request(other, _request) do
    raise ArgumentError, "expected NotionSDK.Client, got: #{inspect(other)}"
  end

  defp execute_generated_request(%__MODULE__{} = client, request) do
    typed_runtime? = typed_runtime_enabled?(client, request)
    endpoint = build_endpoint(client, request, typed_runtime?)
    {payload, body_type, content_type} = request_payload(request, endpoint.method)

    execute_opts =
      []
      |> Keyword.put(:path, request[:path_template] || request[:url])
      |> Keyword.put(:path_params, normalize_map(request[:path_params]))
      |> maybe_put(:auth, request[:auth])
      |> maybe_put(:headers, request[:headers])
      |> maybe_put(:query, normalize_map(request[:query]))
      |> maybe_put(:retry_opts, request[:retry_opts])
      |> maybe_put(:body_type, body_type)
      |> maybe_put(:content_type, content_type)
      |> maybe_put(:typed_responses, typed_runtime?)

    Pristine.execute_endpoint(endpoint, payload, client.context, execute_opts)
  end

  defp execute_raw_request(%__MODULE__{} = client, request) do
    typed_runtime? = typed_runtime_enabled?(client, request)
    request_spec = build_request_spec(client, request, typed_runtime?)

    execute_opts =
      []
      |> maybe_put(:retry_opts, request[:retry_opts])
      |> maybe_put(:typed_responses, typed_runtime?)

    Pristine.execute_request(request_spec, client.context, execute_opts)
  end

  defp build_context(%__MODULE__{} = client) do
    foundation = client.foundation

    Pristine.foundation_context(
      auth: default_auth(client.auth, client.oauth2),
      admission_control: admission_control_profile(foundation),
      base_url: client.base_url,
      circuit_breaker: circuit_breaker_profile(foundation),
      default_timeout: client.timeout_ms,
      error_module: NotionSDK.Error,
      headers: %{
        "Notion-Version" => client.notion_version,
        "User-Agent" => client.user_agent
      },
      log_level: client.log_level,
      logger: client.logger,
      package_version: package_version(),
      retry: retry_profile(client.retry),
      result_classifier: NotionSDK.ResultClassifier,
      rate_limit: rate_limit_profile(foundation),
      serializer: Pristine.Adapters.Serializer.JSON,
      telemetry: telemetry_profile(foundation),
      pool_base: foundation_value(foundation, :pool_base),
      pool_manager: foundation_value(foundation, :pool_manager),
      transport: client.transport,
      transport_opts: client.transport_opts
    )
  end

  defp build_endpoint(%__MODULE__{} = client, request, typed_runtime?) do
    resource = request[:resource] || resource_group(request)
    retry_group = request[:retry] || retry_group(request, resource)
    circuit_breaker = resolve_circuit_breaker(client, request[:circuit_breaker], resource)

    %Endpoint{
      id: request_id(request),
      method: request[:method],
      path: request[:path_template] || request[:url],
      body_type: nil,
      circuit_breaker: circuit_breaker,
      content_type: nil,
      headers: %{},
      query: %{},
      rate_limit: request[:rate_limit] || "notion.integration",
      resource: resource,
      security: request[:security],
      retry: retry_group,
      telemetry: request[:telemetry],
      timeout: request[:timeout],
      request: maybe_request_schema(request, typed_runtime?),
      response: maybe_response_schema(request, typed_runtime?)
    }
  end

  defp build_request_spec(%__MODULE__{} = client, request, typed_runtime?) do
    resource = request[:resource] || resource_group(request)
    retry_group = request[:retry] || retry_group(request, resource)

    %{
      method: request[:method],
      path: request[:path],
      path_params: normalize_map(request[:path_params]),
      query: normalize_map(request[:query]),
      body: Map.get(request, :body),
      form_data: normalize_form_data(request[:form_data]),
      headers: normalize_map(request[:headers]),
      auth: Map.get(request, :auth),
      security: Map.get(request, :security),
      request_schema: maybe_raw_request_schema(request, typed_runtime?),
      response_schema: maybe_raw_response_schema(request, typed_runtime?),
      id: raw_request_id(request),
      circuit_breaker: resolve_circuit_breaker(client, request[:circuit_breaker], resource),
      rate_limit: request[:rate_limit] || "notion.integration",
      resource: resource,
      retry: retry_group,
      telemetry: request[:telemetry],
      timeout: request[:timeout]
    }
  end

  defp request_payload(request, method) do
    body = request[:body]
    form_data = normalize_form_data(request[:form_data])
    request_content_types = Enum.map(request[:request] || [], &elem(&1, 0))

    cond do
      non_empty_map?(form_data) ->
        {form_data, "multipart", "multipart/form-data"}

      non_empty_map?(body) ->
        {body, nil, "application/json"}

      "application/json" in request_content_types ->
        {normalize_map(body), nil, "application/json"}

      method in [:delete, :get, :head] ->
        {nil, "raw", nil}

      true ->
        {nil, "raw", nil}
    end
  end

  defp request_id(%{call: {module, function}}) do
    module_name =
      module
      |> Module.split()
      |> Enum.join(".")

    module_name <> "." <> Atom.to_string(function)
  end

  defp default_auth(auth, nil) when is_binary(auth), do: [Bearer.new(auth)]
  defp default_auth(nil, nil), do: []

  defp default_auth(auth, oauth2) when is_list(oauth2) do
    %{
      "basicAuth" => [],
      "bearerAuth" => [OAuth2.new(oauth2)],
      "default" => default_auth(auth, nil)
    }
  end

  defp typed_runtime_enabled?(%__MODULE__{typed_responses: default}, request) do
    Map.get(request, :typed_responses, request_typed_responses(request[:args], default))
  end

  defp request_typed_responses(args, default) when is_map(args) do
    cond do
      is_boolean(Map.get(args, :typed_responses)) ->
        Map.get(args, :typed_responses)

      is_boolean(Map.get(args, "typed_responses")) ->
        Map.get(args, "typed_responses")

      true ->
        default
    end
  end

  defp request_typed_responses(_args, default), do: default

  defp maybe_request_schema(_request, false), do: nil

  defp maybe_request_schema(request, true) do
    request
    |> Map.get(:request, [])
    |> Enum.find_value(fn
      {"application/json", schema} -> schema
      {_content_type, _schema} -> nil
    end)
  end

  defp maybe_response_schema(_request, false), do: nil

  defp maybe_response_schema(request, true) do
    request
    |> Map.get(:response, [])
    |> Enum.filter(fn
      {status, _schema} when is_integer(status) -> status >= 200 and status < 300
      _other -> false
    end)
    |> Enum.map(&elem(&1, 1))
    |> case do
      [] -> nil
      [schema] -> schema
      schemas -> {:union, schemas}
    end
  end

  defp maybe_raw_request_schema(_request, false), do: nil
  defp maybe_raw_request_schema(request, true), do: request[:request_schema]

  defp maybe_raw_response_schema(_request, false), do: nil
  defp maybe_raw_response_schema(request, true), do: request[:response_schema]

  @doc false
  @spec oauth_request_auth(map()) :: map() | nil
  def oauth_request_auth(params) when is_map(params) do
    oauth_client_credentials(params) ||
      normalize_request_auth(Map.get(params, "auth") || Map.get(params, :auth))
  end

  def oauth_request_auth(_params), do: nil

  @doc false
  @spec drop_oauth_credentials(map()) :: map()
  def drop_oauth_credentials(params) when is_map(params) do
    params
    |> Map.delete("auth")
    |> Map.delete(:auth)
    |> Map.delete("client_id")
    |> Map.delete(:client_id)
    |> Map.delete("client_secret")
    |> Map.delete(:client_secret)
  end

  def drop_oauth_credentials(params), do: params

  defp oauth_client_credentials(%{"client_id" => client_id, "client_secret" => client_secret}) do
    %{"client_id" => client_id, "client_secret" => client_secret}
  end

  defp oauth_client_credentials(%{client_id: client_id, client_secret: client_secret}) do
    %{"client_id" => client_id, "client_secret" => client_secret}
  end

  defp oauth_client_credentials(_params), do: nil

  defp normalize_request_auth(%{} = auth) do
    Map.new(auth, fn {key, value} -> {to_string(key), value} end)
  end

  defp normalize_request_auth(_auth), do: nil

  @spec normalize_retry(term()) :: retry_config()
  defp normalize_retry(false), do: false
  defp normalize_retry(nil), do: @default_retry
  defp normalize_retry(retry) when retry == [] or retry == %{}, do: @default_retry

  defp normalize_retry(retry) when is_list(retry) do
    retry
    |> Enum.into(%{}, fn {key, value} -> {normalize_retry_key(key), value} end)
    |> normalize_retry()
  end

  defp normalize_retry(retry) when is_map(retry) do
    normalized =
      Map.new(retry, fn {key, value} ->
        {normalize_retry_key(key), value}
      end)

    %{
      initial_retry_delay_ms:
        Map.get(normalized, :initial_retry_delay_ms, @default_retry.initial_retry_delay_ms),
      max_retries: Map.get(normalized, :max_retries, @default_retry.max_retries),
      max_retry_delay_ms:
        Map.get(normalized, :max_retry_delay_ms, @default_retry.max_retry_delay_ms)
    }
  end

  defp normalize_retry(_retry), do: @default_retry

  defp normalize_retry_key("base_delay_ms"), do: :initial_retry_delay_ms
  defp normalize_retry_key("initial_retry_delay_ms"), do: :initial_retry_delay_ms
  defp normalize_retry_key("max_attempts"), do: :max_retries
  defp normalize_retry_key("max_delay_ms"), do: :max_retry_delay_ms
  defp normalize_retry_key("max_retries"), do: :max_retries
  defp normalize_retry_key("max_retry_delay_ms"), do: :max_retry_delay_ms

  defp normalize_retry_key(key) when is_binary(key) do
    String.to_existing_atom(key)
  rescue
    ArgumentError -> key
  end

  defp normalize_retry_key(:base_delay_ms), do: :initial_retry_delay_ms
  defp normalize_retry_key(:initial_retry_delay_ms), do: :initial_retry_delay_ms
  defp normalize_retry_key(:max_attempts), do: :max_retries
  defp normalize_retry_key(:max_delay_ms), do: :max_retry_delay_ms
  defp normalize_retry_key(:max_retries), do: :max_retries
  defp normalize_retry_key(:max_retry_delay_ms), do: :max_retry_delay_ms
  defp normalize_retry_key(key), do: key

  @spec retry_policies(retry_settings()) :: %{required(String.t()) => keyword()}
  defp retry_policies(%{
         initial_retry_delay_ms: initial_retry_delay_ms,
         max_retries: max_retries,
         max_retry_delay_ms: max_retry_delay_ms
       }) do
    policy_opts = [
      max_attempts: max_retries,
      backoff_opts: [
        base_delay_ms: initial_retry_delay_ms,
        jitter: 0.25,
        jitter_strategy: :factor,
        max_delay_ms: max_retry_delay_ms,
        strategy: :exponential
      ]
    ]

    Map.new(@retry_groups, &{&1, policy_opts})
  end

  defp normalize_transport_opts(Pristine.Adapters.Transport.Finch, opts, finch)
       when is_list(opts) do
    Keyword.put_new(opts, :finch, finch)
  end

  defp normalize_transport_opts(_transport, opts, _finch) when is_list(opts), do: opts
  defp normalize_transport_opts(_transport, _opts, _finch), do: []

  defp normalize_map(nil), do: %{}
  defp normalize_map(map) when is_map(map), do: map
  defp normalize_map(_other), do: %{}

  defp normalize_oauth2(nil), do: nil

  defp normalize_oauth2(opts) when is_list(opts) do
    case Keyword.get(opts, :token_source) do
      nil ->
        raise ArgumentError, "oauth2 token_source is required"

      _token_source ->
        opts
        |> Keyword.take([:token_source, :allow_stale?])
    end
  end

  defp normalize_oauth2(_other) do
    raise ArgumentError, "oauth2 must be a keyword list"
  end

  defp normalize_form_data(nil), do: %{}

  defp normalize_form_data(form_data) when is_map(form_data) do
    Map.new(form_data, fn {key, value} -> {key, normalize_form_data_value(value)} end)
  end

  defp normalize_form_data(_form_data), do: %{}

  defp normalize_form_data_value(%{} = value) do
    normalized = Map.new(value, fn {key, item} -> {to_string(key), item} end)

    cond do
      Map.has_key?(normalized, "filename") and Map.has_key?(normalized, "data") and
          Map.has_key?(normalized, "content_type") ->
        {normalized["filename"], normalized["data"], normalized["content_type"]}

      Map.has_key?(normalized, "filename") and Map.has_key?(normalized, "data") ->
        {normalized["filename"], normalized["data"]}

      true ->
        value
    end
  end

  defp normalize_form_data_value(value), do: value

  defp non_empty_map?(value) when is_map(value), do: map_size(value) > 0
  defp non_empty_map?(_value), do: false

  defp maybe_put(opts, _key, nil), do: opts
  defp maybe_put(opts, _key, value) when value == %{}, do: opts
  defp maybe_put(opts, key, value), do: Keyword.put(opts, key, value)

  defp generated_request?(request) when is_map(request) do
    Map.has_key?(request, :call) and
      (Map.has_key?(request, :path_template) or Map.has_key?(request, :url))
  end

  defp raw_request?(request) when is_map(request) do
    Map.has_key?(request, :method) and Map.has_key?(request, :path)
  end

  defp raw_request_id(%{id: id}) when is_binary(id), do: id

  defp raw_request_id(request) do
    method =
      request[:method]
      |> Atom.to_string()

    "raw:" <> method <> ":" <> Map.get(request, :path, "")
  end

  defp default_user_agent do
    "notion-sdk-elixir/#{package_version()}"
  end

  defp normalize_foundation(nil, _auth, _oauth2), do: nil

  defp normalize_foundation(opts, auth, oauth2) when is_list(opts) do
    rate_limit = normalize_foundation_feature(Keyword.get(opts, :rate_limit, []), enabled: true)

    circuit_breaker =
      normalize_foundation_feature(Keyword.get(opts, :circuit_breaker, []),
        enabled: true,
        failure_threshold: 5,
        reset_timeout_ms: 30_000,
        half_open_max_calls: 1
      )

    telemetry = normalize_foundation_feature(Keyword.get(opts, :telemetry, []), enabled: true)

    dispatch =
      opts
      |> Keyword.get(:dispatch)
      |> normalize_foundation_feature(enabled: false)
      |> validate_dispatch_feature()

    %{
      integration_key:
        Keyword.get(opts, :integration_key) || derived_integration_key(auth, oauth2, rate_limit),
      pool_base: Keyword.get(opts, :pool_base),
      pool_manager: Keyword.get(opts, :pool_manager),
      rate_limit: rate_limit,
      circuit_breaker: circuit_breaker,
      telemetry: telemetry,
      dispatch: dispatch
    }
  end

  defp normalize_foundation(_other, _auth, _oauth2) do
    raise ArgumentError, "foundation must be a keyword list"
  end

  defp normalize_foundation_feature(false, defaults) do
    defaults |> Map.new() |> Map.put(:enabled, false)
  end

  defp normalize_foundation_feature(nil, defaults), do: Map.new(defaults)

  defp normalize_foundation_feature(opts, defaults) when is_list(opts) do
    defaults
    |> Map.new()
    |> Map.merge(Map.new(opts))
    |> Map.put_new(:enabled, true)
  end

  defp normalize_foundation_feature(_opts, _defaults) do
    raise ArgumentError, "foundation feature options must be false or a keyword list"
  end

  defp validate_dispatch_feature(%{enabled: true} = dispatch) do
    if Map.has_key?(dispatch, :dispatch) do
      dispatch
    else
      raise ArgumentError,
            "foundation dispatch requires dispatch: [dispatch: server_handle] when enabled"
    end
  end

  defp validate_dispatch_feature(dispatch), do: dispatch

  defp derived_integration_key(auth, _oauth2, %{enabled: true}) when is_binary(auth) do
    {:notion, hashed_secret(auth)}
  end

  defp derived_integration_key(_auth, nil, %{enabled: false}), do: nil

  defp derived_integration_key(_auth, _oauth2, %{enabled: true}) do
    raise ArgumentError,
          "foundation integration_key is required when shared rate limiting is enabled without a static bearer token"
  end

  defp derived_integration_key(_auth, _oauth2, _rate_limit), do: nil

  defp hashed_secret(secret) do
    secret
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
    |> binary_part(0, 16)
  end

  defp foundation_value(nil, _key), do: nil
  defp foundation_value(foundation, key), do: Map.get(foundation, key)

  @spec retry_profile(retry_config()) :: false | keyword()
  defp retry_profile(false), do: false

  defp retry_profile(%{} = retry) do
    [
      adapter: NotionSDK.Retry,
      policies: retry_policies(retry)
    ]
  end

  defp rate_limit_profile(nil), do: false

  defp rate_limit_profile(%{
         integration_key: integration_key,
         rate_limit: %{enabled: true} = rate_limit
       }) do
    rate_limit
    |> Map.delete(:enabled)
    |> Map.put(:key, integration_key)
    |> Enum.into([])
  end

  defp rate_limit_profile(_foundation), do: false

  defp admission_control_profile(nil), do: false

  defp admission_control_profile(%{dispatch: %{enabled: true} = dispatch}) do
    dispatch
    |> Map.delete(:enabled)
    |> Enum.into([])
  end

  defp admission_control_profile(_foundation), do: false

  defp circuit_breaker_profile(nil), do: false

  defp circuit_breaker_profile(%{circuit_breaker: %{enabled: true} = circuit_breaker}) do
    circuit_breaker
    |> Map.delete(:enabled)
    |> Enum.into([])
  end

  defp circuit_breaker_profile(_foundation), do: false

  defp telemetry_profile(nil), do: false

  defp telemetry_profile(%{telemetry: %{enabled: true} = telemetry}) do
    telemetry
    |> Map.delete(:enabled)
    |> Map.put_new(:namespace, [:notion_sdk])
    |> Enum.into([])
  end

  defp telemetry_profile(_foundation), do: false

  defp resolve_circuit_breaker(%__MODULE__{} = client, nil, resource) do
    circuit_breaker_name(client, resource)
  end

  defp resolve_circuit_breaker(%__MODULE__{} = client, breaker, _resource)
       when is_binary(breaker) do
    if explicit_circuit_breaker_name?(breaker) do
      breaker
    else
      circuit_breaker_name(client, breaker)
    end
  end

  defp resolve_circuit_breaker(%__MODULE__{} = client, _breaker, resource) do
    circuit_breaker_name(client, resource)
  end

  defp explicit_circuit_breaker_name?(value), do: String.contains?(value, ":")

  defp resource_group(request) do
    path = request[:path] || request[:path_template] || request[:url] || ""

    cond do
      String.starts_with?(path, "/v1/oauth/") ->
        "oauth_control"

      String.ends_with?(path, "/send") and String.contains?(path, "/file_uploads/") ->
        "file_upload_send"

      String.starts_with?(path, "/v1/file_uploads") ->
        "file_upload_control"

      true ->
        "core_api"
    end
  end

  defp retry_group(_request, "oauth_control"), do: "notion.oauth_control"
  defp retry_group(_request, "file_upload_send"), do: "notion.file_upload_send"

  defp retry_group(request, _resource) do
    case request[:method] do
      method when method in [:get, :head] -> "notion.read"
      :delete -> "notion.delete"
      _other -> "notion.write"
    end
  end

  defp circuit_breaker_name(%__MODULE__{base_url: base_url}, resource) do
    host =
      case URI.parse(base_url) do
        %URI{host: nil} -> base_url
        %URI{host: host} -> host
      end

    group =
      case resource do
        "file_upload_send" -> "file_upload_send"
        "oauth_control" -> "oauth_control"
        _other -> @default_breaker_group
      end

    "notion:#{host}:#{group}"
  end

  defp package_version do
    case Application.spec(:notion_sdk, :vsn) do
      nil -> "dev"
      vsn -> List.to_string(vsn)
    end
  end

  defp config(key, default) do
    Application.get_env(:notion_sdk, key, default)
  end
end
