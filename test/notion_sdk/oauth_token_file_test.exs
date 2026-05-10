defmodule NotionSDK.OAuthTokenFileTest do
  use ExUnit.Case, async: false

  @moduletag :tmp_dir

  setup %{tmp_dir: tmp_dir} do
    previous_config_home = Application.fetch_env(:notion_sdk, :oauth_config_home)
    Application.put_env(:notion_sdk, :oauth_config_home, tmp_dir)

    on_exit(fn ->
      case previous_config_home do
        {:ok, value} -> Application.put_env(:notion_sdk, :oauth_config_home, value)
        :error -> Application.delete_env(:notion_sdk, :oauth_config_home)
      end
    end)

    :ok
  end

  test "default_path uses configured config home when available", %{tmp_dir: tmp_dir} do
    assert NotionSDK.OAuthTokenFile.default_path() ==
             Path.join([tmp_dir, "notion_sdk", "oauth", "notion.json"])
  end

  test "resolve_env_or_default expands explicit override paths", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "../custom/oauth.json")

    assert NotionSDK.OAuthTokenFile.resolve_env_or_default(path) == Path.expand(path)
  end
end
