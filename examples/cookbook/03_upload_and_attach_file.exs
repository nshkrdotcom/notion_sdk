Code.require_file("../support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.FileUploads
alias NotionSDK.Pages

Live.banner!("cookbook/03_upload_and_attach_file.exs")

IO.puts(
  "Creates a temporary page, uploads a small file with the single-part flow, attaches it to a page comment, then trashes the page."
)

client = Live.client!()
filename = "cookbook_upload.txt"
contents = "cookbook upload at #{DateTime.utc_now() |> DateTime.to_iso8601()}\n"
path = Live.temp_text_file!(filename, contents)

try do
  page =
    Pages.create(client, %{
      "parent" => %{"page_id" => Live.page_id!()},
      "properties" => Live.page_title_properties(Live.unique_name("cookbook upload page"))
    })
    |> Live.ok!("NotionSDK.Pages.create/2")

  try do
    upload =
      FileUploads.create(client, %{
        "mode" => "single_part",
        "filename" => filename,
        "content_type" => "text/plain"
      })
      |> Live.ok!("NotionSDK.FileUploads.create/2")

    FileUploads.send(client, %{
      "file_upload_id" => upload["id"],
      "file" => %{
        "filename" => filename,
        "data" => File.read!(path),
        "content_type" => "text/plain"
      }
    })
    |> Live.ok!("NotionSDK.FileUploads.send/2")

    uploaded =
      FileUploads.retrieve(client, %{"file_upload_id" => upload["id"]})
      |> Live.ok!("NotionSDK.FileUploads.retrieve/2")

    comment =
      Live.create_comment!(client, %{
        "parent" => %{"page_id" => page["id"]},
        "rich_text" => Live.rich_text("Attached from cookbook/03_upload_and_attach_file.exs"),
        "attachments" => [
          %{"type" => "file_upload", "file_upload_id" => uploaded["id"]}
        ]
      })

    Live.print_json!(
      "Workflow result",
      %{
        "page" => Live.page_summary(page),
        "upload" => Live.file_upload_summary(uploaded),
        "comment" => Live.comment_summary(comment)
      }
    )
  after
    Live.trash_page!(client, page["id"])
  end
after
  Live.cleanup_file!(path)
end
