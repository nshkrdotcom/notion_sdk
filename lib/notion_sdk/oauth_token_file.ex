defmodule NotionSDK.OAuthTokenFile do
  @moduledoc """
  Helpers for the saved OAuth token file used by `mix notion.oauth --save`.

  The default path follows the configured OAuth config home when one is set
  under `:notion_sdk, :oauth_config_home`; otherwise it falls back to:

      ~/.config/notion_sdk/oauth/notion.json
  """

  @spec default_path(String.t() | nil) :: String.t()
  def default_path(config_home \\ nil) do
    config_root =
      case config_home || Application.get_env(:notion_sdk, :oauth_config_home) do
        value when is_binary(value) and value != "" -> value
        _other -> Path.join(System.user_home!(), ".config")
      end

    Path.join([config_root, "notion_sdk", "oauth", "notion.json"])
  end

  @spec resolve_env_or_default(String.t() | nil) :: String.t()
  def resolve_env_or_default(path \\ nil) do
    case path do
      value when is_binary(value) and value != "" -> Path.expand(value)
      _other -> default_path()
    end
  end
end
