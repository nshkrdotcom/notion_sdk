Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Databases
alias NotionSDK.Examples.Live

Live.banner!("30_update_database.exs")

client = Live.client!()

database =
  Databases.create(client, %{
    "parent" => %{
      "type" => "page_id",
      "page_id" => Live.page_id!()
    },
    "title" => Live.rich_text(Live.unique_name("notion_sdk database before update"))
  })
  |> Live.ok!("NotionSDK.Databases.create/2")

try do
  updated_title = Live.unique_name("notion_sdk database after update")

  updated =
    Databases.update(client, %{
      "database_id" => database["id"],
      "title" => Live.rich_text(updated_title)
    })
    |> Live.ok!("NotionSDK.Databases.update/2")

  Live.print_json!(
    "Updated database",
    %{
      "before" => Live.database_summary(database),
      "after" => Live.database_summary(updated)
    }
  )
after
  Live.trash_database!(client, database["id"])
end
