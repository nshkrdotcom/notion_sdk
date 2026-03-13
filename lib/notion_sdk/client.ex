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
  @default_retry %{
    max_retries: 2,
    initial_retry_delay_ms: 1_000,
    max_retry_delay_ms: 60_000
  }
  @retryable_statuses_by_method %{
    all: [429],
    delete: [500, 503],
    get: [500, 503]
  }

  @type retry_config ::
          false
          | %{
              required(:initial_retry_delay_ms) => pos_integer(),
              required(:max_retries) => non_neg_integer(),
              required(:max_retry_delay_ms) => pos_integer()
            }

  @type oauth2_config ::
          [
            {:token_source, {module(), keyword()} | module()}
            | {:allow_stale?, boolean()}
          ]

  @type request_t :: %{
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
          optional(:security) => [map()] | nil,
          optional(:headers) => map(),
          optional(:request) => [{String.t(), term()}],
          optional(:response) => [{integer() | :default, term()}]
        }

  @type t :: %__MODULE__{
          auth: String.t() | nil,
          base_url: String.t(),
          context: Context.t(),
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

    client = %__MODULE__{
      auth: auth,
      base_url: base_url,
      log_level: log_level,
      logger: logger,
      notion_version: notion_version,
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
    typed_runtime? = typed_runtime_enabled?(client, request)
    endpoint = build_endpoint(request, typed_runtime?)
    {payload, body_type, content_type} = request_payload(request, endpoint.method)

    execute_opts =
      []
      |> Keyword.put(:path, request[:path_template] || request[:url])
      |> Keyword.put(:path_params, normalize_map(request[:path_params]))
      |> maybe_put(:auth, request[:auth])
      |> maybe_put(:headers, request[:headers])
      |> maybe_put(:query, normalize_map(request[:query]))
      |> maybe_put(:retry_opts, retry_opts(client, endpoint.method))
      |> maybe_put(:body_type, body_type)
      |> maybe_put(:content_type, content_type)
      |> maybe_put(:typed_responses, typed_runtime?)

    Pristine.execute_endpoint(endpoint, payload, client.context, execute_opts)
  end

  def request(other, _request) do
    raise ArgumentError, "expected NotionSDK.Client, got: #{inspect(other)}"
  end

  defp build_context(%__MODULE__{} = client) do
    retry_adapter =
      if client.retry == false do
        Pristine.Adapters.Retry.Noop
      else
        NotionSDK.Retry
      end

    Pristine.context(
      auth: default_auth(client.auth, client.oauth2),
      base_url: client.base_url,
      circuit_breaker: Pristine.Adapters.CircuitBreaker.Noop,
      default_timeout: client.timeout_ms,
      error_module: NotionSDK.Error,
      headers: %{
        "Notion-Version" => client.notion_version,
        "User-Agent" => client.user_agent
      },
      log_level: client.log_level,
      logger: client.logger,
      package_version: package_version(),
      retry: retry_adapter,
      serializer: Pristine.Adapters.Serializer.JSON,
      telemetry: Pristine.Adapters.Telemetry.Noop,
      transport: client.transport,
      transport_opts: client.transport_opts
    )
  end

  defp build_endpoint(request, typed_runtime?) do
    %Endpoint{
      id: request_id(request),
      method: request[:method],
      path: request[:path_template] || request[:url],
      body_type: nil,
      content_type: nil,
      headers: %{},
      query: %{},
      security: request[:security],
      request: maybe_request_schema(request, typed_runtime?),
      response: maybe_response_schema(request, typed_runtime?)
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

  defp retry_opts(%__MODULE__{retry: false}, _method), do: nil

  defp retry_opts(%__MODULE__{retry: retry}, method) do
    backoff =
      NotionSDK.Retry.build_backoff(
        base_delay_ms: retry.initial_retry_delay_ms,
        jitter: 0.25,
        jitter_strategy: :factor,
        max_delay_ms: retry.max_retry_delay_ms,
        strategy: :exponential
      )

    policy =
      NotionSDK.Retry.build_policy(
        backoff: backoff,
        max_attempts: retry.max_retries,
        retry_after_ms_fun: &retry_after_ms/1,
        retry_on: &should_retry?(&1, method)
      )

    [policy: policy]
  end

  defp should_retry?({:ok, %{status: status}}, method) when is_integer(status) do
    retryable_statuses =
      @retryable_statuses_by_method
      |> Map.get(:all, [])
      |> Kernel.++(Map.get(@retryable_statuses_by_method, method, []))

    status in retryable_statuses
  end

  defp should_retry?(_result, _method), do: false

  defp retry_after_ms({:ok, %{headers: headers}}), do: NotionSDK.Retry.parse_retry_after(headers)

  defp retry_after_ms(_result), do: nil

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

  defp default_user_agent do
    "notion-sdk-elixir/#{package_version()}"
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
