defmodule NotionSDK.Client do
  @moduledoc """
  Thin Notion client configuration layered on top of Pristine runtime execution.
  """

  alias Pristine.Client, as: RuntimeClient
  alias Pristine.Operation
  alias Pristine.SDK.Context
  alias Pristine.SDK.OpenAPI.Client, as: OpenAPIClient

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
          required(:method) => atom(),
          required(:path_template) => String.t(),
          required(:path_params) => map(),
          required(:query) => map(),
          required(:body) => term(),
          required(:form_data) => term(),
          optional(:args) => map(),
          optional(:auth) => term(),
          optional(:call) => {module(), atom()},
          optional(:circuit_breaker) => String.t(),
          optional(:headers) => map(),
          optional(:id) => String.t() | nil,
          optional(:opts) => keyword(),
          optional(:pagination) => map() | nil,
          optional(:rate_limit) => String.t(),
          optional(:request) => [{String.t(), term()}],
          optional(:request_schema) => term() | nil,
          optional(:resource) => String.t(),
          optional(:response) => [{integer() | :default, term()}],
          optional(:response_schemas) => map(),
          optional(:retry) => String.t(),
          optional(:retry_opts) => keyword(),
          optional(:security) => [map()] | nil,
          optional(:telemetry) => term(),
          optional(:timeout) => pos_integer() | nil,
          optional(:typed_responses) => boolean(),
          optional(:use_default_auth) => boolean()
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
          optional(:telemetry) => term(),
          optional(:timeout) => pos_integer() | nil,
          optional(:opts) => keyword(),
          optional(:use_default_auth) => boolean()
        }

  @type request_t :: raw_request_t()

  @type t :: %__MODULE__{
          auth: String.t() | nil,
          base_url: String.t(),
          context: Context.t() | nil,
          foundation: map() | nil,
          log_level: :debug | :info | :warn | :error | nil,
          logger: (atom(), String.t(), map() -> term()) | nil,
          notion_version: String.t(),
          oauth2: oauth2_config() | nil,
          pristine_client: RuntimeClient.t() | nil,
          retry: retry_config(),
          timeout_ms: pos_integer(),
          transport: module(),
          transport_opts: keyword(),
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
    :oauth2,
    :pristine_client,
    :retry,
    :timeout_ms,
    :transport,
    :transport_opts,
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
      foundation: foundation,
      log_level: log_level,
      logger: logger,
      notion_version: notion_version,
      oauth2: oauth2,
      retry: retry,
      timeout_ms: timeout_ms,
      transport: transport,
      transport_opts: transport_opts,
      typed_responses: typed_responses,
      user_agent: user_agent
    }

    context = build_context(client)
    runtime_client = RuntimeClient.from_context(context)
    %{client | pristine_client: runtime_client, context: context}
  end

  @spec pristine_client(t() | RuntimeClient.t()) :: RuntimeClient.t()
  def pristine_client(%RuntimeClient{} = client), do: client
  def pristine_client(%__MODULE__{pristine_client: %RuntimeClient{} = client}), do: client

  def pristine_client(other) do
    raise ArgumentError, "expected NotionSDK.Client or Pristine.Client, got: #{inspect(other)}"
  end

  @doc false
  @spec runtime_execute_opts(t() | RuntimeClient.t(), keyword()) :: keyword()
  def runtime_execute_opts(%RuntimeClient{}, opts) when is_list(opts), do: opts

  def runtime_execute_opts(%__MODULE__{typed_responses: typed_responses}, opts)
      when is_list(opts) do
    Keyword.put_new(opts, :typed_responses, typed_responses)
  end

  @doc false
  @spec runtime_operation(t() | RuntimeClient.t(), Operation.t(), keyword()) :: Operation.t()
  def runtime_operation(client = %RuntimeClient{}, %Operation{} = operation, opts)
      when is_list(opts) do
    operation
    |> maybe_disable_operation_schemas(Keyword.get(opts, :typed_responses, false))
    |> normalize_runtime_operation(client)
  end

  def runtime_operation(
        client = %__MODULE__{typed_responses: typed_responses},
        %Operation{} = operation,
        opts
      )
      when is_list(opts) do
    operation
    |> maybe_disable_operation_schemas(Keyword.get(opts, :typed_responses, typed_responses))
    |> normalize_runtime_operation(client)
  end

  @spec request(t() | RuntimeClient.t(), request_t()) :: {:ok, term()} | {:error, term()}
  def request(client, request) when is_map(request) do
    if raw_request?(request) do
      execute_raw_request(client, request)
    else
      raise ArgumentError, "expected raw request spec, got: #{inspect(request)}"
    end
  end

  def request(other, _request) do
    raise ArgumentError, "expected NotionSDK.Client or Pristine.Client, got: #{inspect(other)}"
  end

  @doc false
  @spec execute_generated_request(t() | RuntimeClient.t(), generated_request_t()) ::
          {:ok, term()} | {:error, term()}
  def execute_generated_request(client, request) when is_map(request) do
    if generated_request?(request) do
      typed_runtime? = typed_runtime_enabled?(client, request)

      request_spec =
        request
        |> normalize_generated_request()
        |> OpenAPIClient.to_request_spec()
        |> prepare_request_spec(client, typed_runtime?)

      execute_opts =
        request[:opts]
        |> normalize_execute_opts()
        |> maybe_put(:retry_opts, request[:retry_opts])
        |> maybe_put(:typed_responses, typed_runtime?)

      Pristine.execute_request(request_spec, client_context(client), execute_opts)
    else
      raise ArgumentError, "expected generated request spec, got: #{inspect(request)}"
    end
  end

  defp execute_raw_request(client, request) do
    typed_runtime? = typed_runtime_enabled?(client, request)

    request_spec =
      request
      |> normalize_raw_request()
      |> put_default_raw_security()
      |> prepare_request_spec(client, typed_runtime?)

    execute_opts =
      request[:opts]
      |> normalize_execute_opts()
      |> maybe_put(:retry_opts, request[:retry_opts])
      |> maybe_put(:typed_responses, typed_runtime?)

    Pristine.execute_request(request_spec, client_context(client), execute_opts)
  end

  defp build_context(%__MODULE__{} = client) do
    Pristine.foundation_context(
      admission_control: admission_control_profile(client.foundation),
      auth: default_auth(client.auth, client.oauth2),
      base_url: client.base_url,
      circuit_breaker: circuit_breaker_profile(client.foundation),
      default_timeout: client.timeout_ms,
      headers: %{
        "Notion-Version" => client.notion_version,
        "User-Agent" => client.user_agent
      },
      error_module: NotionSDK.Error,
      log_level: client.log_level,
      logger: client.logger,
      package_version: package_version(),
      provider_profile: NotionSDK.ProviderProfile.profile(),
      rate_limit: rate_limit_profile(client.foundation),
      result_classifier: NotionSDK.ResultClassifier,
      retry: retry_profile(client.retry),
      serializer: Pristine.Adapters.Serializer.JSON,
      telemetry: telemetry_profile(client.foundation),
      pool_base: foundation_value(client.foundation, :pool_base),
      pool_manager: foundation_value(client.foundation, :pool_manager),
      transport: client.transport,
      transport_opts: client.transport_opts
    )
  end

  defp generated_request_schema([]), do: nil
  defp generated_request_schema(nil), do: nil
  defp generated_request_schema([{_content_type, schema} | _rest]), do: schema

  defp generated_response_schemas(responses) when is_list(responses) do
    responses
    |> Enum.map(fn {status, schema} -> {status, schema} end)
    |> Map.new()
  end

  defp generated_response_schemas(_responses), do: %{}

  defp use_client_default_auth?(nil), do: true
  defp use_client_default_auth?(false), do: false
  defp use_client_default_auth?([]), do: false
  defp use_client_default_auth?(_auth), do: true

  defp typed_runtime_enabled?(client, request) do
    default =
      case client do
        %__MODULE__{typed_responses: typed_responses} -> typed_responses
        %RuntimeClient{} -> false
      end

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

  defp maybe_disable_operation_schemas(%Operation{} = operation, true), do: operation

  defp maybe_disable_operation_schemas(%Operation{} = operation, false) do
    %Operation{operation | request_schema: nil, response_schemas: %{}}
  end

  defp normalize_runtime_operation(%Operation{} = operation, client) do
    resource = operation.runtime[:resource]

    circuit_breaker =
      resolve_circuit_breaker(client, operation.runtime[:circuit_breaker], resource)

    %Operation{
      operation
      | form_data: normalize_form_data(operation.form_data),
        runtime: Map.put(operation.runtime, :circuit_breaker, circuit_breaker)
    }
  end

  defp client_context(%RuntimeClient{context: context}), do: context
  defp client_context(%__MODULE__{context: context}), do: context

  defp prepare_request_spec(request_spec, client, typed_runtime?) do
    resource = request_spec[:resource] || resource_group(request_spec)
    auth = normalize_request_auth(request_spec[:auth])
    use_default_auth? = Map.get(request_spec, :use_default_auth, use_client_default_auth?(auth))

    request_spec
    |> Map.put(:auth, auth)
    |> Map.put(:headers, request_spec[:headers] || %{})
    |> Map.put(:query, request_spec[:query] || %{})
    |> Map.put(:path_params, request_spec[:path_params] || %{})
    |> Map.put(:form_data, normalize_form_data(request_spec[:form_data]))
    |> Map.put(:use_default_auth, use_default_auth?)
    |> maybe_disable_schemas(typed_runtime?)
    |> Map.put(:resource, resource)
    |> Map.put(:retry, request_spec[:retry] || retry_group(request_spec, resource))
    |> Map.put(:rate_limit, request_spec[:rate_limit] || "notion.integration")
    |> Map.put(
      :circuit_breaker,
      resolve_circuit_breaker(client, request_spec[:circuit_breaker], resource)
    )
  end

  defp maybe_disable_schemas(request_spec, true), do: request_spec

  defp maybe_disable_schemas(request_spec, false) do
    request_spec
    |> Map.put(:request_schema, nil)
    |> Map.put(:response_schema, nil)
  end

  defp normalize_raw_request(request) when is_map(request) do
    request
    |> Map.put_new(:path_params, %{})
    |> Map.put_new(:query, %{})
    |> Map.put_new(:headers, %{})
    |> Map.put_new(:form_data, nil)
  end

  defp normalize_generated_request(request) when is_map(request) do
    request
    |> Map.put_new(:args, %{})
    |> Map.put_new(:opts, [])
    |> Map.put_new(:headers, %{})
    |> Map.put_new(:path_params, %{})
    |> Map.put_new(:query, %{})
    |> Map.put_new(:request_schema, generated_request_schema(request[:request]))
    |> Map.put_new(:response_schemas, generated_response_schemas(request[:response]))
    |> Map.put_new(:security, nil)
  end

  defp normalize_execute_opts(nil), do: []

  defp normalize_execute_opts(opts) when is_list(opts) do
    if Keyword.keyword?(opts) do
      opts
    else
      raise ArgumentError, "request opts must be a keyword list"
    end
  end

  defp normalize_execute_opts(_opts) do
    raise ArgumentError, "request opts must be a keyword list"
  end

  defp put_default_raw_security(%{path: path} = request) when is_binary(path) do
    case Map.get(request, :security) do
      nil -> Map.put(request, :security, default_raw_security(path))
      _security -> request
    end
  end

  defp put_default_raw_security(request), do: request

  defp default_raw_security(path) when is_binary(path) do
    if String.starts_with?(path, "/v1/oauth/") do
      nil
    else
      [%{"bearerAuth" => []}]
    end
  end

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

  defp default_auth(auth, nil) when is_binary(auth), do: [bearer_auth(auth)]
  defp default_auth(nil, nil), do: []

  defp default_auth(auth, oauth2) when is_list(oauth2) do
    %{
      "basicAuth" => [],
      "bearerAuth" => [oauth2_auth(oauth2)],
      "default" => default_auth(auth, nil)
    }
  end

  defp bearer_auth(token), do: {Pristine.Adapters.Auth.Bearer, token: token}
  defp oauth2_auth(opts) when is_list(opts), do: {Pristine.Adapters.Auth.OAuth2, opts}

  defp normalize_request_auth(nil), do: nil
  defp normalize_request_auth(false), do: false
  defp normalize_request_auth([]), do: []
  defp normalize_request_auth(auth) when is_binary(auth), do: auth

  defp normalize_request_auth(%{} = auth) do
    Map.new(auth, fn {key, value} -> {to_string(key), value} end)
  end

  defp normalize_request_auth(auth) when is_list(auth), do: auth
  defp normalize_request_auth(_auth), do: nil

  @spec normalize_retry(term()) :: retry_config()
  defp normalize_retry(false), do: false
  defp normalize_retry(nil), do: @default_retry
  defp normalize_retry(retry) when retry == [] or retry == %{}, do: @default_retry

  defp normalize_retry(retry) when is_list(retry) do
    retry
    |> Enum.into(%{}, fn {key, value} -> {normalize_retry_key!(key), value} end)
    |> normalize_retry()
  end

  defp normalize_retry(retry) when is_map(retry) do
    normalized =
      Map.new(retry, fn {key, value} ->
        {normalize_retry_key!(key), value}
      end)

    %{
      initial_retry_delay_ms:
        Map.get(normalized, :initial_retry_delay_ms, @default_retry.initial_retry_delay_ms),
      max_retries: Map.get(normalized, :max_retries, @default_retry.max_retries),
      max_retry_delay_ms:
        Map.get(normalized, :max_retry_delay_ms, @default_retry.max_retry_delay_ms)
    }
  end

  defp normalize_retry(_retry) do
    raise ArgumentError, "retry must be false, a map, or a keyword list"
  end

  defp normalize_retry_key!("initial_retry_delay_ms"), do: :initial_retry_delay_ms
  defp normalize_retry_key!("max_retries"), do: :max_retries
  defp normalize_retry_key!("max_retry_delay_ms"), do: :max_retry_delay_ms
  defp normalize_retry_key!(:initial_retry_delay_ms), do: :initial_retry_delay_ms
  defp normalize_retry_key!(:max_retries), do: :max_retries
  defp normalize_retry_key!(:max_retry_delay_ms), do: :max_retry_delay_ms

  defp normalize_retry_key!(key) do
    raise ArgumentError,
          "unknown retry option #{inspect(key)}; supported keys are :initial_retry_delay_ms, :max_retries, :max_retry_delay_ms"
  end

  @spec retry_policies(retry_settings()) :: %{required(String.t()) => keyword()}
  defp retry_policies(%{
         initial_retry_delay_ms: initial_retry_delay_ms,
         max_retries: max_retries,
         max_retry_delay_ms: max_retry_delay_ms
       }) do
    policy_opts = [
      max_attempts: max_retries,
      backoff: [
        base_ms: initial_retry_delay_ms,
        jitter: 0.25,
        jitter_strategy: :factor,
        max_ms: max_retry_delay_ms,
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

  defp generated_request?(request) when is_map(request) do
    Map.has_key?(request, :method) and Map.has_key?(request, :path_template)
  end

  defp raw_request?(request) when is_map(request) do
    Map.has_key?(request, :method) and Map.has_key?(request, :path)
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

  defp resolve_circuit_breaker(%RuntimeClient{} = client, nil, resource) do
    circuit_breaker_name(client.base_url, resource)
  end

  defp resolve_circuit_breaker(%RuntimeClient{} = client, breaker, _resource)
       when is_binary(breaker) do
    if explicit_circuit_breaker_name?(breaker) do
      breaker
    else
      circuit_breaker_name(client.base_url, breaker)
    end
  end

  defp resolve_circuit_breaker(%RuntimeClient{} = client, _breaker, resource) do
    circuit_breaker_name(client.base_url, resource)
  end

  defp resolve_circuit_breaker(%__MODULE__{} = client, breaker, resource) do
    resolve_circuit_breaker(client.pristine_client, breaker, resource)
  end

  defp explicit_circuit_breaker_name?(value), do: String.contains?(value, ":")

  defp resource_group(request) do
    path = request[:path] || request[:path_template] || ""

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

  defp circuit_breaker_name(base_url, resource) do
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

  defp maybe_put(opts, _key, nil), do: opts
  defp maybe_put(opts, _key, value) when value == [], do: opts
  defp maybe_put(opts, key, value), do: Keyword.put(opts, key, value)

  defp config(key, default) do
    Application.get_env(:notion_sdk, key, default)
  end
end
