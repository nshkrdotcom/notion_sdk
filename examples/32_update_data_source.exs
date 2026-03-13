Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.DataSources
alias NotionSDK.Databases
alias NotionSDK.Examples.Live

Live.banner!("32_update_data_source.exs")

client = Live.client!()

database =
  Databases.create(client, %{
    "parent" => %{
      "type" => "page_id",
      "page_id" => Live.page_id!()
    },
    "title" => Live.rich_text(Live.unique_name("notion_sdk update data source database"))
  })
  |> Live.ok!("NotionSDK.Databases.create/2")

try do
  data_source =
    DataSources.create(client, %{
      "parent" => %{"database_id" => database["id"]},
      "title" => Live.rich_text(Live.unique_name("notion_sdk data source before update")),
      "properties" => Live.basic_data_source_properties()
    })
    |> Live.ok!("NotionSDK.DataSources.create/2")

  try do
    updated =
      DataSources.update(client, %{
        "data_source_id" => data_source["id"],
        "title" => Live.rich_text(Live.unique_name("notion_sdk data source after update"))
      })
      |> Live.ok!("NotionSDK.DataSources.update/2")

    Live.print_json!(
      "Updated data source",
      %{
        "before" => Live.data_source_summary(data_source),
        "after" => Live.data_source_summary(updated)
      }
    )
  after
    Live.trash_data_source!(client, data_source["id"])
  end
after
  Live.trash_database!(client, database["id"])
end
