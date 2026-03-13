Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Databases
alias NotionSDK.Examples.Live

Live.banner!("29_create_database.exs")

client = Live.client!()
title = Live.unique_name("notion_sdk create database")

database =
  Databases.create(client, %{
    "parent" => %{
      "type" => "page_id",
      "page_id" => Live.page_id!()
    },
    "title" => Live.rich_text(title)
  })
  |> Live.ok!("NotionSDK.Databases.create/2")

try do
  Live.print_json!(
    "Created database",
    %{
      "title" => title,
      "database" => Live.database_summary(database)
    }
  )
after
  Live.trash_database!(client, database["id"])
end
