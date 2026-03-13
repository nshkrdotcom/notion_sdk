# Pagination, Helpers, and Guards

Notion list endpoints are cursor-based. `NotionSDK.Pagination` gives you two styles of wrapper:

- eager collection with `collect_*`
- lazy streaming with `iterate_*`

`NotionSDK.Helpers` and `NotionSDK.Guards` cover the most common ID-normalization and object-shape checks.

## Paginate generic list endpoints

Use `collect_paginated_api/3` when you want the whole result list as a single `{:ok, results}` tuple:

```elixir
{:ok, users} =
  NotionSDK.Pagination.collect_paginated_api(
    &NotionSDK.Users.list/2,
    client,
    %{"page_size" => 100}
  )
```

Use `iterate_paginated_api/3` when you want a stream:

```elixir
stream =
  NotionSDK.Pagination.iterate_paginated_api(
    &NotionSDK.Users.list/2,
    client,
    %{"page_size" => 100}
  )

Enum.each(stream, &IO.inspect/1)
```

The generic helpers expect the target function to return:

- `{:ok, %{"results" => results, "has_more" => boolean, "next_cursor" => cursor}}`
- or `{:error, reason}`

`collect_paginated_api/3` returns the error tuple directly. `iterate_paginated_api/3` raises if a later page fails while the stream is being consumed.

## Paginate data source templates

Templates have a slightly different response shape, so the SDK ships dedicated helpers:

```elixir
{:ok, templates} =
  NotionSDK.Pagination.collect_data_source_templates(client, %{
    "data_source_id" => data_source_id
  })
```

```elixir
NotionSDK.Pagination.iterate_data_source_templates(client, %{
  "data_source_id" => data_source_id
})
|> Enum.to_list()
```

## Extract IDs from Notion URLs

`NotionSDK.Helpers` normalizes canonical UUIDs, compact 32-character IDs, and Notion URLs:

```elixir
NotionSDK.Helpers.extract_notion_id("abc12345123456789abcdef012345678")

NotionSDK.Helpers.extract_page_id(
  "https://www.notion.so/My-Page-abc1234512345678abcdef0123456789"
)

NotionSDK.Helpers.extract_database_id(
  "https://www.notion.so/My-DB-fedcba9876543210fedcba9876543210"
)

NotionSDK.Helpers.extract_block_id(
  "https://notion.so/page#block-abc1234512345678abcdef0123456789"
)
```

Each helper returns a dashed, lowercase UUID or `nil`.

## Distinguish full and partial objects

Search, list, and retrieve endpoints may return different object variants. `NotionSDK.Guards` gives you small runtime predicates for branching:

```elixir
cond do
  NotionSDK.Guards.full_page?(object) ->
    {:page, object}

  NotionSDK.Guards.full_data_source?(object) ->
    {:data_source, object}

  true ->
    :unknown
end
```

Available checks include:

- `full_block?/1`
- `full_comment?/1`
- `full_data_source?/1`
- `full_database?/1`
- `full_page?/1`
- `full_page_or_data_source?/1`
- `full_user?/1`
- `equation_rich_text?/1`
- `mention_rich_text?/1`
- `text_rich_text?/1`
