Code.require_file("../support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.OAuth
alias NotionSDK.Users

Live.banner!("cookbook/05_oauth_onboard_and_call_api.exs")

IO.puts(
  "Builds the authorization URL your app would present to the user, then uses the saved OAuth token file to call the API."
)

client_id = Live.fetch_env!("NOTION_OAUTH_CLIENT_ID")
redirect_uri = Live.fetch_env!("NOTION_OAUTH_REDIRECT_URI")

authorize_url =
  OAuth.authorize_url(client_id: client_id, redirect_uri: redirect_uri)
  |> Live.ok!("NotionSDK.OAuth.authorize_url/1")

bearer_client = Live.oauth_bearer_client!()
me = Users.get_self(bearer_client) |> Live.ok!("NotionSDK.Users.get_self/1")

Live.print_json!(
  "Workflow result",
  %{
    "authorize_url" => authorize_url,
    "saved_token_path" => Live.oauth_token_path(),
    "bot_user" => Live.user_summary(me)
  }
)
