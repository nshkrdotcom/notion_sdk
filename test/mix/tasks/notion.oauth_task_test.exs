defmodule Mix.Tasks.Notion.OAuthTaskTest do
  use ExUnit.Case, async: false

  alias Mix.Tasks.Notion.Oauth, as: OAuthTask
  alias Pristine.OAuth2.Token, as: SDKToken

  @moduletag :tmp_dir

  defmodule FakeInteractive do
    def authorize(provider, opts) do
      send(Process.get(:notion_oauth_task_test_pid), {:interactive_authorize, provider, opts})

      Process.get(
        :notion_oauth_task_result,
        {:ok,
         SDKToken.from_map(%{
           access_token: "secret_access",
           refresh_token: "refresh_access",
           other_params: %{
             "bot_id" => "bot-123",
             "workspace_id" => "workspace-123",
             "workspace_name" => "Example Workspace"
           }
         })}
      )
    end
  end

  defmodule FakeOAuth2 do
    def refresh_token(provider, refresh_token, opts) do
      send(
        Process.get(:notion_oauth_task_test_pid),
        {:oauth_refresh, provider, refresh_token, opts}
      )

      Process.get(
        :notion_oauth_refresh_result,
        {:ok,
         SDKToken.from_map(%{
           access_token: "refreshed_access",
           refresh_token: "refresh_rotated"
         })}
      )
    end
  end

  setup do
    previous_shell = Mix.shell()
    Mix.shell(Mix.Shell.Process)
    Mix.Task.reenable("notion.oauth")
    Process.put(:notion_oauth_task_test_pid, self())
    Application.put_env(:notion_sdk, :oauth_interactive_module, FakeInteractive)
    Application.put_env(:notion_sdk, :oauth2_module, FakeOAuth2)
    previous_config = put_default_oauth_config()

    on_exit(fn ->
      restore_oauth_config(previous_config)
      Application.delete_env(:notion_sdk, :oauth_interactive_module)
      Application.delete_env(:notion_sdk, :oauth2_module)
      Process.delete(:notion_oauth_task_result)
      Process.delete(:notion_oauth_refresh_result)
      Process.delete(:notion_oauth_task_test_pid)
      Mix.shell(previous_shell)
    end)

    :ok
  end

  test "loads oauth credentials from config and passes manual mode flags through" do
    OAuthTask.run(["--manual", "--no-browser", "--timeout=90000"])

    assert_receive {:interactive_authorize, provider, opts}
    assert provider.name == "notion"
    assert opts[:client_id] == "client-id"
    assert opts[:client_secret] == "client-secret"
    assert opts[:redirect_uri] == "http://127.0.0.1:40071/callback"
    assert opts[:manual?] == true
    assert opts[:open_browser?] == false
    assert opts[:timeout_ms] == 90_000
    assert opts[:params] == [owner: "user"]
  end

  test "lets --redirect-uri override configured redirect URI for loopback mode" do
    OAuthTask.run(["--redirect-uri=http://127.0.0.1:40123/callback"])

    assert_receive {:interactive_authorize, _provider, opts}
    assert opts[:redirect_uri] == "http://127.0.0.1:40123/callback"
    assert opts[:manual?] == false
    assert opts[:open_browser?] == true
  end

  test "task module maps to mix notion.oauth" do
    assert Mix.Task.task_name(OAuthTask) == "notion.oauth"
  end

  test "prints token exports and token metadata" do
    OAuthTask.run([])

    assert_receive {:mix_shell, :info, ["Access token:"]}
    assert_receive {:mix_shell, :info, ["secret_access"]}
    assert_receive {:mix_shell, :info, ["Refresh token:"]}
    assert_receive {:mix_shell, :info, ["refresh_access"]}
    assert_receive {:mix_shell, :info, ["Workspace name: Example Workspace"]}
    assert_receive {:mix_shell, :info, ["Workspace id: workspace-123"]}
    assert_receive {:mix_shell, :info, ["Bot id: bot-123"]}
    assert_receive {:mix_shell, :info, ["Export commands:"]}
    assert_receive {:mix_shell, :info, ["export NOTION_OAUTH_ACCESS_TOKEN=\"secret_access\""]}
    assert_receive {:mix_shell, :info, ["export NOTION_OAUTH_REFRESH_TOKEN=\"refresh_access\""]}
  end

  test "saves tokens to the default XDG path when requested", %{tmp_dir: tmp_dir} do
    Application.put_env(:notion_sdk, :oauth_config_home, tmp_dir)

    OAuthTask.run(["--save"])

    path = Path.join([tmp_dir, "notion_sdk", "oauth", "notion.json"])

    assert_receive {:mix_shell, :info, ["Saved token file: " <> ^path]}
    assert_receive {:mix_shell, :info, ["export NOTION_OAUTH_TOKEN_PATH=\"" <> ^path <> "\""]}

    assert {:ok, payload} = File.read(path)

    assert Jason.decode!(payload) == %{
             "access_token" => "secret_access",
             "expires_at" => nil,
             "other_params" => %{
               "bot_id" => "bot-123",
               "workspace_id" => "workspace-123",
               "workspace_name" => "Example Workspace"
             },
             "refresh_token" => "refresh_access",
             "token_type" => "Bearer"
           }
  end

  test "uses --path as the save destination", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "custom-notion-token.json")

    OAuthTask.run(["--save", "--path=#{path}"])

    assert_receive {:mix_shell, :info, ["Saved token file: " <> ^path]}
    assert_receive {:mix_shell, :info, ["export NOTION_OAUTH_TOKEN_PATH=\"" <> ^path <> "\""]}
    assert File.exists?(path)
  end

  test "refreshes a saved token, persists rotated refresh tokens, and prints the saved path",
       %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "saved-notion-token.json")

    assert :ok =
             Pristine.Adapters.TokenSource.File.put(
               SDKToken.from_map(%{
                 access_token: "secret_access",
                 refresh_token: "refresh_access",
                 other_params: %{"workspace_name" => "Example Workspace"}
               }),
               path: path
             )

    Process.put(
      :notion_oauth_refresh_result,
      {:ok,
       SDKToken.from_map(%{
         access_token: "refreshed_access",
         refresh_token: "refresh_rotated",
         other_params: %{"workspace_id" => "workspace-123"}
       })}
    )

    OAuthTask.run(["refresh", "--path=#{path}"])

    assert_receive {:oauth_refresh, provider, "refresh_access", opts}
    assert provider.name == "notion"
    assert opts[:client_id] == "client-id"
    assert opts[:client_secret] == "client-secret"
    assert match?(%{__struct__: _}, opts[:context])

    assert_receive {:mix_shell, :info, ["Updated token file: " <> ^path]}
    assert_receive {:mix_shell, :info, ["Access token:"]}
    assert_receive {:mix_shell, :info, ["refreshed_access"]}
    assert_receive {:mix_shell, :info, ["Refresh token:"]}
    assert_receive {:mix_shell, :info, ["refresh_rotated"]}
    assert_receive {:mix_shell, :info, ["Workspace name: Example Workspace"]}
    assert_receive {:mix_shell, :info, ["Workspace id: workspace-123"]}
    assert_receive {:mix_shell, :info, ["export NOTION_OAUTH_ACCESS_TOKEN=\"refreshed_access\""]}
    assert_receive {:mix_shell, :info, ["export NOTION_OAUTH_REFRESH_TOKEN=\"refresh_rotated\""]}
    assert_receive {:mix_shell, :info, ["export NOTION_OAUTH_TOKEN_PATH=\"" <> ^path <> "\""]}

    assert {:ok, token} =
             Pristine.Adapters.TokenSource.File.fetch(path: path)

    assert token.__struct__ == SDKToken.from_map(%{}).__struct__
    assert token.access_token == "refreshed_access"
    assert token.refresh_token == "refresh_rotated"

    assert token.other_params == %{
             "workspace_id" => "workspace-123",
             "workspace_name" => "Example Workspace"
           }
  end

  test "refresh raises when the saved token file does not contain a refresh token", %{
    tmp_dir: tmp_dir
  } do
    path = Path.join(tmp_dir, "missing-refresh.json")

    assert :ok =
             Pristine.Adapters.TokenSource.File.put(
               SDKToken.from_map(%{access_token: "secret_access"}),
               path: path
             )

    error =
      assert_raise Mix.Error, fn ->
        OAuthTask.run(["refresh", "--path=#{path}"])
      end

    assert String.contains?(error.message, "does not contain a refresh token")
  end

  defp put_default_oauth_config do
    keys = [
      :oauth_client_id,
      :oauth_client_secret,
      :oauth_redirect_uri,
      :oauth_token_path,
      :oauth_config_home
    ]

    previous = Map.new(keys, &{&1, Application.fetch_env(:notion_sdk, &1)})

    Application.put_env(:notion_sdk, :oauth_client_id, "client-id")
    Application.put_env(:notion_sdk, :oauth_client_secret, "client-secret")
    Application.put_env(:notion_sdk, :oauth_redirect_uri, "http://127.0.0.1:40071/callback")

    previous
  end

  defp restore_oauth_config(previous) do
    Enum.each(previous, fn
      {key, {:ok, value}} -> Application.put_env(:notion_sdk, key, value)
      {key, :error} -> Application.delete_env(:notion_sdk, key)
    end)
  end
end
