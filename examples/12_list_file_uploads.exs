Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.FileUploads

Live.banner!("12_list_file_uploads.exs")

client = Live.client!()

uploads =
  FileUploads.list(client, %{"page_size" => Live.default_page_size()})
  |> Live.ok!("NotionSDK.FileUploads.list/2")

Live.print_json!(
  "File uploads",
  %{
    "result_count" => length(uploads["results"] || []),
    "has_more" => uploads["has_more"],
    "results" => Enum.map(uploads["results"] || [], &Live.file_upload_summary/1)
  }
)
