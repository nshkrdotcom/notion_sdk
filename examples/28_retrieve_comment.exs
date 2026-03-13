Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Comments
alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("28_retrieve_comment.exs")

client = Live.client!()

page =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" =>
      Live.page_title_properties(Live.unique_name("notion_sdk retrieve comment page"))
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  created =
    Live.create_comment!(client, %{
      "parent" => %{"page_id" => page["id"]},
      "rich_text" => Live.rich_text("Created from 28_retrieve_comment.exs")
    })

  retrieved =
    Comments.retrieve(client, %{"comment_id" => created["id"]})
    |> Live.ok!("NotionSDK.Comments.retrieve/2")

  Live.print_json!(
    "Retrieved comment",
    %{
      "created" => Live.comment_summary(created),
      "retrieved" => Live.comment_summary(retrieved)
    }
  )
after
  Live.trash_page!(client, page["id"])
end
