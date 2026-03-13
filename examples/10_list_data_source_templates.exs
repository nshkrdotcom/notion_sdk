Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.DataSources
alias NotionSDK.Examples.Live

Live.banner!("10_list_data_source_templates.exs")

client = Live.client!()
data_source_id = Live.data_source_id!(client)

templates =
  DataSources.list_templates(client, %{
    "data_source_id" => data_source_id,
    "page_size" => Live.default_page_size()
  })
  |> Live.ok!("NotionSDK.DataSources.list_templates/2")

Live.print_json!(
  "Data source templates",
  %{
    "data_source_id" => data_source_id,
    "result_count" => length(templates["templates"] || []),
    "has_more" => templates["has_more"],
    "templates" => templates["templates"] || []
  }
)
