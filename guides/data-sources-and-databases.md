# Data Sources and Databases

The SDK exposes both `NotionSDK.DataSources` and `NotionSDK.Databases` because the upstream Notion surface still documents both namespaces. In practice:

- use `NotionSDK.DataSources` for querying records and template workflows
- use `NotionSDK.Databases` when you need the documented database endpoints that still exist in the API surface

## Retrieve metadata

Fetch a data source:

```elixir
{:ok, data_source} =
  NotionSDK.DataSources.retrieve(client, %{
    "data_source_id" => data_source_id
  })
```

Fetch a database:

```elixir
{:ok, database} =
  NotionSDK.Databases.retrieve(client, %{
    "database_id" => database_id
  })
```

## Query a data source

`NotionSDK.DataSources.query/2` is the primary record-listing endpoint:

```elixir
{:ok, result_page} =
  NotionSDK.DataSources.query(client, %{
    "data_source_id" => data_source_id,
    "page_size" => 100,
    "filter" => filter,
    "sorts" => sorts
  })
```

The request body is passed through largely unchanged, so you can reuse filter and sort JSON from Notion's reference documentation.

## Create or update a data source

When you are provisioning or modifying schema:

```elixir
{:ok, data_source} =
  NotionSDK.DataSources.create(client, %{
    "parent" => parent,
    "title" => title,
    "properties" => properties
  })
```

```elixir
{:ok, updated_data_source} =
  NotionSDK.DataSources.update(client, %{
    "data_source_id" => data_source_id,
    "title" => title,
    "properties" => properties
  })
```

As with page properties, the exact `properties` structure depends on the schema you want Notion to enforce.

## Work with templates

List templates for a data source:

```elixir
{:ok, template_page} =
  NotionSDK.DataSources.list_templates(client, %{
    "data_source_id" => data_source_id,
    "page_size" => 100
  })
```

Collect the full template set with the specialized pagination helper:

```elixir
{:ok, templates} =
  NotionSDK.Pagination.collect_data_source_templates(client, %{
    "data_source_id" => data_source_id
  })
```

## Database-specific behavior

The database endpoints are thinner and focus on retrieve, create, and update:

```elixir
{:ok, database} =
  NotionSDK.Databases.update(client, %{
    "database_id" => database_id,
    "title" => title,
    "description" => description,
    "is_locked" => true
  })
```

When Notion returns validation metadata, the SDK preserves it in `%NotionSDK.Error{additional_data: ...}`. That is especially useful for database responses tied to newer data source behavior:

```elixir
case NotionSDK.Databases.retrieve(client, %{"database_id" => database_id}) do
  {:ok, database} ->
    database

  {:error, %NotionSDK.Error{code: :validation_error, additional_data: data}} ->
    {:validation_error, data}
end
```
