Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("03_retrieve_page_markdown.exs")

client = Live.client!()

markdown =
  Pages.retrieve_markdown(client, %{"page_id" => Live.page_id!()})
  |> Live.ok!("NotionSDK.Pages.retrieve_markdown/2")

Live.print_json!(
  "Page markdown",
  %{
    "id" => markdown["id"],
    "object" => markdown["object"],
    "truncated" => markdown["truncated"],
    "unknown_block_ids" => markdown["unknown_block_ids"],
    "markdown_preview" => Live.markdown_preview(markdown["markdown"] || "")
  }
)
