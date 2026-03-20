defmodule NotionSDK.Error do
  @moduledoc """
  Notion-specific error type returned by the thin generated SDK.
  """

  @api_code_map %{
    "bad_gateway" => :bad_gateway,
    "conflict_error" => :conflict_error,
    "database_connection_unavailable" => :database_connection_unavailable,
    "gateway_timeout" => :gateway_timeout,
    "internal_server_error" => :internal_server_error,
    "invalid_grant" => :invalid_grant,
    "invalid_client" => :invalid_client,
    "invalid_json" => :invalid_json,
    "invalid_request" => :invalid_request,
    "invalid_request_url" => :invalid_request_url,
    "invalid_scope" => :invalid_scope,
    "missing_version" => :missing_version,
    "object_not_found" => :object_not_found,
    "rate_limited" => :rate_limited,
    "restricted_resource" => :restricted_resource,
    "service_unavailable" => :service_unavailable,
    "test_env_error" => :test_env_error,
    "unauthorized" => :unauthorized,
    "unauthorized_client" => :unauthorized_client,
    "unsupported_grant_type" => :unsupported_grant_type,
    "validation_error" => :validation_error
  }
  @retryable_codes [
    :api_connection,
    :bad_gateway,
    :database_connection_unavailable,
    :gateway_timeout,
    :internal_server_error,
    :rate_limited,
    :request_timeout,
    :service_unavailable
  ]

  @type code ::
          :api_connection
          | :bad_gateway
          | :conflict_error
          | :database_connection_unavailable
          | :gateway_timeout
          | :internal_server_error
          | :invalid_client
          | :invalid_grant
          | :invalid_json
          | :invalid_request
          | :invalid_request_url
          | :invalid_scope
          | :missing_version
          | :object_not_found
          | :rate_limited
          | :request_timeout
          | :response_error
          | :restricted_resource
          | :service_unavailable
          | :test_env_error
          | :unauthorized
          | :unauthorized_client
          | :unsupported_grant_type
          | :validation
          | :validation_error
          | :unknown

  @type t :: %__MODULE__{
          additional_data: map() | nil,
          body: term(),
          code: code(),
          headers: map(),
          message: String.t(),
          request_id: String.t() | nil,
          retry_after_ms: non_neg_integer() | nil,
          status: integer() | nil
        }

  defexception [
    :additional_data,
    :body,
    :code,
    :headers,
    :message,
    :request_id,
    :retry_after_ms,
    :status
  ]

  @spec new(code(), String.t(), keyword()) :: t()
  def new(code, message, opts \\ []) do
    %__MODULE__{
      additional_data: Keyword.get(opts, :additional_data),
      body: Keyword.get(opts, :body),
      code: code,
      headers: normalize_headers(Keyword.get(opts, :headers, %{})),
      message: message,
      request_id: Keyword.get(opts, :request_id),
      retry_after_ms: Keyword.get(opts, :retry_after_ms),
      status: Keyword.get(opts, :status)
    }
  end

  @spec from_response(Pristine.Response.t() | map(), term(), non_neg_integer() | nil) :: t()
  def from_response(%{status: _status} = response, body, retry_after_ms) do
    from_response(response, body, retry_after_ms, [])
  end

  @spec from_response(
          Pristine.Response.t() | map(),
          term(),
          non_neg_integer() | nil,
          keyword()
        ) :: t()
  def from_response(%{status: status} = response, body, retry_after_ms, _opts) do
    body = normalize_body(body)
    headers = Map.get(response, :headers, %{})
    code = code_from_body(body) || code_from_status(status)
    message = message_from_body(body) || "HTTP #{status}"

    %__MODULE__{
      additional_data: additional_data(body),
      body: body,
      code: code,
      headers: normalize_headers(headers),
      message: message,
      request_id: request_id(body, headers),
      retry_after_ms: retry_after_ms,
      status: status
    }
  end

  @spec connection_error(term()) :: t()
  def connection_error(reason) do
    new(:api_connection, format_reason(reason), body: %{reason: inspect(reason)})
  end

  @spec validation_error(term(), term()) :: t()
  def validation_error(reason, body) do
    new(:validation, "Validation error: #{inspect(reason)}", body: body)
  end

  @spec retryable?(t()) :: boolean()
  def retryable?(%__MODULE__{code: code}), do: code in @retryable_codes

  @impl true
  def message(%__MODULE__{code: code, message: message, request_id: nil}) do
    "[#{code}] #{message}"
  end

  def message(%__MODULE__{code: code, message: message, request_id: request_id}) do
    "[#{code}] #{message} (request_id: #{request_id})"
  end

  defp additional_data(%{"additional_data" => additional_data}) when is_map(additional_data),
    do: additional_data

  defp additional_data(_body), do: nil

  defp code_from_body(%{"code" => code}) when is_binary(code), do: Map.get(@api_code_map, code)
  defp code_from_body(_body), do: nil

  defp code_from_status(400), do: :invalid_request
  defp code_from_status(401), do: :unauthorized
  defp code_from_status(403), do: :restricted_resource
  defp code_from_status(404), do: :object_not_found
  defp code_from_status(409), do: :conflict_error
  defp code_from_status(422), do: :validation_error
  defp code_from_status(429), do: :rate_limited
  defp code_from_status(500), do: :internal_server_error
  defp code_from_status(502), do: :bad_gateway
  defp code_from_status(503), do: :service_unavailable
  defp code_from_status(504), do: :gateway_timeout
  defp code_from_status(_status), do: :response_error

  defp format_reason(reason) do
    cond do
      is_struct(reason) and function_exported?(reason.__struct__, :message, 1) ->
        Exception.message(reason)

      is_binary(reason) ->
        reason

      true ->
        inspect(reason)
    end
  end

  defp message_from_body(%{"message" => message}) when is_binary(message), do: message
  defp message_from_body(_body), do: nil

  defp normalize_body(nil), do: nil

  defp normalize_body(body) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, decoded} -> normalize_body(decoded)
      {:error, _} -> %{"message" => body}
    end
  end

  defp normalize_body(body) when is_map(body) do
    Map.new(body, fn {key, value} -> {to_string(key), value} end)
  end

  defp normalize_body(body), do: body

  defp normalize_headers(headers) when is_map(headers) do
    Map.new(headers, fn {key, value} -> {to_string(key), value} end)
  end

  defp normalize_headers(headers) when is_list(headers) do
    Map.new(headers, fn {key, value} -> {to_string(key), value} end)
  end

  defp normalize_headers(_headers), do: %{}

  defp request_id(%{"request_id" => request_id}, _headers) when is_binary(request_id),
    do: request_id

  defp request_id(_body, headers) do
    headers = normalize_headers(headers)
    headers["x-request-id"] || headers["X-Request-Id"]
  end
end
