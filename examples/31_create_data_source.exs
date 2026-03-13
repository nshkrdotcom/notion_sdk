Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.DataSources
alias NotionSDK.Databases
alias NotionSDK.Examples.Live

Live.banner!("31_create_data_source.exs")

client = Live.client!()

database =
  Databases.create(client, %{
    "parent" => %{
      "type" => "page_id",
      "page_id" => Live.page_id!()
    },
    "title" => Live.rich_text(Live.unique_name("notion_sdk data source database"))
  })
  |> Live.ok!("NotionSDK.Databases.create/2")

try do
  data_source =
    DataSources.create(client, %{
      "parent" => %{"database_id" => database["id"]},
      "title" => Live.rich_text(Live.unique_name("notion_sdk create data source")),
      "properties" => Live.basic_data_source_properties()
    })
    |> Live.ok!("NotionSDK.DataSources.create/2")

  try do
    Live.print_json!(
      "Created data source",
      %{
        "database" => Live.database_summary(database),
        "data_source" => Live.data_source_summary(data_source)
      }
    )
  after
    Live.trash_data_source!(client, data_source["id"])
  end
after
  Live.trash_database!(client, database["id"])
end
