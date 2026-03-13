Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Pagination

Live.banner!("11_collect_data_source_templates.exs")

client = Live.client!()
data_source_id = Live.data_source_id!(client)

templates =
  Pagination.collect_data_source_templates(client, %{"data_source_id" => data_source_id})
  |> Live.ok!("NotionSDK.Pagination.collect_data_source_templates/2")

Live.print_json!(
  "Collected data source templates",
  %{
    "data_source_id" => data_source_id,
    "result_count" => length(templates),
    "templates" => templates
  }
)
