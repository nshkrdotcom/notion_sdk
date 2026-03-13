Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.DataSources
alias NotionSDK.Examples.Live

Live.banner!("09_query_data_source.exs")

client = Live.client!()
data_source_id = Live.data_source_id!(client)

query_result =
  DataSources.query(client, %{
    "data_source_id" => data_source_id,
    "page_size" => Live.default_page_size()
  })
  |> Live.ok!("NotionSDK.DataSources.query/2")

Live.print_json!(
  "Data source query",
  %{
    "data_source_id" => data_source_id,
    "result_count" => length(query_result["results"] || []),
    "has_more" => query_result["has_more"],
    "results" => Live.search_results_summary(query_result["results"] || [])
  }
)
