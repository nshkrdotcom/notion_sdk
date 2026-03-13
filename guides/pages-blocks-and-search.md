# Pages, Blocks, and Search

Most integrations spend their time in three modules:

- `NotionSDK.Pages` for page metadata and markdown endpoints
- `NotionSDK.Blocks` for content tree traversal and mutation
- `NotionSDK.Search` for cross-workspace discovery

## Retrieve and update pages

Read a page:

```elixir
{:ok, page} =
  NotionSDK.Pages.retrieve(client, %{
    "page_id" => page_id
  })
```

Update page-level flags or properties:

```elixir
{:ok, updated_page} =
  NotionSDK.Pages.update(client, %{
    "page_id" => page_id,
    "is_locked" => true,
    "in_trash" => false,
    "properties" => updated_properties
  })
```

Create a page under a data source:

```elixir
{:ok, created_page} =
  NotionSDK.Pages.create(client, %{
    "parent" => %{"data_source_id" => data_source_id},
    "properties" => properties,
    "children" => children
  })
```

The `properties` payload is schema-dependent. In practice you usually reuse the JSON shape from Notion's API reference or from a previously retrieved page or data source schema.

## Work with page properties

When you need a single property item, use `retrieve_property/2`:

```elixir
{:ok, property_item} =
  NotionSDK.Pages.retrieve_property(client, %{
    "page_id" => page_id,
    "property_id" => property_id,
    "page_size" => 100
  })
```

This is the endpoint to use for paginated property values such as relations, people, and rich text arrays.

## Use the markdown endpoints

The SDK includes Notion's markdown read and write endpoints:

```elixir
{:ok, markdown_page} =
  NotionSDK.Pages.retrieve_markdown(client, %{
    "page_id" => page_id,
    "include_transcript" => true
  })
```

Insert content with the same request shape used in the parity tests:

```elixir
{:ok, markdown_result} =
  NotionSDK.Pages.update_markdown(client, %{
    "page_id" => page_id,
    "type" => "insert_content",
    "insert_content" => %{
      "content" => "## New Section",
      "after" => "# Heading...end text"
    }
  })
```

`update_markdown/2` also accepts `replace_content_range` bodies. Use the generated API reference as the exact source of truth for the supported top-level keys.

## Traverse block trees

Read a block and then list its children:

```elixir
{:ok, block} =
  NotionSDK.Blocks.retrieve(client, %{
    "block_id" => block_id
  })

{:ok, children_page} =
  NotionSDK.Blocks.list_children(client, %{
    "block_id" => block_id,
    "page_size" => 100
  })
```

Append children to a block:

```elixir
{:ok, append_result} =
  NotionSDK.Blocks.append_children(client, %{
    "block_id" => block_id,
    "children" => [
      %{
        "object" => "block",
        "type" => "bulleted_list_item",
        "bulleted_list_item" => %{
          "rich_text" => [
            %{
              "type" => "text",
              "text" => %{"content" => "Ship HexDocs"}
            }
          ]
        }
      }
    ]
  })
```

Archive a block with `update/2` or delete it with `delete/2`:

```elixir
NotionSDK.Blocks.update(client, %{
  "block_id" => block_id,
  "in_trash" => true
})
```

## Search across the workspace

Search is the fastest way to discover pages or data sources before you know their exact IDs:

```elixir
{:ok, result} =
  NotionSDK.Search.search(client, %{
    "query" => "Engineering Roadmap",
    "page_size" => 20
  })
```

The response contains a mixed `results` list. Pair it with `NotionSDK.Guards.full_page?/1` or `NotionSDK.Guards.full_data_source?/1` when you need to branch on the returned object type.
