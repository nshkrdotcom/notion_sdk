defmodule Mix.Tasks.Notion.Oauth do
  @moduledoc """
  Runs the interactive Notion OAuth authorization-code flow and refreshes saved
  Notion OAuth tokens.

  Preferred first-run path for most public integrations with a registered HTTPS
  redirect URI under Notion's `OAuth Domain & URIs` settings:

      export NOTION_OAUTH_CLIENT_ID="..."
      export NOTION_OAUTH_CLIENT_SECRET="..."
      export NOTION_OAUTH_REDIRECT_URI="https://your-app.example.com/notion/callback"
      mix notion.oauth --save --manual --no-browser

  The task prints the authorization URL, waits for you to approve access in the
  browser, then asks you to paste back the final redirected URL containing the
  temporary authorization code.

  Optional loopback path if you have explicitly registered a literal loopback
  redirect URI such as `http://127.0.0.1:40071/callback` in Notion:

      export NOTION_OAUTH_REDIRECT_URI="http://127.0.0.1:40071/callback"
      mix notion.oauth --save

  `Webhook URL` settings in Notion are unrelated to OAuth redirect URIs.

  ## Usage

      mix notion.oauth
      mix notion.oauth --save
      mix notion.oauth --manual
      mix notion.oauth --no-browser
      mix notion.oauth --save --path=/tmp/notion-oauth.json
      mix notion.oauth --redirect-uri=http://127.0.0.1:40071/callback
      mix notion.oauth --timeout=120000
      mix notion.oauth refresh
      mix notion.oauth refresh --path=/tmp/notion-oauth.json
  """

  use Mix.Task

  alias Pristine.Adapters.TokenSource.File, as: FileTokenSource
  alias Pristine.OAuth2
  alias Pristine.OAuth2.Interactive
  alias Pristine.OAuth2.Token
  alias NotionSDK.OAuthTokenFile

  @default_timeout_ms 120_000
  @interactive_switches [
    manual: :boolean,
    no_browser: :boolean,
    path: :string,
    redirect_uri: :string,
    save: :boolean,
    timeout: :integer
  ]
  @refresh_switches [path: :string]

  @shortdoc "Complete the interactive Notion OAuth flow"

  @impl Mix.Task
  def run(["refresh" | args]) do
    Mix.Task.run("app.start")

    {opts, _argv, invalid} = OptionParser.parse(args, strict: @refresh_switches)

    if invalid != [] do
      Mix.raise("invalid options: #{format_invalid_options(invalid)}")
    end

    refresh_saved_token(opts)
  end

  def run(args) do
    Mix.Task.run("app.start")

    {opts, _argv, invalid} = OptionParser.parse(args, strict: @interactive_switches)

    if invalid != [] do
      Mix.raise("invalid options: #{format_invalid_options(invalid)}")
    end

    client_id = fetch_env!("NOTION_OAUTH_CLIENT_ID")
    client_secret = fetch_env!("NOTION_OAUTH_CLIENT_SECRET")
    redirect_uri = opts[:redirect_uri] || fetch_env!("NOTION_OAUTH_REDIRECT_URI")
    timeout_ms = opts[:timeout] || @default_timeout_ms
    open_browser? = not Keyword.get(opts, :no_browser, false)
    manual? = Keyword.get(opts, :manual, false)
    client = NotionSDK.Client.new()

    result =
      interactive_module().authorize(NotionSDK.OAuth.provider(),
        client_id: client_id,
        client_secret: client_secret,
        context: client.context,
        manual?: manual?,
        open_browser?: open_browser?,
        params: [owner: "user"],
        redirect_uri: redirect_uri,
        timeout_ms: timeout_ms
      )

    case result do
      {:ok, token} ->
        maybe_save_token(token, opts)
        print_token(token, opts)

      {:error, %Pristine.OAuth2.Error{} = error} ->
        Mix.raise(error.message)

      {:error, reason} ->
        Mix.raise("oauth failed: #{inspect(reason)}")
    end
  end

  defp refresh_saved_token(opts) do
    client_id = fetch_env!("NOTION_OAUTH_CLIENT_ID")
    client_secret = fetch_env!("NOTION_OAUTH_CLIENT_SECRET")
    path = save_path(opts)
    saved_token = load_saved_token!(path)
    refresh_token = fetch_saved_refresh_token!(saved_token, path)
    client = NotionSDK.Client.new()

    case oauth2_module().refresh_token(NotionSDK.OAuth.provider(), refresh_token,
           client_id: client_id,
           client_secret: client_secret,
           context: client.context
         ) do
      {:ok, %Token{} = refreshed_token} ->
        merged_token = merge_refreshed_token(saved_token, refreshed_token)
        save_refreshed_token!(merged_token, path)
        Mix.shell().info("Updated token file: #{path}")
        print_token(merged_token, save: true, path: path)

      {:error, %Pristine.OAuth2.Error{} = error} ->
        Mix.raise(error.message)

      {:error, reason} ->
        Mix.raise("token refresh failed: #{inspect(reason)}")
    end
  end

  defp interactive_module do
    Application.get_env(:notion_sdk, :oauth_interactive_module, Interactive)
  end

  defp oauth2_module do
    Application.get_env(:notion_sdk, :oauth2_module, OAuth2)
  end

  defp fetch_env!(name) do
    case System.get_env(name) do
      value when is_binary(value) and value != "" -> value
      _other -> Mix.raise("missing required environment variable #{name}")
    end
  end

  defp load_saved_token!(path) do
    case FileTokenSource.fetch(path: path) do
      {:ok, %Token{} = token} ->
        token

      :error ->
        Mix.raise("saved oauth token file not found at #{path}")

      {:error, reason} ->
        Mix.raise("failed to load oauth token from #{path}: #{format_save_error(reason)}")
    end
  end

  defp fetch_saved_refresh_token!(%Token{refresh_token: refresh_token}, _path)
       when is_binary(refresh_token) and refresh_token != "" do
    refresh_token
  end

  defp fetch_saved_refresh_token!(_token, path) do
    Mix.raise("#{path} does not contain a refresh token")
  end

  defp save_refreshed_token!(%Token{} = token, path) do
    case FileTokenSource.put(token, path: path) do
      :ok ->
        :ok

      {:error, reason} ->
        Mix.raise("failed to save oauth token to #{path}: #{format_save_error(reason)}")
    end
  end

  defp merge_refreshed_token(%Token{} = saved_token, %Token{} = refreshed_token) do
    access_token =
      refreshed_token.access_token ||
        Mix.raise("refreshed token response did not include an access token")

    %Token{
      access_token: access_token,
      refresh_token: merged_refresh_token(saved_token, refreshed_token),
      expires_at: refreshed_token.expires_at,
      token_type: merged_token_type(saved_token, refreshed_token),
      other_params: Map.merge(saved_token.other_params, refreshed_token.other_params)
    }
  end

  defp merged_refresh_token(
         %Token{refresh_token: _saved_refresh_token},
         %Token{refresh_token: refresh_token}
       )
       when is_binary(refresh_token) and refresh_token != "" do
    refresh_token
  end

  defp merged_refresh_token(%Token{refresh_token: saved_refresh_token}, _refreshed_token) do
    saved_refresh_token
  end

  defp merged_token_type(%Token{token_type: _saved_token_type}, %Token{token_type: token_type})
       when is_binary(token_type) and token_type != "" do
    token_type
  end

  defp merged_token_type(%Token{token_type: saved_token_type}, _refreshed_token) do
    saved_token_type
  end

  defp print_token(token, opts) do
    shell = Mix.shell()

    shell.info("Access token:")
    shell.info(token.access_token || "")

    if is_binary(token.refresh_token) and token.refresh_token != "" do
      shell.info("Refresh token:")
      shell.info(token.refresh_token)
    end

    print_metadata(shell, token.other_params)
    shell.info("Export commands:")
    shell.info(~s(export NOTION_OAUTH_ACCESS_TOKEN="#{token.access_token || ""}"))

    if is_binary(token.refresh_token) and token.refresh_token != "" do
      shell.info(~s(export NOTION_OAUTH_REFRESH_TOKEN="#{token.refresh_token}"))
    end

    if save_enabled?(opts) do
      shell.info(~s(export NOTION_OAUTH_TOKEN_PATH="#{save_path(opts)}"))
    end
  end

  defp print_metadata(shell, other_params) when is_map(other_params) do
    for {label, key} <- [
          {"Workspace name", "workspace_name"},
          {"Workspace id", "workspace_id"},
          {"Bot id", "bot_id"}
        ],
        value = Map.get(other_params, key),
        is_binary(value) and value != "" do
      shell.info("#{label}: #{value}")
    end
  end

  defp print_metadata(_shell, _other_params), do: :ok

  defp format_invalid_options(invalid) do
    Enum.map_join(invalid, ", ", fn {key, value} -> "#{key}=#{value}" end)
  end

  defp maybe_save_token(token, opts) do
    if save_enabled?(opts) do
      path = save_path(opts)

      case FileTokenSource.put(token, path: path, create_dirs?: true) do
        :ok ->
          Mix.shell().info("Saved token file: #{path}")

        {:error, reason} ->
          Mix.raise("failed to save oauth token to #{path}: #{format_save_error(reason)}")
      end
    end
  end

  defp save_enabled?(opts), do: Keyword.get(opts, :save, false)

  defp save_path(opts) do
    opts
    |> Keyword.get(:path, default_save_path())
    |> Path.expand()
  end

  defp default_save_path do
    OAuthTokenFile.default_path()
  end

  defp format_save_error({kind, %_{} = error}), do: "#{kind}: #{Exception.message(error)}"
  defp format_save_error({kind, reason}), do: "#{kind}: #{inspect(reason)}"
  defp format_save_error(reason), do: inspect(reason)
end
