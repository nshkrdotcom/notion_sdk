Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.FileUploads

Live.banner!("14_retrieve_file_upload.exs")

client = Live.client!()
file_upload_id = Live.file_upload_id!(client)

file_upload =
  FileUploads.retrieve(client, %{"file_upload_id" => file_upload_id})
  |> Live.ok!("NotionSDK.FileUploads.retrieve/2")

Live.print_json!(
  "File upload",
  %{
    "file_upload_id" => file_upload_id,
    "file_upload" => Live.file_upload_summary(file_upload)
  }
)
