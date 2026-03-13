Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.FileUploads

Live.banner!("13_create_external_file_upload.exs")

client = Live.client!()
external_url = Live.fetch_https_env!("NOTION_EXAMPLE_FILE_URL")

filename =
  Live.get_env("NOTION_EXAMPLE_FILE_FILENAME") ||
    Live.infer_filename_from_url!(external_url)

params =
  %{
    "mode" => "external_url",
    "external_url" => external_url,
    "filename" => filename
  }
  |> Live.put_if_present("content_type", Live.get_env("NOTION_EXAMPLE_FILE_CONTENT_TYPE"))

created =
  FileUploads.create(client, params)
  |> Live.ok!("NotionSDK.FileUploads.create/2")

retrieved =
  FileUploads.retrieve(client, %{"file_upload_id" => created["id"]})
  |> Live.ok!("NotionSDK.FileUploads.retrieve/2")

Live.print_json!(
  "Created external file upload",
  %{
    "request" => params,
    "created" => Live.file_upload_summary(created),
    "retrieved" => Live.file_upload_summary(retrieved)
  }
)
