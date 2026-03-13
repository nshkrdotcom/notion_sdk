# File Uploads, Comments, and Users

Related guides: `file-uploads-and-page-attachments.md`, `capabilities-permissions-and-sharing.md`, `examples/README.md`.

These namespaces are smaller, but they cover important workflow edges: file ingestion, comment inspection, and workspace identity.

## File upload lifecycle

Create an upload:

```elixir
{:ok, upload} =
  NotionSDK.FileUploads.create(client, %{
    "filename" => "roadmap.pdf",
    "content_type" => "application/pdf",
    "mode" => "single_part"
  })
```

Send a file part. The SDK accepts a multipart payload in the same map shape used by the test suite:

```elixir
{:ok, uploaded_file} =
  NotionSDK.FileUploads.send(client, %{
    "file_upload_id" => upload["id"],
    "part_number" => "1",
    "file" => %{
      "filename" => "roadmap.pdf",
      "data" => File.read!("roadmap.pdf"),
      "content_type" => "application/pdf"
    }
  })
```

You can also pass an explicit file path through the lower stack with `{:path, "/tmp/roadmap.pdf"}` when that is more convenient than in-memory bytes.

For multipart uploads, create with `"mode" => "multi_part"` and `"number_of_parts" => n`, send each part, then finalize:

```elixir
{:ok, completed_upload} =
  NotionSDK.FileUploads.complete(client, %{
    "file_upload_id" => upload["id"]
  })
```

Inspect upload state later:

```elixir
{:ok, upload} =
  NotionSDK.FileUploads.retrieve(client, %{
    "file_upload_id" => upload_id
  })

{:ok, page_of_uploads} =
  NotionSDK.FileUploads.list(client, %{
    "status" => "uploaded",
    "page_size" => 50
  })
```

## Read and write comments

List comments for a block:

```elixir
{:ok, comments_page} =
  NotionSDK.Comments.list(client, %{
    "block_id" => block_id,
    "page_size" => 100
  })
```

Retrieve a single comment:

```elixir
{:ok, comment} =
  NotionSDK.Comments.retrieve(client, %{
    "comment_id" => comment_id
  })
```

For comment-creation flows that need the full parent-or-discussion body shape,
use `NotionSDK.Client.request/2` with `method: :post` and `path: "/v1/comments"`.

## Inspect workspace users

Get the bot user behind the current token:

```elixir
{:ok, me} = NotionSDK.Users.get_self(client)
```

List workspace users:

```elixir
{:ok, users_page} =
  NotionSDK.Users.list(client, %{
    "page_size" => 100
  })
```

Fetch one user by ID:

```elixir
{:ok, user} =
  NotionSDK.Users.retrieve(client, %{
    "user_id" => user_id
  })
```

The live examples for these workflows use `NOTION_EXAMPLE_*` fixture env vars. Those fixture ids belong to the example harness, not to `NotionSDK.Client.new/1`.
