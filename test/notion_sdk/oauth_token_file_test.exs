defmodule NotionSDK.OAuthTokenFileTest do
  use ExUnit.Case, async: false

  @moduletag :tmp_dir

  setup %{tmp_dir: tmp_dir} do
    previous_xdg = System.get_env("XDG_CONFIG_HOME")
    previous_path = System.get_env("NOTION_OAUTH_TOKEN_PATH")

    System.put_env("XDG_CONFIG_HOME", tmp_dir)
    System.delete_env("NOTION_OAUTH_TOKEN_PATH")

    on_exit(fn ->
      case previous_xdg do
        nil -> System.delete_env("XDG_CONFIG_HOME")
        value -> System.put_env("XDG_CONFIG_HOME", value)
      end

      case previous_path do
        nil -> System.delete_env("NOTION_OAUTH_TOKEN_PATH")
        value -> System.put_env("NOTION_OAUTH_TOKEN_PATH", value)
      end
    end)

    :ok
  end

  test "default_path uses XDG_CONFIG_HOME when available", %{tmp_dir: tmp_dir} do
    assert NotionSDK.OAuthTokenFile.default_path() ==
             Path.join([tmp_dir, "notion_sdk", "oauth", "notion.json"])
  end

  test "resolve_env_or_default expands explicit override paths", %{tmp_dir: tmp_dir} do
    path = Path.join(tmp_dir, "../custom/oauth.json")

    assert NotionSDK.OAuthTokenFile.resolve_env_or_default(path) == Path.expand(path)
  end
end
