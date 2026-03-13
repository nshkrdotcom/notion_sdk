Code.require_file("../support/live_example.exs", __DIR__)

alias NotionSDK.DataSources
alias NotionSDK.Databases
alias NotionSDK.Examples.Live
alias NotionSDK.Pages
alias NotionSDK.Search

Live.banner!("cookbook/04_search_paginate_and_branch.exs")

IO.puts(
  "Searches the shared workspace, demonstrates pagination cursors, then branches to a follow-up retrieve based on the first result type."
)

client = Live.client!()

search =
  Search.search(client, %{
    "query" => Live.get_env("NOTION_EXAMPLE_SEARCH_QUERY") || "",
    "page_size" => 5
  })
  |> Live.ok!("NotionSDK.Search.search/2")

results = search["results"] || []

follow_up =
  case List.first(results) do
    %{"object" => "page", "id" => id} ->
      page = Pages.retrieve(client, %{"page_id" => id}) |> Live.ok!("NotionSDK.Pages.retrieve/2")
      %{"type" => "page", "summary" => Live.page_summary(page)}

    %{"object" => "data_source", "id" => id} ->
      data_source =
        DataSources.retrieve(client, %{"data_source_id" => id})
        |> Live.ok!("NotionSDK.DataSources.retrieve/2")

      %{"type" => "data_source", "summary" => Live.data_source_summary(data_source)}

    %{"object" => "database", "id" => id} ->
      database =
        Databases.retrieve(client, %{"database_id" => id})
        |> Live.ok!("NotionSDK.Databases.retrieve/2")

      %{"type" => "database", "summary" => Live.database_summary(database)}

    nil ->
      %{"type" => "none", "summary" => nil}

    other ->
      %{"type" => other["object"], "summary" => %{"id" => other["id"], "url" => other["url"]}}
  end

next_page =
  case search["next_cursor"] do
    cursor when is_binary(cursor) and cursor != "" ->
      Search.search(client, %{
        "query" => Live.get_env("NOTION_EXAMPLE_SEARCH_QUERY") || "",
        "page_size" => 5,
        "start_cursor" => cursor
      })
      |> Live.ok!("NotionSDK.Search.search/2")

    _ ->
      nil
  end

Live.print_json!(
  "Workflow result",
  %{
    "first_page_result_count" => length(results),
    "has_more" => search["has_more"],
    "next_cursor" => search["next_cursor"],
    "follow_up" => follow_up,
    "second_page_result_count" => if(next_page, do: length(next_page["results"] || []), else: 0)
  }
)
