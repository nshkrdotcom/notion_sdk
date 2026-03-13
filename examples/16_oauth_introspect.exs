Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.OAuth

Live.banner!("16_oauth_introspect.exs")

IO.puts("""
Run `mix notion.oauth --save` first, then export NOTION_OAUTH_TOKEN_PATH
or NOTION_OAUTH_ACCESS_TOKEN before running this example.
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
