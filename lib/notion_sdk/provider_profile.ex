defmodule NotionSDK.ProviderProfile do
  @moduledoc false

  alias Pristine.SDK.ProviderProfile, as: RuntimeProviderProfile

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
  @retryable_groups ["notion.read", "notion.delete", "notion.file_upload_send"]
  @status_code_map %{
    400 => :invalid_request,
    401 => :unauthorized,
    403 => :restricted_resource,
    404 => :object_not_found,
    409 => :conflict_error,
    422 => :validation_error,
    429 => :rate_limited,
    500 => :internal_server_error,
    502 => :bad_gateway,
    503 => :service_unavailable,
    504 => :gateway_timeout
  }
  @status_retry_overrides %{
    409 => %{
      retry_groups: ["notion.file_upload_send"],
      telemetry_classification: :retryable_conflict,
      breaker_outcome: :failure
    }
  }

  @spec profile() :: RuntimeProviderProfile.t()
  def profile do
    RuntimeProviderProfile.new!(
      provider: :notion,
      default_retry_group: "notion.write",
      retryable_groups: @retryable_groups,
      transport_retry_groups: :all,
      rate_limit_retry_groups: :all,
      status_retry_overrides: @status_retry_overrides,
      status_code_map: @status_code_map,
      body_code_map: @api_code_map,
      request_id_headers: ["x-request-id"],
      body_request_id_fields: ["request_id"],
      additional_data_fields: ["additional_data"],
      rate_limit_code: :rate_limited,
      response_error_code: :response_error,
      connection_code: :api_connection,
      validation_code: :validation_error
    )
  end
end
