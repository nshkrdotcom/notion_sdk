Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Blocks
alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("26_delete_block.exs")

client = Live.client!()

page =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(Live.unique_name("notion_sdk delete block")),
    "children" => [Live.paragraph_block("Delete me")]
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  block = Live.first_child_block!(client, page["id"])

  deleted =
    Blocks.delete(client, %{"block_id" => block["id"]})
    |> Live.ok!("NotionSDK.Blocks.delete/2")

  Live.print_json!(
    "Deleted block",
    %{
      "before" => Live.block_summary(block),
      "after" => %{
        "id" => deleted["id"],
        "type" => deleted["type"],
        "archived" => deleted["archived"],
        "in_trash" => deleted["in_trash"]
      }
    }
  )
after
  Live.trash_page!(client, page["id"])
end
