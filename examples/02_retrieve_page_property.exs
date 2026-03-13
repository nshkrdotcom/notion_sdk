Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("02_retrieve_page_property.exs")

client = Live.client!()
page_property = Live.page_property!(client)

property_item =
  Pages.retrieve_property(client, %{
    "page_id" => Live.page_id!(),
    "property_id" => page_property.id
  })
  |> Live.ok!("NotionSDK.Pages.retrieve_property/2")

Live.print_json!(
  "Selected page property",
  %{
    "property_name" => page_property.name,
    "property_id" => page_property.id,
    "item" => property_item
  }
)
