Code.require_file("../support/live_example.exs", __DIR__)

alias NotionSDK.DataSources
alias NotionSDK.Databases
alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("cookbook/02_create_and_query_data_source.exs")

IO.puts(
  "Creates a temporary database and data source, inserts a row, queries it, then trashes the temporary containers."
)

client = Live.client!()

database =
  Databases.create(client, %{
    "parent" => %{
      "type" => "page_id",
      "page_id" => Live.page_id!()
    },
    "title" => Live.rich_text(Live.unique_name("cookbook database"))
  })
  |> Live.ok!("NotionSDK.Databases.create/2")

try do
  data_source =
    DataSources.create(client, %{
      "parent" => %{"database_id" => database["id"]},
      "title" => Live.rich_text(Live.unique_name("cookbook data source")),
      "properties" => Live.basic_data_source_properties()
    })
    |> Live.ok!("NotionSDK.DataSources.create/2")

  try do
    row =
      Pages.create(client, %{
        "parent" => %{"data_source_id" => data_source["id"]},
        "properties" => %{
          "Name" => Live.title_property(Live.unique_name("cookbook row"))
        }
      })
      |> Live.ok!("NotionSDK.Pages.create/2")

    try do
      query =
        DataSources.query(client, %{
          "data_source_id" => data_source["id"],
          "page_size" => 10
        })
        |> Live.ok!("NotionSDK.DataSources.query/2")

      Live.print_json!(
        "Workflow result",
        %{
          "database" => Live.database_summary(database),
          "data_source" => Live.data_source_summary(data_source),
          "row" => Live.page_summary(row),
          "query_result_count" => length(query["results"] || [])
        }
      )
    after
      Live.trash_page!(client, row["id"])
    end
  after
    Live.trash_data_source!(client, data_source["id"])
  end
after
  Live.trash_database!(client, database["id"])
end
