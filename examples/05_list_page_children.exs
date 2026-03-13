Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live

Live.banner!("05_list_page_children.exs")

client = Live.client!()
children = Live.page_children!(client)

Live.print_json!(
  "Page children",
  %{
    "page_id" => Live.page_id!(),
    "result_count" => length(children["results"] || []),
    "has_more" => children["has_more"],
    "results" => Enum.map(children["results"] || [], &Live.block_summary/1)
  }
)
