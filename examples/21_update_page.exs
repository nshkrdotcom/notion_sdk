Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("21_update_page.exs")

client = Live.client!()
title = Live.unique_name("notion_sdk update page")

created =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(title)
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  updated =
    Pages.update(client, %{
      "page_id" => created["id"],
      "is_locked" => true
    })
    |> Live.ok!("NotionSDK.Pages.update/2")

  Live.print_json!(
    "Updated page",
    %{
      "created" => Live.page_summary(created),
      "updated" => %{
        "id" => updated["id"],
        "is_locked" => updated["is_locked"],
        "in_trash" => updated["in_trash"],
        "url" => updated["url"]
      }
    }
  )
after
  Live.trash_page!(client, created["id"])
end
