# Versioning

`NotionSDK` defaults every client to the Notion API version header
`2025-09-03`.

That is the repo's supported default today. The SDK does not automatically move
to whatever upstream version is newest.

## Current contract

The supported contract in this repo has three layers:

- default request header: `2025-09-03`
- committed generated endpoint and schema surface from the checked-in upstream snapshots
- the shared `pristine` runtime for transport, retries, telemetry, and low-level request safety

In practice that means:

- the client always sends `Notion-Version: 2025-09-03` unless you override it
- the generated modules expose whatever fields and request shapes are present in the committed upstream fixtures
- the repo does not claim blanket parity with every newer Notion version just because some newer fields are present

## Override the version header deliberately

If you need a different Notion API version, set it per client:

```elixir
client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN"),
    notion_version: "2025-09-03"
  )
```

Keep the override explicit in application code so the chosen contract is easy to
audit.

## Current generated surface

The checked-in generated code already includes fields and request shapes such as:

- `NotionSDK.Blocks.append_children/2` accepts `position` with `after_block`, `start`, and `end`
- `NotionSDK.Pages.create/2` accepts `position` with `after_block`, `page_start`, and `page_end`
- modern page, block, database, data source, and file-upload response models expose `in_trash`
- block unions include `meeting_notes` response support

If a field, schema, or module appears in the committed generated code and docs,
it is part of the current supported surface. The SDK no longer ships a
separate overlay contract or extra generated artifacts on top of that output.

## What this repo does not claim

The vendored JS SDK README documents both `2025-09-03` and `2026-03-11`.
`notion_sdk` does not claim a repo-wide `2026-03-11` default today.

The safer statement is:

- `2025-09-03` is the default header
- fields and request shapes already present in committed generated code are available as part of the current surface
- if you rely on those newer concepts, use the explicit opt-in path: set `notion_version: "2026-03-11"` (or a later reviewed value), then test the affected flows in your workspace

## Databases vs data sources

The `2025-09-03` split between databases and data sources matters in this SDK.

You will see both namespaces because:

- `NotionSDK.DataSources` is the current main surface for many structured-content workflows
- `NotionSDK.Databases` remains present for endpoints that the upstream docs still expose
- generated docs in `NotionSDK.Databases` already mark the older database-only language as deprecated under `2025-09-03`

When starting new work, prefer the data-source language from the current guides
and generated docs.

## Practical guidance

- stay on the default version unless you have a concrete reason to change it
- keep version overrides close to the call sites or client construction that needs them
- when using newer concepts such as `position`, test both the request shape and the resulting behavior in a disposable workspace
- treat generated module docs as the source of truth for exact request keys and response unions

## Related guides

- `getting-started.md` for defaults and first requests
- `client-configuration.md` for the `notion_version` option
- `content-creation-and-mutation.md` for the newer `position` flows
- `regeneration-and-parity.md` for snapshot refresh and oracle context
