Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live

Live.banner!("00_smoke.exs")

client = Live.client!()
smoke = Live.smoke!(client)

Live.print_json!("Bot user", Live.user_summary(smoke.self))

Live.print_json!(
  "Search summary",
  %{
    "result_count" => length(smoke.search["results"] || []),
    "has_more" => smoke.search["has_more"],
    "results" => Live.search_results_summary(smoke.search["results"] || [])
  }
)

Live.print_list_summary!("Workspace users", smoke.users["results"] || [], &Live.user_summary/1)
