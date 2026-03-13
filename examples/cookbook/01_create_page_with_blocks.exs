Code.require_file("../support/live_example.exs", __DIR__)

alias NotionSDK.Blocks
alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("cookbook/01_create_page_with_blocks.exs")

IO.puts(
  "Creates a temporary child page, seeds it with blocks, appends more content, then trashes the page."
)

client = Live.client!()

page =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(Live.unique_name("cookbook page with blocks")),
    "children" => [
      Live.heading_2_block("Overview"),
      Live.paragraph_block("This page was created by the cookbook example.")
    ]
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  appended =
    Blocks.append_children(client, %{
      "block_id" => page["id"],
      "children" => [Live.paragraph_block("Appended after the initial create call.")],
      "position" => %{"type" => "end"}
    })
    |> Live.ok!("NotionSDK.Blocks.append_children/2")

  markdown =
    Pages.retrieve_markdown(client, %{"page_id" => page["id"]})
    |> Live.ok!("NotionSDK.Pages.retrieve_markdown/2")

  Live.print_json!(
    "Workflow result",
    %{
      "page" => Live.page_summary(page),
      "appended_blocks" => Enum.map(appended["results"] || [], &Live.block_summary/1),
      "markdown_preview" => Live.markdown_preview(markdown["markdown"] || "")
    }
  )
after
  Live.trash_page!(client, page["id"])
end
