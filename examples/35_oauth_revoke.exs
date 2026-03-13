Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.OAuth

Live.banner!("35_oauth_revoke.exs")

client = Live.oauth_client!()
credentials = Live.oauth_credentials!()

token_source =
  case Live.get_env("NOTION_OAUTH_REVOKE_TOKEN") do
    value when is_binary(value) and value != "" -> "NOTION_OAUTH_REVOKE_TOKEN"
    _ -> Live.oauth_exchange_token_path()
  end

response =
  OAuth.revoke(client, %{
    "client_id" => credentials["client_id"],
    "client_secret" => credentials["client_secret"],
    "token" => Live.oauth_revoke_token!()
  })
  |> Live.ok!("NotionSDK.OAuth.revoke/2")

Live.cleanup_oauth_exchange_token_file!()

Live.print_json!(
  "OAuth revoke",
  %{
    "request_id" => response["request_id"],
    "token_source" => token_source
  }
)
