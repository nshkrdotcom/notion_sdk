Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Databases
alias NotionSDK.Examples.Live

Live.banner!("07_retrieve_database.exs")

client = Live.client!()
database_id = Live.database_id!(client)

database =
  Databases.retrieve(client, %{"database_id" => database_id})
  |> Live.ok!("NotionSDK.Databases.retrieve/2")

Live.print_json!(
  "Database",
  %{
    "database_id" => database_id,
    "database" => Live.database_summary(database)
  }
)
