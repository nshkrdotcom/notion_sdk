Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.DataSources
alias NotionSDK.Examples.Live

Live.banner!("08_retrieve_data_source.exs")

client = Live.client!()
data_source_id = Live.data_source_id!(client)

data_source =
  DataSources.retrieve(client, %{"data_source_id" => data_source_id})
  |> Live.ok!("NotionSDK.DataSources.retrieve/2")

Live.print_json!(
  "Data source",
  %{
    "data_source_id" => data_source_id,
    "data_source" => Live.data_source_summary(data_source)
  }
)
