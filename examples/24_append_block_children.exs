Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Blocks
alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("24_append_block_children.exs")

client = Live.client!()

page =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(Live.unique_name("notion_sdk append blocks"))
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  appended =
    Blocks.append_children(client, %{
      "block_id" => page["id"],
      "children" => [Live.paragraph_block("Appended from 24_append_block_children.exs")],
      "position" => %{"type" => "end"}
    })
    |> Live.ok!("NotionSDK.Blocks.append_children/2")

  results = appended["results"] || []

  Live.print_json!(
    "Appended child blocks",
    %{
      "page" => Live.page_summary(page),
      "result_count" => length(results),
      "results" => Enum.map(results, &Live.block_summary/1)
    }
  )
after
  Live.trash_page!(client, page["id"])
end
