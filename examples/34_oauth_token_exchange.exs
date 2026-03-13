Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.OAuth

Live.banner!("34_oauth_token_exchange.exs")

client = Live.oauth_client!()
credentials = Live.oauth_credentials!()

response =
  OAuth.token(client, %{
    "client_id" => credentials["client_id"],
    "client_secret" => credentials["client_secret"],
    "grant_type" => "authorization_code",
    "code" => Live.oauth_auth_code_or_prompt!(),
    "redirect_uri" => Live.fetch_env!("NOTION_OAUTH_REDIRECT_URI")
  })
  |> Live.ok!("NotionSDK.OAuth.token/2")

path = Live.save_oauth_exchange_token!(response)

Live.print_json!(
  "OAuth token exchange",
  %{
    "bot_id" => response["bot_id"],
    "workspace_id" => response["workspace_id"],
    "workspace_name" => response["workspace_name"],
    "request_id" => response["request_id"],
    "token_type" => response["token_type"],
    "has_refresh_token" =>
      is_binary(response["refresh_token"]) and response["refresh_token"] != "",
    "saved_token_path" => path
  }
)
