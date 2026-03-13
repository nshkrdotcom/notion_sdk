Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("22_move_page.exs")

client = Live.client!()

destination =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(Live.unique_name("notion_sdk move destination"))
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  movable =
    Pages.create(client, %{
      "parent" => %{"page_id" => Live.page_id!()},
      "properties" => Live.page_title_properties(Live.unique_name("notion_sdk move source"))
    })
    |> Live.ok!("NotionSDK.Pages.create/2")

  try do
    moved =
      Pages.move(client, %{
        "page_id" => movable["id"],
        "parent" => %{"page_id" => destination["id"]}
      })
      |> Live.ok!("NotionSDK.Pages.move/2")

    Live.print_json!(
      "Moved page",
      %{
        "destination" => Live.page_summary(destination),
        "moved" => %{
          "id" => moved["id"],
          "parent" => moved["parent"],
          "url" => moved["url"]
        }
      }
    )
  after
    Live.trash_page!(client, movable["id"])
  end
after
  Live.trash_page!(client, destination["id"])
end
