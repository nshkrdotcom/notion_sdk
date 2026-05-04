defmodule NotionSDK.GovernedAuthorityTest do
  use ExUnit.Case, async: false

  alias NotionSDK.Client
  alias NotionSDK.GovernedAuthority
  alias NotionSDK.TestTransport
  alias Pristine.OAuth2.Token, as: OAuth2Token

  @app_env_keys [
    {:notion_sdk, :base_url},
    {:notion_sdk, :notion_version},
    {:notion_sdk, :timeout_ms},
    {:notion_sdk, :user_agent}
  ]

  setup do
    original_app_env =
      Enum.map(@app_env_keys, fn {app, key} -> {app, key, Application.get_env(app, key)} end)

    on_exit(fn ->
      Enum.each(original_app_env, fn
        {app, key, nil} -> Application.delete_env(app, key)
        {app, key, value} -> Application.put_env(app, key, value)
      end)
    end)

    :ok
  end

  test "governed requests materialize authority base URL, workspace identity, and headers" do
    Application.put_env(:notion_sdk, :base_url, "https://env.example.test")

    client =
      Client.new(
        governed_authority: authority(base_url: "https://governed.notion.test"),
        transport: TestTransport,
        transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
      )

    assert client.auth == nil
    assert client.base_url == "https://governed.notion.test"
    assert client.governed_authority.workspace_ref == "workspace://tenant-1/notion/workspace-123"
    assert client.context.governed_authority.base_url == "https://governed.notion.test"

    assert {:ok, %{"ok" => true}} = NotionSDK.Users.get_self(client)

    assert_receive {:transport_request, request, context}
    assert request.url == "https://governed.notion.test/v1/users/me"
    assert request.headers["Authorization"] == "Bearer authority-token"
    assert request.headers["X-Governed-Target"] == "target-123"
    assert request.headers["X-Governed-Workspace"] == "workspace-123"
    assert request.headers["Notion-Version"] == "2025-09-03"

    assert context.governed_authority.credential_handle_ref ==
             "credential-handle://tenant-1/notion/workspace-123/bearer"
  end

  test "governed client construction rejects unmanaged bearer oauth and base URL inputs" do
    forbidden_client_opts = [
      [auth: "secret_test_token"],
      [base_url: "https://env.example.test"],
      [
        oauth2: [
          token_source:
            {Pristine.Adapters.TokenSource.Static,
             token: OAuth2Token.from_map(%{access_token: "oauth-access-token"})}
        ]
      ],
      [
        oauth2: [
          token_source: {Pristine.Adapters.TokenSource.File, path: "/tmp/notion-oauth.json"}
        ],
        default_client: NotionSDK.Client,
        env: %{"NOTION_TOKEN" => "env-token"}
      ]
    ]

    for opts <- forbidden_client_opts do
      error =
        assert_raise ArgumentError, fn ->
          opts
          |> Keyword.put(:governed_authority, authority())
          |> Client.new()
        end

      assert String.contains?(error.message, "governed authority")
    end
  end

  test "governed generated raw and oauth requests reject unmanaged auth overrides" do
    client =
      Client.new(
        governed_authority: authority(),
        transport: TestTransport,
        transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
      )

    generated_error =
      assert_raise ArgumentError, fn ->
        NotionSDK.Users.get_self(client, %{"auth" => "request-token"})
      end

    assert String.contains?(generated_error.message, "governed authority")

    raw_error =
      assert_raise ArgumentError, fn ->
        Client.request(client, %{
          method: :get,
          path: "/v1/users/me",
          path_params: %{},
          query: %{},
          body: nil,
          form_data: nil,
          headers: %{},
          auth: "request-token"
        })
      end

    assert String.contains?(raw_error.message, "governed authority")

    oauth_error =
      assert_raise ArgumentError, fn ->
        NotionSDK.OAuth.introspect(client, %{
          "client_id" => "client-id",
          "client_secret" => "client-secret",
          "token" => "token-123"
        })
      end

    assert String.contains?(oauth_error.message, "governed authority")
  end

  test "standalone direct auth and oauth token sources remain compatible outside governed mode" do
    client =
      Client.new(
        auth: "secret_test_token",
        transport: TestTransport,
        transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
      )

    assert {:ok, %{"ok" => true}} = NotionSDK.Users.get_self(client)

    assert_receive {:transport_request, bearer_request, _context}
    assert bearer_request.headers["Authorization"] == "Bearer secret_test_token"

    oauth_client =
      Client.new(
        oauth2: [
          token_source:
            {Pristine.Adapters.TokenSource.Static,
             token: OAuth2Token.from_map(%{access_token: "oauth-access-token"})}
        ],
        transport: TestTransport,
        transport_opts: [test_pid: self(), response: ok_response(%{"ok" => true})]
      )

    assert {:ok, %{"ok" => true}} = NotionSDK.Users.get_self(oauth_client)

    assert_receive {:transport_request, oauth_request, _context}
    assert oauth_request.headers["Authorization"] == "Bearer oauth-access-token"
  end

  test "upstream snapshot helper remains fixed-string after remediation" do
    source = File.read!("priv/upstream/snapshots/notion-sdk-js/src/helpers.ts")

    for token <- ["Reg" <> "ex", "Reg" <> "Exp", ".mat" <> "ch(", "/" <> "["] do
      refute String.contains?(source, token)
    end
  end

  defp authority(overrides \\ []) do
    [
      base_url: "https://governed.example.test",
      base_url_ref: "base-url://tenant-1/notion/api",
      authority_ref: "authority://tenant-1/notion/workspace-123",
      tenant_ref: "tenant://tenant-1",
      provider_account_ref: "provider-account://tenant-1/notion/workspace-123",
      connector_instance_ref: "connector-instance://tenant-1/notion/default",
      credential_handle_ref: "credential-handle://tenant-1/notion/workspace-123/bearer",
      credential_lease_ref: "credential-lease://tenant-1/notion/workspace-123/bearer",
      target_ref: "target://tenant-1/notion/http",
      request_scope_ref: "request-scope://tenant-1/notion/users/me",
      operation_policy_ref: "operation-policy://tenant-1/notion/read",
      workspace_ref: "workspace://tenant-1/notion/workspace-123",
      header_policy_ref: "header-policy://tenant-1/notion/default",
      redaction_ref: "redaction://tenant-1/notion/default",
      materialization_kind: "bearer",
      materialization_ref: "materialization://tenant-1/notion/users/me",
      bearer_token_ref: "bearer-token://tenant-1/notion/workspace-123",
      headers: %{
        "X-Governed-Target" => "target-123",
        "X-Governed-Workspace" => "workspace-123"
      },
      credential_headers: %{"Authorization" => "Bearer authority-token"},
      allowed_header_names: [
        "authorization",
        "notion-version",
        "user-agent",
        "x-governed-target",
        "x-governed-workspace"
      ]
    ]
    |> Keyword.merge(overrides)
    |> GovernedAuthority.new!()
  end

  defp ok_response(body) do
    {:ok, Pristine.Response.new(status: 200, headers: %{}, body: Jason.encode!(body))}
  end
end
