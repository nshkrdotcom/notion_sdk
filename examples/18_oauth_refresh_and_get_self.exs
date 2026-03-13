Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Users
alias Pristine.Adapters.TokenSource.File, as: FileTokenSource
alias Pristine.OAuth2
alias Pristine.OAuth2.Token

Live.banner!("18_oauth_refresh_and_get_self.exs")

path = Live.fetch_env!("NOTION_OAUTH_TOKEN_PATH")

saved_token =
  case FileTokenSource.fetch(path: path) do
    {:ok, %Token{} = token} ->
      token

    :error ->
      raise """
      #{path} does not exist
      generate it with `mix notion.oauth --save`
      """

    {:error, reason} ->
      raise "failed to load #{path}: #{inspect(reason)}"
  end

refresh_token =
  case saved_token.refresh_token do
    value when is_binary(value) and value != "" ->
      value

    _other ->
      raise """
      #{path} does not contain a refresh token
      regenerate it with `mix notion.oauth --save`
      """
  end

oauth_client = Live.oauth_client!()
credentials = Live.oauth_credentials!()

refreshed_token =
  OAuth2.refresh_token(NotionSDK.OAuth.provider(), refresh_token,
    client_id: credentials["client_id"],
    client_secret: credentials["client_secret"],
    context: oauth_client.context
  )
  |> Live.ok!("Pristine.OAuth2.refresh_token/3")

persisted_token = %Token{
  access_token: refreshed_token.access_token || raise("refresh did not return an access token"),
  refresh_token:
    case refreshed_token.refresh_token do
      value when is_binary(value) and value != "" -> value
      _other -> saved_token.refresh_token
    end,
  expires_at: refreshed_token.expires_at,
  token_type:
    case refreshed_token.token_type do
      value when is_binary(value) and value != "" -> value
      _other -> saved_token.token_type
    end,
  other_params: Map.merge(saved_token.other_params || %{}, refreshed_token.other_params || %{})
}

:ok =
  case FileTokenSource.put(persisted_token, path: path) do
    :ok -> :ok
    {:error, reason} -> raise("failed to save #{path}: #{inspect(reason)}")
  end

IO.puts("Saved refreshed token file: #{path}")

client = Live.oauth_bearer_client!()

response =
  Users.get_self(client)
  |> Live.ok!("NotionSDK.Users.get_self/1")

Live.print_json!("Refreshed token summary", %{
  "path" => path,
  "workspace_id" => Map.get(persisted_token.other_params, "workspace_id"),
  "workspace_name" => Map.get(persisted_token.other_params, "workspace_name")
})

Live.print_json!("OAuth refresh get self", response)
