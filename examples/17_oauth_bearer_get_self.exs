Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Users

Live.banner!("17_oauth_bearer_get_self.exs")

path = Live.oauth_token_path()

IO.puts("""
Run `mix notion.oauth --save --manual --no-browser` first if your integration
uses a registered HTTPS redirect URI, or `mix notion.oauth --save` if you have
registered a loopback redirect URI like http://127.0.0.1:40071/callback.

This example reads the saved token from:
#{path}

Set NOTION_OAUTH_TOKEN_PATH only if you want to override that default.
""")

client = Live.oauth_bearer_client!()

response =
  Users.get_self(client)
  |> Live.ok!("NotionSDK.Users.get_self/1")

Live.print_json!("OAuth bearer get self", response)
