Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live

Live.banner!("01_retrieve_page.exs")

client = Live.client!()
page = Live.retrieve_page!(client)

Live.print_json!("Page", Live.page_summary(page))
