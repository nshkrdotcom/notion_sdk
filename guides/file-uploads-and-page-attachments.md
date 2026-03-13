# File Uploads and Page Attachments

This guide focuses on the workflow layer around files:

1. create an upload
2. send the file bytes or register an external URL
3. complete the upload when required
4. attach the uploaded file to page content, covers, icons, or comments

The namespace reference guide in `file-uploads-comments-and-users.md` covers the
individual endpoint wrappers. This guide focuses on how they fit together.

## Single-part upload flow

Create the upload record:

```elixir
{:ok, upload} =
  NotionSDK.FileUploads.create(client, %{
    "filename" => "roadmap.pdf",
    "content_type" => "application/pdf",
    "mode" => "single_part"
  })
```

Send the bytes:

```elixir
{:ok, uploaded} =
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

Retrieve the upload later with `NotionSDK.FileUploads.retrieve/2` or list recent
uploads with `NotionSDK.FileUploads.list/2`.

## Multi-part upload flow

For larger files:

- create with `"mode" => "multi_part"` and `"number_of_parts" => n`
- call `NotionSDK.FileUploads.send/2` for each part
- finalize with `NotionSDK.FileUploads.complete/2`

```elixir
{:ok, completed} =
  NotionSDK.FileUploads.complete(client, %{
    "file_upload_id" => upload["id"]
  })
```

Only completed uploads are useful as downstream attachments.

## External URL import flow

If the source file already lives at a stable HTTPS URL, you can create an
external upload instead of sending bytes yourself. The existing live examples
show that path in `examples/13_create_external_file_upload.exs`.

## Attach an uploaded file to a page cover

Once a file upload is in the `uploaded` state, you can reference it from a page
cover update:

```elixir
{:ok, page} =
  NotionSDK.Pages.update(client, %{
    "page_id" => page_id,
    "cover" => %{
      "type" => "file_upload",
      "file_upload" => %{"id" => upload["id"]}
    }
  })
```

The generated surface also exposes file-upload request shapes for page icons.

## Attach an uploaded file to page content or comments

The committed generated schemas also include file-upload-backed attachment
shapes that can be used in content or comment workflows.

Common patterns:

- file-backed page cover or icon updates through `NotionSDK.Pages.update/2`
- file-backed content blocks through page/block mutation flows
- comment attachments via `POST /v1/comments`

Example comment attachment shape:

```elixir
{:ok, comment} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/comments",
    body: %{
      "parent" => %{"page_id" => page_id},
      "rich_text" => [%{"text" => %{"content" => "See attached export"}}],
      "attachments" => [
        %{"type" => "file_upload", "file_upload_id" => upload["id"]}
      ]
    }
  })
```

## Operational advice

- keep file uploads and destination-page sharing in the same disposable workspace while testing
- complete multi-part uploads before reusing the returned id in another endpoint
- treat the generated endpoint docs as the source of truth for exact request shapes when attaching files to more specialized block types

## Related guides

- `file-uploads-comments-and-users.md` for the namespace walkthroughs
- `content-creation-and-mutation.md` for block and page write flows
- `examples/README.md` for the existing live upload proofs
