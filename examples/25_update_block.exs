Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Blocks
alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("25_update_block.exs")

client = Live.client!()

page =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(Live.unique_name("notion_sdk update block")),
    "children" => [Live.paragraph_block("Initial paragraph text")]
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  block = Live.first_child_block!(client, page["id"])

  updated =
    Blocks.update(client, %{
      "block_id" => block["id"],
      "type" => "paragraph",
      "paragraph" => %{
        "rich_text" => Live.rich_text("Updated paragraph text")
      }
    })
    |> Live.ok!("NotionSDK.Blocks.update/2")

  Live.print_json!(
    "Updated block",
    %{
      "before" => %{
        "id" => block["id"],
        "type" => block["type"],
        "plain_text" => Live.plain_text(get_in(block, ["paragraph", "rich_text"]) || [])
      },
      "after" => %{
        "id" => updated["id"],
        "type" => updated["type"],
        "plain_text" => Live.plain_text(get_in(updated, ["paragraph", "rich_text"]) || [])
      }
    }
  )
after
  Live.trash_page!(client, page["id"])
end
