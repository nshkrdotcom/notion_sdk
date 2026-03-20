defmodule NotionSDK.ErrorTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Error
  alias Pristine.Response

  describe "from_response/3" do
    test "maps Notion API codes from the body" do
      unauthorized =
        Error.from_response(
          response(401),
          %{"code" => "unauthorized", "message" => "Bad token"},
          nil
        )

      rate_limited =
        Error.from_response(
          response(429),
          %{"code" => "rate_limited", "message" => "Slow down"},
          nil
        )

      invalid_grant =
        Error.from_response(
          response(400),
          ~s({"code":"invalid_grant","message":"Grant is invalid"}),
          nil
        )

      missing_version =
        Error.from_response(
          response(400),
          %{"code" => "missing_version", "message" => "Version header required"},
          nil
        )

      unauthorized_client =
        Error.from_response(
          response(400),
          %{"code" => "unauthorized_client", "message" => "Client is not allowed"},
          nil
        )

      unsupported_grant_type =
        Error.from_response(
          response(400),
          %{"code" => "unsupported_grant_type", "message" => "Grant type is not supported"},
          nil
        )

      invalid_scope =
        Error.from_response(
          response(400),
          %{"code" => "invalid_scope", "message" => "Scope is not valid"},
          nil
        )

      invalid_client =
        Error.from_response(
          response(401),
          %{"code" => "invalid_client", "message" => "Client auth failed"},
          nil
        )

      test_env_error =
        Error.from_response(
          response(403),
          %{"code" => "test_env_error", "message" => "Public integrations are not enabled"},
          nil
        )

      assert unauthorized.code == :unauthorized
      assert rate_limited.code == :rate_limited
      assert invalid_grant.code == :invalid_grant
      assert missing_version.code == :missing_version
      assert unauthorized_client.code == :unauthorized_client
      assert unsupported_grant_type.code == :unsupported_grant_type
      assert invalid_scope.code == :invalid_scope
      assert invalid_client.code == :invalid_client
      assert test_env_error.code == :test_env_error
    end

    test "falls back to HTTP status mapping when the body has no code" do
      assert Error.from_response(response(404), %{"message" => "Missing"}, nil).code ==
               :object_not_found

      assert Error.from_response(response(502), %{"message" => "Bad gateway"}, nil).code ==
               :bad_gateway

      assert Error.from_response(response(504), %{"message" => "Timed out"}, nil).code ==
               :gateway_timeout
    end

    test "preserves request metadata and additional data" do
      error =
        Error.from_response(
          response(429, %{"x-request-id" => "req-123"}),
          %{
            "code" => "rate_limited",
            "message" => "Too many requests",
            "additional_data" => %{"retry_scope" => "workspace"}
          },
          2_500
        )

      assert error.request_id == "req-123"
      assert error.retry_after_ms == 2_500
      assert error.additional_data == %{"retry_scope" => "workspace"}
      assert error.headers["x-request-id"] == "req-123"
    end

    test "prefers body request ids over header request ids" do
      error =
        Error.from_response(
          response(500, %{"x-request-id" => "header-request-id"}),
          %{"message" => "Boom", "request_id" => "body-request-id"},
          nil
        )

      assert error.request_id == "body-request-id"
    end
  end

  describe "retryable?/1" do
    test "marks retryable and non-retryable errors correctly" do
      assert Error.retryable?(Error.new(:rate_limited, ""))
      assert Error.retryable?(Error.new(:bad_gateway, ""))
      assert Error.retryable?(Error.new(:api_connection, ""))

      refute Error.retryable?(Error.new(:unauthorized, ""))
      refute Error.retryable?(Error.new(:validation_error, ""))
    end
  end

  describe "message/1" do
    test "includes request_id when present" do
      error = Error.new(:unauthorized, "Bad token", request_id: "req-abc")

      assert Exception.message(error) =~ "[unauthorized]"
      assert Exception.message(error) =~ "Bad token"
      assert Exception.message(error) =~ "req-abc"
    end
  end

  defp response(status, headers \\ %{}) do
    Response.new(status: status, headers: headers, body: nil)
  end
end
