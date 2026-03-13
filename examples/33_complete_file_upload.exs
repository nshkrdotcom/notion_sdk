Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.FileUploads

Live.banner!("33_complete_file_upload.exs")

client = Live.client!()
filename = "notion_sdk_complete_upload.txt"
contents = "notion_sdk complete upload at #{DateTime.utc_now() |> DateTime.to_iso8601()}\n"
path = Live.temp_text_file!(filename, contents)

try do
  created =
    FileUploads.create(client, %{
      "mode" => "multi_part",
      "filename" => filename,
      "content_type" => "text/plain",
      "number_of_parts" => 1
    })
    |> Live.ok!("NotionSDK.FileUploads.create/2")

  sent =
    FileUploads.send(client, %{
      "file_upload_id" => created["id"],
      "part_number" => "1",
      "file" => %{
        "filename" => filename,
        "data" => File.read!(path),
        "content_type" => "text/plain"
      }
    })
    |> Live.ok!("NotionSDK.FileUploads.send/2")

  completed =
    FileUploads.complete(client, %{"file_upload_id" => created["id"]})
    |> Live.ok!("NotionSDK.FileUploads.complete/2")

  retrieved =
    FileUploads.retrieve(client, %{"file_upload_id" => created["id"]})
    |> Live.ok!("NotionSDK.FileUploads.retrieve/2")

  Live.print_json!(
    "Completed file upload",
    %{
      "created" => Live.file_upload_summary(created),
      "sent" => Live.file_upload_summary(sent),
      "completed" => Live.file_upload_summary(completed),
      "retrieved" => Live.file_upload_summary(retrieved)
    }
  )
after
  Live.cleanup_file!(path)
end
