# Regeneration and Parity Workflow

`notion_sdk` is not maintained by hand endpoint-by-endpoint. The committed codebase includes a repeatable workflow for snapshotting upstream inputs, regenerating the SDK surface, and reviewing the resulting diff.

## Supported commands

The supported entry points are the Mix tasks:

```bash
mix notion.generate
mix notion.refresh
mix notion.refresh --snapshots-only
```

The script wrappers remain available as direct entry points:

```bash
elixir scripts/generate_notion_sdk.exs
elixir scripts/refresh_notion_sdk.exs
```

`mix notion.generate` uses the committed extracted fixtures in
`priv/upstream/reference/` and `priv/upstream/reference_context/`. It does not
require a sibling `notion_docs` checkout when those fixtures are already
present.

## What `mix notion.refresh` does

`NotionSDK.Refresh.run!/1` performs four major steps:

1. snapshots upstream Notion docs and vendored JS SDK files
2. extracts the OpenAPI fixtures used for generation
3. persists structured `reference_context` artifacts from the same markdown pages
4. regenerates the SDK modules and bridge artifacts
5. writes a grouped diff report for review

`mix notion.refresh` still needs a local `notion_docs/reference/` checkout
because it re-extracts the committed fixtures from upstream markdown.

## Important directories

- `priv/upstream/reference/`: extracted upstream OpenAPI fixtures
- `priv/upstream/reference_context/`: persisted page-context artifacts used to enrich docs
- `priv/upstream/supplemental/`: committed supplemental specs
- `priv/upstream/snapshots/`: raw upstream snapshot inputs
- `priv/generated/manifest.json`: generated endpoint manifest
- `priv/generated/docs_manifest.json`: shared docs-manifest artifact emitted from the `pristine` seam
- `priv/generated/open_api_state.snapshot.term`: bridge snapshot
- `priv/generated/refresh_report.json`: grouped change report

## Recommended maintenance loop

Use this workflow when pulling a new upstream Notion release:

1. Run `mix notion.refresh`
2. Inspect `priv/generated/refresh_report.json`
3. Review changes under `priv/upstream/reference/`, `priv/upstream/reference_context/`, `lib/notion_sdk/generated/`, and `priv/generated/`
4. Run `mix compile --warnings-as-errors`
5. Run `mix test`
6. Run `mix dialyzer`
7. Run `mix credo --strict`
8. Regenerate docs with `mix docs` if the public surface changed

## Parity target

The committed test suite currently pins:

- JS SDK oracle: `@notionhq/client` `5.12.0`
- Default Notion API version: `2025-09-03`
- Documented endpoint surface: 35 operations

`test/notion_sdk/parity_endpoint_test.exs` enforces that operation matrix.

## When to use `generate` vs `refresh`

Use `mix notion.generate` when the upstream fixtures are already in place and you only need to regenerate Elixir code from committed inputs.

Use `mix notion.refresh` when you want the full end-to-end workflow, including snapshotting and extraction.

Use `mix notion.refresh --snapshots-only` when you want to capture upstream changes before deciding whether to regenerate.

## Docs richness checks

The richer docs are proved from generated artifacts, not hand edits:

- `priv/upstream/reference_context/*.json` should retain warnings, limits, errors, sections, resources, and code samples
- `priv/generated/docs_manifest.json` should include source-context-backed operation docs
- generated sources such as `lib/notion_sdk/generated/pages.ex` should show `## Source Context` and `## Code Samples`
- generated schema helpers such as `__openapi_fields__/1` should include doc metadata keys beyond `name`, `type`, and `required`
- generated request maps should carry stable runtime metadata such as `resource`, `retry`, `circuit_breaker`, and `rate_limit`
