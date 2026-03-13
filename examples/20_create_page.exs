Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Pages

Live.banner!("20_create_page.exs")

client = Live.client!()
title = Live.unique_name("notion_sdk create page")

created =
  Pages.create(client, %{
    "parent" => %{"page_id" => Live.page_id!()},
    "properties" => Live.page_title_properties(title)
  })
  |> Live.ok!("NotionSDK.Pages.create/2")

try do
  Live.print_json!(
    "Created page",
    %{
      "title" => title,
      "page" => Live.page_summary(created)
    }
  )
after
  Live.trash_page!(client, created["id"])
end
