Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Blocks
alias NotionSDK.Examples.Live

Live.banner!("04_retrieve_first_child_block.exs")

client = Live.client!()
block_id = Live.block_id!(client)

block =
  Blocks.retrieve(client, %{"block_id" => block_id})
  |> Live.ok!("NotionSDK.Blocks.retrieve/2")

Live.print_json!(
  "Block",
  %{
    "block_id" => block_id,
    "block" => Live.block_summary(block)
  }
)
