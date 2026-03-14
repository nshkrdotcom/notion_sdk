defmodule NotionSDK.ClientTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Client
  alias NotionSDK.TestTransport
  alias Pristine.Core.Response

  @moduletag :tmp_dir

  describe "new/1" do
    test "applies Notion defaults" do
      client = Client.new(auth: "secret_test_token")

      assert client.auth == "secret_test_token"
      assert client.base_url == "https://api.notion.com"
      assert client.notion_version == "2025-09-03"
      assert client.timeout_ms == 60_000

      assert client.retry == %{
               max_retries: 2,
               initial_retry_delay_ms: 1_000,
               max_retry_delay_ms: 60_000
             }
    end

    test "builds a curated foundation-backed runtime surface" do
      rate_limit_registry = Foundation.RateLimit.BackoffWindow.new_registry()
      breaker_registry = Foundation.CircuitBreaker.Registry.new_registry()

      client =
        Client.new(
          auth: "secret_test_token",
          foundation: [
            integration_key: {:integration, :demo},
            rate_limit: [registry: rate_limit_registry],
            circuit_breaker: [registry: breaker_registry],
            telemetry: [metadata: %{service: :notion_test}]
          ]
        )

      assert client.context.result_classifier == NotionSDK.ResultClassifier
      assert client.context.rate_limiter == Pristine.Adapters.RateLimit.BackoffWindow
      assert client.context.rate_limit_opts[:key] == {:integration, :demo}
      assert client.context.rate_limit_opts[:registry] == rate_limit_registry
      assert client.context.circuit_breaker == Pristine.Adapters.CircuitBreaker.Foundation
      assert client.context.circuit_breaker_opts[:registry] == breaker_registry
      assert client.context.telemetry == Pristine.Adapters.Telemetry.Foundation
      assert client.context.telemetry_events.request_stop == [:notion_sdk, :request, :stop]
      assert client.context.telemetry_metadata.service == :notion_test
    end

    test "derives a safe fallback integration key from a static bearer token" do
      client =
        Client.new(
          auth: "secret_test_token",
          foundation: [
            rate_limit: [enabled: true],
            circuit_breaker: [enabled: false],
            telemetry: [enabled: false]
          ]
        )

      assert client.context.rate_limit_opts[:key] == {:notion, "16217f0c786e10bc"}
    end

    test "requires a dispatch server handle when dispatch admission control is enabled" do
      assert_raise ArgumentError, ~r/foundation dispatch requires/, fn ->
        Client.new(
          auth: "secret_test_token",
          foundation: [
            integration_key: {:integration, :demo},
            dispatch: [enabled: true]
          ]
        )
      end
    end

    test "normalizes legacy retry option names" do
      client =
        Client.new(
          retry: [
            max_attempts: 4,
            base_delay_ms: 250,
            max_delay_ms: 5_000
          ]
        )

      assert client.retry == %{
               max_retries: 4,
               initial_retry_delay_ms: 250,
               max_retry_delay_ms: 5_000
             }
    end

    test "keeps retry disablement explicit through the normalized client state" do
      client = Client.new(auth: "secret_test_token", retry: false)

      assert client.retry == false
      assert client.context.retry == Pristine.Adapters.Retry.Noop
      assert client.context.retry_policies == %{}
    end
  end

  describe "request building parity" do
    test "sends default Notion headers with bearer auth" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} = NotionSDK.Users.get_self(client)

      assert_receive {:transport_request, request, _context}
      assert request.method == :get
      assert request.url == "https://api.notion.com/v1/users/me"
      assert request.headers["Authorization"] == "Bearer secret_test_token"
      assert request.headers["Notion-Version"] == "2025-09-03"
      assert String.starts_with?(request.headers["User-Agent"], "notion-sdk-elixir/")
    end

    test "supports request-level bearer auth overrides on generated endpoints" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} =
               NotionSDK.Users.get_self(client, %{"auth" => "override-token"})

      assert_receive {:transport_request, request, _context}
      assert request.headers["Authorization"] == "Bearer override-token"
    end

    test "supports request-level basic auth overrides" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} =
               Client.request(client, %{
                 call: {__MODULE__, :request},
                 method: :get,
                 path_template: "/v1/comments",
                 url: "/v1/comments",
                 path_params: %{},
                 query: %{},
                 body: %{},
                 form_data: %{},
                 auth: %{
                   client_id: "client-id",
                   client_secret: "client-secret"
                 }
               })

      assert_receive {:transport_request, request, _context}

      assert request.headers["Authorization"] ==
               "Basic #{Base.encode64("client-id:client-secret")}"
    end

    test "encodes reserved path characters through the generated request path" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} =
               Client.request(client, %{
                 args: %{"comment_id" => "a b"},
                 call: {__MODULE__, :request},
                 method: :get,
                 path_template: "/v1/comments/{comment_id}",
                 url: "/v1/comments/a b",
                 path_params: %{"comment_id" => "a b"},
                 query: %{},
                 body: %{},
                 form_data: %{}
               })

      assert_receive {:transport_request, request, _context}
      assert request.url == "https://api.notion.com/v1/comments/a%20b"
    end

    test "strips inherited auth for a single request with auth false" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 call: {__MODULE__, :request},
                 method: :get,
                 path_template: "/v1/comments",
                 url: "/v1/comments",
                 path_params: %{},
                 query: %{},
                 body: %{},
                 form_data: %{},
                 auth: false
               })

      assert_receive {:transport_request, request, _context}
      refute Map.has_key?(request.headers, "Authorization")
    end

    test "strips inherited auth for a single request with an empty auth list" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 call: {__MODULE__, :request},
                 method: :get,
                 path_template: "/v1/comments",
                 url: "/v1/comments",
                 path_params: %{},
                 query: %{},
                 body: %{},
                 form_data: %{},
                 auth: []
               })

      assert_receive {:transport_request, request, _context}
      refute Map.has_key?(request.headers, "Authorization")
    end

    test "uses basic auth overrides for OAuth endpoints with top-level credentials" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      params = %{
        "client_id" => "client-id",
        "client_secret" => "client-secret",
        "code" => "auth-code",
        "grant_type" => "authorization_code",
        "redirect_uri" => "https://example.com/callback"
      }

      assert {:error, %NotionSDK.Error{code: :api_connection}} =
               NotionSDK.OAuth.token(client, params)

      assert_receive {:transport_request, request, _context}
      assert request.method == :post
      assert request.url == "https://api.notion.com/v1/oauth/token"

      assert request.headers["Authorization"] ==
               "Basic #{Base.encode64("client-id:client-secret")}"

      assert request.headers["Notion-Version"] == "2025-09-03"
      refute request.body =~ "client_id"
      refute request.body =~ "client_secret"
    end

    test "oauth-backed bearer auth is explicit and only applies to bearer-authenticated endpoints" do
      client =
        Client.new(
          retry: false,
          oauth2: [
            token_source:
              {Pristine.Adapters.TokenSource.Static,
               token: %Pristine.OAuth2.Token{access_token: "oauth-access-token"}}
          ],
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} = NotionSDK.Users.get_self(client)

      assert_receive {:transport_request, bearer_request, _context}
      assert bearer_request.headers["Authorization"] == "Bearer oauth-access-token"

      assert {:error, %NotionSDK.Error{code: :api_connection}} =
               NotionSDK.OAuth.introspect(client, %{
                 "client_id" => "client-id",
                 "client_secret" => "client-secret",
                 "token" => "secret_123"
               })

      assert_receive {:transport_request, oauth_request, _context}

      assert oauth_request.headers["Authorization"] ==
               "Basic #{Base.encode64("client-id:client-secret")}"
    end

    test "request-level auth overrides still win on oauth-backed clients" do
      client =
        Client.new(
          oauth2: [
            token_source:
              {Pristine.Adapters.TokenSource.Static,
               token: %Pristine.OAuth2.Token{access_token: "oauth-access-token"}}
          ],
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} =
               NotionSDK.Users.get_self(client, %{"auth" => "override-token"})

      assert_receive {:transport_request, request, _context}
      assert request.headers["Authorization"] == "Bearer override-token"
    end

    test "oauth-backed bearer auth can read persisted tokens from a file", %{tmp_dir: tmp_dir} do
      path = Path.join(tmp_dir, "notion-oauth.json")

      assert :ok =
               Pristine.Adapters.TokenSource.File.put(
                 %Pristine.OAuth2.Token{access_token: "oauth-file-token"},
                 path: path
               )

      client =
        Client.new(
          retry: false,
          oauth2: [
            token_source: {Pristine.Adapters.TokenSource.File, path: path}
          ],
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} = NotionSDK.Users.get_self(client)

      assert_receive {:transport_request, request, _context}
      assert request.headers["Authorization"] == "Bearer oauth-file-token"
    end

    test "oauth-backed bearer auth picks up rotated tokens from the persisted file", %{
      tmp_dir: tmp_dir
    } do
      path = Path.join(tmp_dir, "notion-oauth.json")

      assert :ok =
               Pristine.Adapters.TokenSource.File.put(
                 %Pristine.OAuth2.Token{
                   access_token: "oauth-file-token-old",
                   refresh_token: "refresh-old"
                 },
                 path: path
               )

      client =
        Client.new(
          retry: false,
          oauth2: [
            token_source: {Pristine.Adapters.TokenSource.File, path: path}
          ],
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :boom}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} = NotionSDK.Users.get_self(client)

      assert_receive {:transport_request, first_request, _context}
      assert first_request.headers["Authorization"] == "Bearer oauth-file-token-old"

      assert :ok =
               Pristine.Adapters.TokenSource.File.put(
                 %Pristine.OAuth2.Token{
                   access_token: "oauth-file-token-new",
                   refresh_token: "refresh-rotated"
                 },
                 path: path
               )

      assert {:error, %NotionSDK.Error{code: :api_connection}} = NotionSDK.Users.get_self(client)

      assert_receive {:transport_request, second_request, _context}
      assert second_request.headers["Authorization"] == "Bearer oauth-file-token-new"
    end

    test "builds markdown query params and request bodies like the JS SDK" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response:
              ok_response(%{"request_id" => "req-markdown", "results" => [], "metadata" => %{}})
          ]
        )

      assert {:ok, _response} =
               NotionSDK.Pages.retrieve_markdown(client, %{
                 "page_id" => "abc123",
                 "include_transcript" => true
               })

      assert_receive {:transport_request, markdown_request, _context}
      assert markdown_request.method == :get

      assert markdown_request.url ==
               "https://api.notion.com/v1/pages/abc123/markdown?include_transcript=true"

      assert {:ok, _response} =
               NotionSDK.Pages.update_markdown(client, %{
                 "page_id" => "def456",
                 "type" => "insert_content",
                 "insert_content" => %{
                   "content" => "## New Section",
                   "after" => "# Heading...end text"
                 }
               })

      assert_receive {:transport_request, update_request, _context}
      assert update_request.method == :patch
      assert update_request.url == "https://api.notion.com/v1/pages/def456/markdown"

      assert Jason.decode!(update_request.body) == %{
               "type" => "insert_content",
               "insert_content" => %{
                 "content" => "## New Section",
                 "after" => "# Heading...end text"
               }
             }
    end

    test "builds JSON and multipart file upload requests like the JS SDK" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response:
              ok_response(%{
                "object" => "file_upload",
                "id" => "62af0fc3-efaa-4c48-bf2a-7d6ce510fa59",
                "request_id" => "req-upload"
              })
          ]
        )

      assert {:ok, _response} =
               NotionSDK.FileUploads.create(client, %{
                 "filename" => "test.txt",
                 "content_type" => "text/plain",
                 "mode" => "single_part"
               })

      assert_receive {:transport_request, create_request, _context}
      assert create_request.method == :post
      assert create_request.url == "https://api.notion.com/v1/file_uploads"
      assert create_request.headers["content-type"] == "application/json"

      assert Jason.decode!(create_request.body) == %{
               "filename" => "test.txt",
               "content_type" => "text/plain",
               "mode" => "single_part"
             }

      assert {:ok, _response} =
               NotionSDK.FileUploads.send(client, %{
                 "file_upload_id" => "62af0fc3-efaa-4c48-bf2a-7d6ce510fa59",
                 "file" => %{"filename" => "test.txt", "data" => "test"},
                 "part_number" => "2"
               })

      assert_receive {:transport_request, send_request, _context}
      assert send_request.method == :post

      assert send_request.url ==
               "https://api.notion.com/v1/file_uploads/62af0fc3-efaa-4c48-bf2a-7d6ce510fa59/send"

      assert String.starts_with?(send_request.headers["content-type"], "multipart/form-data;")

      body = IO.iodata_to_binary(send_request.body)

      assert body =~ ~s(name="part_number")
      assert body =~ ~s(name="file")
      assert body =~ ~s(filename="test.txt")
      assert body =~ "test"
    end

    test "accepts request-level custom headers on low-level requests" do
      client =
        Client.new(
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 call: {__MODULE__, :request},
                 method: :get,
                 path_template: "/v1/comments",
                 url: "/v1/comments",
                 path_params: %{},
                 query: %{},
                 body: %{},
                 form_data: %{},
                 headers: %{"X-Custom-Header" => "custom-value"}
               })

      assert_receive {:transport_request, request, _context}
      assert request.headers["X-Custom-Header"] == "custom-value"
      assert request.headers["Notion-Version"] == "2025-09-03"
    end

    test "accepts the simplified raw request shape for query params and custom headers" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 method: :get,
                 path: "/v1/comments",
                 path_params: %{},
                 query: %{"page_size" => 25},
                 body: nil,
                 form_data: nil,
                 headers: %{"X-Custom-Header" => "custom-value"}
               })

      assert_receive {:transport_request, request, _context}
      assert request.url == "https://api.notion.com/v1/comments?page_size=25"
      assert request.headers["Authorization"] == "Bearer secret_test_token"
      assert request.headers["X-Custom-Header"] == "custom-value"
      assert request.headers["Notion-Version"] == "2025-09-03"
    end

    test "supports auth overrides on the simplified raw request shape" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 method: :get,
                 path: "/v1/users/me",
                 path_params: %{},
                 query: %{},
                 body: nil,
                 form_data: nil,
                 headers: %{},
                 auth: false
               })

      assert_receive {:transport_request, request, _context}
      refute Map.has_key?(request.headers, "Authorization")
    end

    test "maps additional_data from validation errors without fabricating retry_after" do
      client =
        Client.new(
          auth: "secret_test_token",
          retry: false,
          transport: TestTransport,
          transport_opts: [
            response:
              error_response(
                400,
                %{
                  "code" => "validation_error",
                  "message" =>
                    "Databases with multiple data sources are not supported in this API version.",
                  "additional_data" => %{
                    "error_type" => "multiple_data_sources_for_database",
                    "database_id" => "123",
                    "child_data_source_ids" => ["456", "789"],
                    "minimum_api_version" => "2025-09-03"
                  }
                }
              )
          ]
        )

      assert {:error, %NotionSDK.Error{} = error} =
               NotionSDK.Databases.retrieve(client, %{"database_id" => "123"})

      assert error.code == :validation_error

      assert error.additional_data == %{
               "error_type" => "multiple_data_sources_for_database",
               "database_id" => "123",
               "child_data_source_ids" => ["456", "789"],
               "minimum_api_version" => "2025-09-03"
             }

      assert error.retry_after_ms == nil
    end

    test "generated endpoints reject path traversal before transport" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [test_pid: self()]
        )

      assert_raise ArgumentError, ~r/path traversal/i, fn ->
        NotionSDK.Pages.retrieve(client, %{"page_id" => "../secret"})
      end

      refute_receive {:transport_request, _request, _context}
    end

    test "default generated responses remain maps" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [response: ok_response(page_response_body())]
        )

      assert {:ok, response} =
               NotionSDK.Pages.retrieve(client, %{
                 "page_id" => "00000000-0000-0000-0000-000000000010"
               })

      assert is_map(response)
      refute match?(%NotionSDK.PageObjectResponse{}, response)
      assert response["object"] == "page"
      assert is_map(response["created_by"])
    end

    test "typed responses return generated structs when opt-in is enabled" do
      client =
        Client.new(
          auth: "secret_test_token",
          typed_responses: true,
          transport: TestTransport,
          transport_opts: [response: ok_response(page_response_body())]
        )

      assert {:ok, %NotionSDK.PageObjectResponse{} = response} =
               NotionSDK.Pages.retrieve(client, %{
                 "page_id" => "00000000-0000-0000-0000-000000000010"
               })

      assert %DateTime{} = response.created_time
      assert %NotionSDK.PartialUserObjectResponse{} = response.created_by
      assert %NotionSDK.WorkspaceParentForBlockBasedObjectResponse{} = response.parent
      assert response.object == "page"
    end

    test "typed runtime rejects invalid success payloads" do
      client =
        Client.new(
          auth: "secret_test_token",
          typed_responses: true,
          transport: TestTransport,
          transport_opts: [
            response:
              ok_response(%{
                "object" => "page",
                "id" => "not-a-uuid"
              })
          ]
        )

      assert {:error, %NotionSDK.Error{code: :validation}} =
               NotionSDK.Pages.retrieve(client, %{
                 "page_id" => "00000000-0000-0000-0000-000000000010"
               })
    end

    test "typed runtime validates request payloads before transport" do
      client =
        Client.new(
          auth: "secret_test_token",
          typed_responses: true,
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:error, %NotionSDK.Error{code: :validation}} =
               NotionSDK.FileUploads.create(client, %{
                 "filename" => "test.txt",
                 "content_type" => "text/plain",
                 "mode" => "not-a-real-mode"
               })

      refute_receive {:transport_request, _request, _context}
    end

    test "raw requests materialize typed responses when response_schema is provided" do
      client =
        Client.new(
          auth: "secret_test_token",
          typed_responses: true,
          transport: TestTransport,
          transport_opts: [response: ok_response(page_response_body())]
        )

      assert {:ok, %NotionSDK.PageObjectResponse{} = response} =
               Client.request(client, %{
                 method: :get,
                 path: "/v1/pages/{page_id}",
                 path_params: %{"page_id" => "00000000-0000-0000-0000-000000000010"},
                 query: %{},
                 body: nil,
                 form_data: nil,
                 headers: %{},
                 response_schema: {NotionSDK.PageObjectResponse, :t}
               })

      assert response.object == "page"
      assert %DateTime{} = response.created_time
    end

    test "raw requests validate request payloads when request_schema is provided" do
      client =
        Client.new(
          auth: "secret_test_token",
          typed_responses: true,
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:error, %NotionSDK.Error{code: :validation}} =
               Client.request(client, %{
                 method: :post,
                 path: "/v1/file_uploads",
                 path_params: %{},
                 query: %{},
                 body: %{
                   "filename" => "test.txt",
                   "content_type" => "text/plain",
                   "mode" => "not-a-real-mode"
                 },
                 form_data: nil,
                 headers: %{},
                 request_schema: {NotionSDK.FileUploads, :create_json_req},
                 response_schema: {NotionSDK.FileUploadObjectResponse, :t}
               })

      refute_receive {:transport_request, _request, _context}
    end
  end

  describe "retry parity" do
    test "retries rate-limited POST requests" do
      client =
        Client.new(
          retry: [max_retries: 1, initial_retry_delay_ms: 1, max_retry_delay_ms: 1],
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response: fn _request, _context ->
              attempt = Process.get(:post_429_attempt, 0)
              Process.put(:post_429_attempt, attempt + 1)

              case attempt do
                0 ->
                  error_response(
                    429,
                    %{"code" => "rate_limited", "message" => "Slow down"},
                    %{"retry-after" => "0"}
                  )

                _ ->
                  ok_response(%{"ok" => true})
              end
            end
          ]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 call: {__MODULE__, :search},
                 method: :post,
                 path_template: "/v1/search",
                 url: "/v1/search",
                 path_params: %{},
                 query: %{},
                 body: %{"query" => "docs"},
                 form_data: %{}
               })

      assert_receive {:transport_request, _request, _context}
      assert_receive {:transport_request, _request, _context}
    end

    test "retries idempotent GET requests on 500" do
      client =
        Client.new(
          retry: [max_retries: 1, initial_retry_delay_ms: 1, max_retry_delay_ms: 1],
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response: fn _request, _context ->
              attempt = Process.get(:get_500_attempt, 0)
              Process.put(:get_500_attempt, attempt + 1)

              case attempt do
                0 ->
                  error_response(500, %{"code" => "internal_server_error", "message" => "Boom"})

                _ ->
                  ok_response(%{"ok" => true})
              end
            end
          ]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 call: {__MODULE__, :get_self},
                 method: :get,
                 path_template: "/v1/users/me",
                 url: "/v1/users/me",
                 path_params: %{},
                 query: %{},
                 body: %{},
                 form_data: %{}
               })

      assert_receive {:transport_request, _request, _context}
      assert_receive {:transport_request, _request, _context}
    end

    test "does not retry non-idempotent POST requests on 500" do
      client =
        Client.new(
          retry: [max_retries: 1, initial_retry_delay_ms: 1, max_retry_delay_ms: 1],
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response:
              error_response(500, %{
                "code" => "internal_server_error",
                "message" => "Boom"
              })
          ]
        )

      assert {:error, %NotionSDK.Error{code: :internal_server_error}} =
               Client.request(client, %{
                 call: {__MODULE__, :create_page},
                 method: :post,
                 path_template: "/v1/pages",
                 url: "/v1/pages",
                 path_params: %{},
                 query: %{},
                 body: %{"parent" => %{"type" => "workspace"}},
                 form_data: %{}
               })

      assert_receive {:transport_request, _request, _context}
      refute_receive {:transport_request, _request, _context}
    end

    test "retries transient transport failures but not non-transient local errors" do
      transient_client =
        Client.new(
          retry: [max_retries: 1, initial_retry_delay_ms: 1, max_retry_delay_ms: 1],
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response: fn _request, _context ->
              attempt = Process.get(:transport_timeout_attempt, 0)
              Process.put(:transport_timeout_attempt, attempt + 1)

              case attempt do
                0 -> {:error, :timeout}
                _ -> ok_response(%{"ok" => true})
              end
            end
          ]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(transient_client, %{
                 call: {__MODULE__, :get_self},
                 method: :get,
                 path_template: "/v1/users/me",
                 url: "/v1/users/me",
                 path_params: %{},
                 query: %{},
                 body: %{},
                 form_data: %{}
               })

      assert_receive {:transport_request, _request, _context}
      assert_receive {:transport_request, _request, _context}

      non_transient_client =
        Client.new(
          retry: [max_retries: 1, initial_retry_delay_ms: 1, max_retry_delay_ms: 1],
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: {:error, :nxdomain}]
        )

      assert {:error, %NotionSDK.Error{code: :api_connection}} =
               Client.request(non_transient_client, %{
                 call: {__MODULE__, :get_self},
                 method: :get,
                 path_template: "/v1/users/me",
                 url: "/v1/users/me",
                 path_params: %{},
                 query: %{},
                 body: %{},
                 form_data: %{}
               })

      assert_receive {:transport_request, _request, _context}
      refute_receive {:transport_request, _request, _context}
    end
  end

  describe "foundation runtime" do
    test "derives endpoint metadata for resilience, telemetry, and pool routing" do
      client =
        Client.new(
          auth: "secret_test_token",
          foundation: [
            integration_key: {:integration, :demo},
            rate_limit: [enabled: false],
            circuit_breaker: [enabled: false],
            telemetry: [enabled: false]
          ],
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} = NotionSDK.Users.get_self(client)
      assert_receive {:transport_request, core_request, _context}
      assert core_request.metadata.endpoint.resource == "core_api"
      assert core_request.metadata.endpoint.retry == "notion.read"
      assert core_request.metadata.endpoint.circuit_breaker == "notion:api.notion.com:core_api"
      assert core_request.metadata.pool_type == "core_api"

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 call: {__MODULE__, :send_upload},
                 method: :post,
                 path_template: "/v1/file_uploads/{file_upload_id}/send",
                 url: "/v1/file_uploads/{file_upload_id}/send",
                 path_params: %{"file_upload_id" => "upload-123"},
                 query: %{},
                 body: %{},
                 form_data: %{"file" => {"test.txt", "payload", "text/plain"}}
               })

      assert_receive {:transport_request, upload_request, _context}
      assert upload_request.metadata.endpoint.resource == "file_upload_send"
      assert upload_request.metadata.endpoint.retry == "notion.file_upload_send"

      assert upload_request.metadata.endpoint.circuit_breaker ==
               "notion:api.notion.com:file_upload_send"

      oauth_client =
        Client.new(
          auth: "secret_test_token",
          foundation: [
            integration_key: {:integration, :demo},
            rate_limit: [enabled: false],
            circuit_breaker: [enabled: false],
            telemetry: [enabled: false]
          ],
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} =
               NotionSDK.OAuth.introspect(oauth_client, %{
                 "client_id" => "client-id",
                 "client_secret" => "client-secret",
                 "token" => "token-123"
               })

      assert_receive {:transport_request, oauth_request, _context}
      assert oauth_request.metadata.endpoint.resource == "oauth_control"
      assert oauth_request.metadata.endpoint.retry == "notion.oauth_control"

      assert oauth_request.metadata.endpoint.circuit_breaker ==
               "notion:api.notion.com:oauth_control"
    end

    test "derives endpoint metadata for the simplified raw request shape too" do
      client =
        Client.new(
          auth: "secret_test_token",
          foundation: [
            integration_key: {:integration, :demo},
            rate_limit: [enabled: false],
            circuit_breaker: [enabled: false],
            telemetry: [enabled: false]
          ],
          transport: TestTransport,
          transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 method: :post,
                 path: "/v1/file_uploads/{file_upload_id}/send",
                 path_params: %{"file_upload_id" => "upload-123"},
                 query: %{},
                 body: nil,
                 form_data: %{
                   "file" => %{
                     "filename" => "test.txt",
                     "data" => "payload",
                     "content_type" => "text/plain"
                   }
                 },
                 headers: %{}
               })

      assert_receive {:transport_request, request, _context}
      assert request.metadata.endpoint.resource == "file_upload_send"
      assert request.metadata.endpoint.retry == "notion.file_upload_send"

      assert request.metadata.endpoint.circuit_breaker ==
               "notion:api.notion.com:file_upload_send"
    end

    test "shares rate-limit learning across endpoints for one integration" do
      parent = self()
      registry = Foundation.RateLimit.BackoffWindow.new_registry()

      client =
        Client.new(
          auth: "secret_test_token",
          retry: false,
          foundation: [
            integration_key: {:integration, :demo},
            rate_limit: [
              registry: registry,
              sleep_fun: fn ms -> send(parent, {:rate_limit_sleep, ms}) end
            ],
            circuit_breaker: [enabled: false],
            telemetry: [enabled: false]
          ],
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response: fn request, _context ->
              case request.url do
                "https://api.notion.com/v1/search" ->
                  error_response(
                    429,
                    %{"code" => "rate_limited", "message" => "Slow down"},
                    %{"retry-after" => "7"}
                  )

                _other ->
                  ok_response(%{"ok" => true})
              end
            end
          ]
        )

      assert {:error, %NotionSDK.Error{code: :rate_limited}} =
               NotionSDK.Search.search(client, %{"query" => "docs"})

      assert_receive {:transport_request, first_request, first_context}
      assert first_request.url == "https://api.notion.com/v1/search"
      assert first_context.rate_limit_opts[:key] == {:integration, :demo}

      assert {:ok, %{"ok" => true}} = NotionSDK.Users.get_self(client)

      assert_receive {:rate_limit_sleep, sleep_ms} when is_integer(sleep_ms) and sleep_ms > 0
      assert_receive {:transport_request, second_request, second_context}
      assert second_request.url == "https://api.notion.com/v1/users/me"
      assert second_context.rate_limit_opts[:key] == {:integration, :demo}
    end

    test "opens the circuit breaker for classified HTTP failures" do
      registry = Foundation.CircuitBreaker.Registry.new_registry()

      client =
        Client.new(
          auth: "secret_test_token",
          retry: false,
          foundation: [
            integration_key: {:integration, :demo},
            rate_limit: [enabled: false],
            circuit_breaker: [registry: registry, failure_threshold: 1, reset_timeout_ms: 60_000],
            telemetry: [enabled: false]
          ],
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response:
              error_response(503, %{
                "code" => "service_unavailable",
                "message" => "Later"
              })
          ]
        )

      assert {:error, %NotionSDK.Error{code: :service_unavailable}} =
               NotionSDK.Users.get_self(client)

      assert_receive {:transport_request, _request, _context}

      assert Foundation.CircuitBreaker.Registry.state(registry, "notion:api.notion.com:core_api") ==
               :open

      assert {:error, %NotionSDK.Error{code: :api_connection}} = NotionSDK.Users.get_self(client)
      refute_receive {:transport_request, _request, _context}
    end

    test "caller-side 4xx responses do not close a half-open breaker" do
      for status <- [401, 404, 422] do
        registry = Foundation.CircuitBreaker.Registry.new_registry()

        client =
          Client.new(
            auth: "secret_test_token",
            retry: false,
            foundation: [
              integration_key: {:integration, status},
              rate_limit: [enabled: false],
              circuit_breaker: [
                registry: registry,
                failure_threshold: 1,
                reset_timeout_ms: 0,
                half_open_max_calls: 1
              ],
              telemetry: [enabled: false]
            ],
            transport: TestTransport,
            transport_opts: [
              response: fn _request, _context ->
                phase = Process.get({:half_open_status, status}, :open)

                case phase do
                  :open ->
                    Process.put({:half_open_status, status}, :probe)
                    error_response(503, %{"code" => "service_unavailable", "message" => "Later"})

                  :probe ->
                    Process.put({:half_open_status, status}, :success)
                    error_response(status, %{"message" => "Caller issue"})

                  :success ->
                    ok_response(%{"ok" => true})
                end
              end
            ]
          )

        assert {:error, %NotionSDK.Error{code: :service_unavailable}} =
                 NotionSDK.Users.get_self(client)

        Process.sleep(5)

        assert {:error, %NotionSDK.Error{status: ^status}} = NotionSDK.Users.get_self(client)

        assert Foundation.CircuitBreaker.Registry.state(
                 registry,
                 "notion:api.notion.com:core_api"
               ) == :half_open

        assert {:ok, %{"ok" => true}} = NotionSDK.Users.get_self(client)

        assert Foundation.CircuitBreaker.Registry.state(
                 registry,
                 "notion:api.notion.com:core_api"
               ) == :closed
      end
    end

    test "non-upload 409 responses do not close a half-open breaker" do
      registry = Foundation.CircuitBreaker.Registry.new_registry()

      client =
        Client.new(
          auth: "secret_test_token",
          retry: false,
          foundation: [
            integration_key: {:integration, :conflict},
            rate_limit: [enabled: false],
            circuit_breaker: [
              registry: registry,
              failure_threshold: 1,
              reset_timeout_ms: 0,
              half_open_max_calls: 1
            ],
            telemetry: [enabled: false]
          ],
          transport: TestTransport,
          transport_opts: [
            response: fn _request, _context ->
              phase = Process.get(:conflict_breaker_phase, :open)

              case phase do
                :open ->
                  Process.put(:conflict_breaker_phase, :probe)
                  error_response(503, %{"code" => "service_unavailable", "message" => "Later"})

                :probe ->
                  Process.put(:conflict_breaker_phase, :success)
                  error_response(409, %{"message" => "Conflict"})

                :success ->
                  ok_response(%{"ok" => true})
              end
            end
          ]
        )

      assert {:error, %NotionSDK.Error{code: :service_unavailable}} =
               Client.request(client, %{
                 call: {__MODULE__, :create_page},
                 method: :post,
                 path_template: "/v1/pages",
                 url: "/v1/pages",
                 path_params: %{},
                 query: %{},
                 body: %{"parent" => %{"type" => "workspace"}},
                 form_data: %{}
               })

      Process.sleep(5)

      assert {:error, %NotionSDK.Error{status: 409}} =
               Client.request(client, %{
                 call: {__MODULE__, :create_page},
                 method: :post,
                 path_template: "/v1/pages",
                 url: "/v1/pages",
                 path_params: %{},
                 query: %{},
                 body: %{"parent" => %{"type" => "workspace"}},
                 form_data: %{}
               })

      assert Foundation.CircuitBreaker.Registry.state(registry, "notion:api.notion.com:core_api") ==
               :half_open

      assert {:ok, %{"ok" => true}} =
               Client.request(client, %{
                 call: {__MODULE__, :create_page},
                 method: :post,
                 path_template: "/v1/pages",
                 url: "/v1/pages",
                 path_params: %{},
                 query: %{},
                 body: %{"parent" => %{"type" => "workspace"}},
                 form_data: %{}
               })

      assert Foundation.CircuitBreaker.Registry.state(registry, "notion:api.notion.com:core_api") ==
               :closed
    end

    test "emits structured notion telemetry events" do
      handler_id = attach_telemetry([:notion_sdk, :request, :stop])

      on_exit(fn -> :telemetry.detach(handler_id) end)

      client =
        Client.new(
          auth: "secret_test_token",
          foundation: [
            integration_key: {:integration, :demo},
            rate_limit: [enabled: false],
            circuit_breaker: [enabled: false],
            telemetry: [metadata: %{service: :notion_test}]
          ],
          transport: TestTransport,
          transport_opts: [response: ok_response(%{"ok" => true})]
        )

      assert {:ok, %{"ok" => true}} = NotionSDK.Users.get_self(client)

      assert_receive {:telemetry, [:notion_sdk, :request, :stop], measurements, metadata}
      assert is_integer(measurements.duration)
      assert metadata.service == :notion_test
      assert metadata.resource == "core_api"
      assert metadata.retry_group == "notion.read"
      assert metadata.classification == :success
      refute Map.has_key?(metadata, :auth)
    end

    test "supports optional dispatch-based admission control with a named dispatch server" do
      parent = self()
      limiter_registry = Foundation.RateLimit.BackoffWindow.new_registry()
      dispatch_name = {:global, {__MODULE__, make_ref()}}

      limiter =
        Foundation.RateLimit.BackoffWindow.for_key(limiter_registry, {:integration, :dispatch})

      {:ok, _dispatch} =
        Foundation.Dispatch.start_link(
          name: dispatch_name,
          limiter: limiter,
          key: {:integration, :dispatch},
          sleep_fun: fn ms -> send(parent, {:dispatch_sleep, ms}) end,
          concurrency: 2,
          throttled_concurrency: 1,
          byte_budget: 1024 * 1024
        )

      client =
        Client.new(
          auth: "secret_test_token",
          retry: false,
          foundation: [
            integration_key: {:integration, :dispatch},
            rate_limit: [enabled: false],
            circuit_breaker: [enabled: false],
            telemetry: [enabled: false],
            dispatch: [enabled: true, dispatch: dispatch_name]
          ],
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response: fn request, _context ->
              case request.url do
                "https://api.notion.com/v1/search" ->
                  error_response(
                    429,
                    %{"code" => "rate_limited", "message" => "Slow down"},
                    %{"retry-after" => "7"}
                  )

                _other ->
                  ok_response(%{"ok" => true})
              end
            end
          ]
        )

      assert {:error, %NotionSDK.Error{code: :rate_limited}} =
               NotionSDK.Search.search(client, %{"query" => "docs"})

      assert_receive {:transport_request, _request, first_context}
      assert first_context.admission_control == Pristine.Adapters.AdmissionControl.Dispatch
      assert first_context.admission_opts[:dispatch] == dispatch_name
      assert Foundation.Dispatch.snapshot(dispatch_name).backoff_active?

      assert {:ok, %{"ok" => true}} = NotionSDK.Users.get_self(client)

      assert_receive {:transport_request, _request, second_context}
      assert second_context.admission_control == Pristine.Adapters.AdmissionControl.Dispatch
      assert second_context.admission_opts[:dispatch] == dispatch_name
    end
  end

  defp ok_response(body, headers \\ %{}) do
    {:ok, %Response{status: 200, headers: headers, body: Jason.encode!(body)}}
  end

  defp error_response(status, body, headers \\ %{}) do
    {:ok, %Response{status: status, headers: headers, body: Jason.encode!(body)}}
  end

  defp page_response_body do
    %{
      "cover" => nil,
      "created_by" => %{
        "id" => "00000000-0000-0000-0000-000000000011",
        "object" => "user"
      },
      "created_time" => "2024-01-01T00:00:00Z",
      "icon" => nil,
      "id" => "00000000-0000-0000-0000-000000000010",
      "in_trash" => false,
      "is_locked" => false,
      "last_edited_by" => %{
        "id" => "00000000-0000-0000-0000-000000000012",
        "object" => "user"
      },
      "last_edited_time" => "2024-01-02T00:00:00Z",
      "object" => "page",
      "parent" => %{
        "type" => "workspace",
        "workspace" => true
      },
      "properties" => %{},
      "public_url" => nil,
      "url" => "https://www.notion.so/example-page"
    }
  end

  defp attach_telemetry(event) do
    handler_id = {__MODULE__, make_ref()}
    parent = self()

    :ok =
      :telemetry.attach(
        handler_id,
        event,
        fn event_name, measurements, metadata, _config ->
          send(parent, {:telemetry, event_name, measurements, metadata})
        end,
        nil
      )

    handler_id
  end
end
