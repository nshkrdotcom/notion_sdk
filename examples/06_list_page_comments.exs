Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live

Live.banner!("06_list_page_comments.exs")

client = Live.client!()
comments = Live.page_comments!(client)

Live.print_json!(
  "Page comments",
  %{
    "page_id" => Live.page_id!(),
    "result_count" => length(comments["results"] || []),
    "has_more" => comments["has_more"],
    "results" =>
      Enum.map(comments["results"] || [], fn comment ->
        %{
          "id" => comment["id"],
          "created_time" => comment["created_time"],
          "discussion_id" => comment["discussion_id"]
        }
      end)
  }
)
