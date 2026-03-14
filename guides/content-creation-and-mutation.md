# Content Creation and Mutation

This guide covers the write-heavy side of the SDK: creating pages, appending
blocks, mutating existing content, and choosing the right parent or position.

Before you start, read `capabilities-permissions-and-sharing.md`. Most failed
write calls come from capability or sharing gaps, not from client setup.

## Create a page

Create a page under a page or data source:

```elixir
{:ok, page} =
  NotionSDK.Pages.create(client, %{
    "parent" => %{"data_source_id" => data_source_id},
    "properties" => %{
      "Name" => %{
        "title" => [%{"text" => %{"content" => "Quarterly plan"}}]
      }
    }
  })
```

`NotionSDK.Pages.create/2` can also take:

- `children` when you want to seed the page with block content immediately
- `template` when you want Notion to apply a data-source template
- `position` when you want explicit ordering such as `page_start`, `page_end`, or `after_block`

## Move or update a page

Use `NotionSDK.Pages.update/2` for property, cover, icon, or content-reset
updates:

```elixir
{:ok, page} =
  NotionSDK.Pages.update(client, %{
    "page_id" => page_id,
    "properties" => %{
      "Status" => %{"select" => %{"name" => "In Progress"}}
    }
  })
```

Use `NotionSDK.Pages.move/2` when the page's parent must change. Use the
generated module docs for the exact `parent` payload shape emitted by your
current build.

For markdown-first workflows, `NotionSDK.Pages.update_markdown/2` is the most
direct write path:

```elixir
{:ok, page} =
  NotionSDK.Pages.update_markdown(client, %{
    "page_id" => page_id,
    "type" => "insert_content",
    "insert_content" => %{
      "content" => "# Weekly Notes\n\nUpdated from Elixir."
    }
  })
```

## Append, update, and delete blocks

Append child blocks:

```elixir
{:ok, response} =
  NotionSDK.Blocks.append_children(client, %{
    "block_id" => block_id,
    "children" => [
      %{
        "object" => "block",
        "type" => "paragraph",
        "paragraph" => %{
          "rich_text" => [%{"type" => "text", "text" => %{"content" => "Hello from Elixir"}}]
        }
      }
    ],
    "position" => %{"type" => "start"}
  })
```

The committed generated surface also supports:

- `position.type = "after_block"` with `after_block.id`
- `position.type = "end"` for block append flows

Update or delete existing blocks with `NotionSDK.Blocks.update/2` and
`NotionSDK.Blocks.delete/2`. These calls require content-update capability on
the target content.

## Create comments during a workflow

`POST /v1/comments` is useful when your mutation flow needs a human-visible
audit trail or file attachment. The current build's low-level request escape
hatch is the most direct way to send the full parent-or-discussion body shape:

```elixir
{:ok, comment} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/comments",
    body: %{
      "parent" => %{"page_id" => page_id},
      "rich_text" => [%{"text" => %{"content" => "Imported by automation"}}]
    }
  })
```

Comment capability must be enabled explicitly in Notion.

## Create or update structured containers

For container-level schema changes:

- use `NotionSDK.DataSources.create/2` and `NotionSDK.DataSources.update/2` for data-source workflows
- use `NotionSDK.Databases.create/2` and `NotionSDK.Databases.update/2` for database endpoints that are still part of the current generated surface

See `data-sources-and-databases.md` for query and template workflows around
those containers.

## Mutation checklist

- confirm the integration has insert or update content capability, depending on the call
- confirm the destination parent is shared with the integration
- use a disposable workspace or dedicated test area for mutation-heavy examples
- keep the `Notion-Version` choice explicit when you override the default header

## Related guides

- `pages-blocks-and-search.md` for read-oriented page and block traversal
- `data-sources-and-databases.md` for container metadata and queries
- `file-uploads-and-page-attachments.md` for file-backed content mutation
- `versioning-and-compatibility.md` for header overrides and generated-surface versioning
