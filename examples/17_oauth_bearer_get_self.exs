Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Users

Live.banner!("17_oauth_bearer_get_self.exs")

IO.puts("""
Run `mix notion.oauth --save` first, then export NOTION_OAUTH_TOKEN_PATH
before running this example.
""")

client = Live.oauth_bearer_client!()

response =
  Users.get_self(client)
  |> Live.ok!("NotionSDK.Users.get_self/1")

Live.print_json!("OAuth bearer get self", response)
