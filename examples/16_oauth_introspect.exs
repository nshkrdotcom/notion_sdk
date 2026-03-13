Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.OAuth

Live.banner!("16_oauth_introspect.exs")

path = Live.oauth_token_path()

IO.puts("""
Run `mix notion.oauth --save --manual --no-browser` first if your integration
uses a registered HTTPS redirect URI, or `mix notion.oauth --save` if you have
registered a loopback redirect URI like http://127.0.0.1:40071/callback.

This example reads the saved token from:
#{path}

Set NOTION_OAUTH_ACCESS_TOKEN or NOTION_OAUTH_TOKEN_PATH only if you want to
override that default.
""")

client = Live.oauth_client!()
credentials = Live.oauth_credentials!()

response =
  OAuth.introspect(client, %{
    "client_id" => credentials["client_id"],
    "client_secret" => credentials["client_secret"],
    "token" => Live.oauth_token!()
  })
  |> Live.ok!("NotionSDK.OAuth.introspect/2")

Live.print_json!("OAuth introspection", response)
