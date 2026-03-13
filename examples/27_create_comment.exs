Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("27_create_comment.exs")

client = Live.client!()

page =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(Live.unique_name("notion_sdk comment page"))
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  comment =
    Live.create_comment!(client, %{
      "parent" => %{"page_id" => page["id"]},
      "rich_text" => Live.rich_text("Created from 27_create_comment.exs")
    })

  Live.print_json!(
    "Created comment",
    %{
      "page" => Live.page_summary(page),
      "comment" => Live.comment_summary(comment)
    }
  )
after
  Live.trash_page!(client, page["id"])
end
