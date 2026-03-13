Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("23_update_page_markdown.exs")

client = Live.client!()

page =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(Live.unique_name("notion_sdk markdown page"))
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  markdown =
    Pages.update_markdown(client, %{
      "page_id" => page["id"],
      "type" => "insert_content",
      "insert_content" => %{
        "content" => "## Example Section\n\nUpdated via notion_sdk."
      }
    })
    |> Live.ok!("NotionSDK.Pages.update_markdown/2")

  Live.print_json!(
    "Updated page markdown",
    %{
      "page_id" => page["id"],
      "truncated" => markdown["truncated"],
      "unknown_block_ids" => markdown["unknown_block_ids"],
      "markdown_preview" => Live.markdown_preview(markdown["markdown"] || "")
    }
  )
after
  Live.trash_page!(client, page["id"])
end
