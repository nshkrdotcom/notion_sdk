# Versioning and Compatibility

`NotionSDK` currently defaults every client to:

- `Notion-Version: 2025-09-03`

That pinned header is intentional. The SDK does not automatically move forward
when upstream Notion docs or the vendored JS SDK change.

## The current repo contract

The supported contract in this repo has four layers:

- the default request header `2025-09-03`
- the committed generated endpoint and schema surface in this repo
- the bounded JS SDK oracle pinned in `priv/upstream/parity_inventory.json`
- the shared `pristine` runtime used for transport, retries, telemetry, and path safety

In practice that means:

- the client sends `Notion-Version: 2025-09-03` unless you override it
- the generated modules expose whatever request shapes and fields are present in the committed fixtures
- the repo only claims parity for the bounded surface under test, not for every newer upstream concept automatically

The current parity inventory is pinned to `@notionhq/client` `5.12.0`.

## Override the version header deliberately

If you need a different Notion API version, set it per client:

```elixir
client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN"),
    notion_version: "2025-09-03"
  )
```

Keep the override explicit in code so the chosen contract stays easy to audit.

## What the committed generated surface already includes

The checked-in generated code already exposes request shapes and fields such as:

- `NotionSDK.Blocks.append_children/2` `position.type` values `after_block`, `start`, and `end`
- `NotionSDK.Pages.create/2` `position.type` values `after_block`, `page_start`, and `page_end`
- `in_trash` fields on modern page, block, database, data source, and file-upload responses
- `meeting_notes` support in the generated block unions

Those shapes are part of the current committed surface because they exist in the
generated code and tests. They do not change the fact that the default header
remains `2025-09-03`.

If you rely on these newer shapes in a real workspace, keep the version choice
explicit and test the affected flows end to end.

## Databases vs data sources

The `2025-09-03` split between databases and data sources matters in this SDK.

You will see both namespaces because:

- `NotionSDK.DataSources` is the main surface for queries, templates, and record workflows
- `NotionSDK.Databases` remains available for database endpoints still documented upstream
- generated docs under `NotionSDK.Databases` already carry the newer deprecation context where appropriate

When starting new work, prefer the data-source language from the current guides
and generated docs.

## Practical guidance

- stay on the default header unless you have a concrete compatibility reason to change it
- keep version overrides close to the client construction or call sites that need them
- treat generated module docs as the source of truth for exact request keys and response unions
- when you use newer request shapes such as `position`, test the request and resulting Notion behavior in a disposable workspace

## Related guides

- `getting-started.md` for defaults and first requests
- `client-configuration.md` for the `notion_version` option
- `content-creation-and-mutation.md` for `position`-based mutation flows
- `regeneration-and-parity.md` for snapshot refresh and oracle details
