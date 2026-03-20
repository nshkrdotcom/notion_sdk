# Regeneration and Parity Workflow

`notion_sdk` is not maintained by hand endpoint-by-endpoint. The committed codebase includes a repeatable workflow for snapshotting upstream inputs, regenerating the SDK surface, and reviewing the resulting diff.

## Supported commands

The supported entry points are the Mix tasks:

```bash
mix notion.generate
mix notion.refresh
mix notion.refresh --snapshots-only
mix notion.refresh --notion-docs-root /path/to/notion_docs --js-sdk-root /path/to/notion-sdk-js
```

`mix notion.generate` uses the committed extracted fixtures in
`priv/upstream/reference/`, `priv/upstream/reference_context/`, and the bounded
parity inventory in `priv/upstream/parity_inventory.json`. It does not require
a sibling `notion_docs` checkout when those fixtures are already present.

The generated runtime surface targets `Pristine.Operation`,
`Pristine.execute/3`, `Pristine.stream/3`, and thin `Pristine.Client`
integration. `notion_sdk` keeps direct compiler/runtime internals out of its
public contract.

## What `mix notion.refresh` does

`NotionSDK.Refresh.run!/1` performs four major steps:

1. snapshots upstream Notion docs and vendored JS SDK files
2. extracts the OpenAPI fixtures used for generation
3. persists structured `reference_context` artifacts from the same markdown pages
4. regenerates the SDK modules and bridge artifacts
5. writes a grouped diff report for review

`mix notion.refresh` re-extracts the committed fixtures from upstream markdown,
but it no longer assumes a sibling checkout layout. Point it at any prepared
input roots with `--notion-docs-root`, `--reference-root`, and `--js-sdk-root`
when the defaults are not appropriate.

## Important directories

- `priv/upstream/reference/`: extracted upstream OpenAPI fixtures
- `priv/upstream/reference_context/`: persisted page-context artifacts used to enrich docs
- `priv/upstream/parity_inventory.json`: committed bounded-surface inventory for the vendored JS SDK oracle
- `priv/upstream/supplemental/`: committed supplemental specs
- `priv/upstream/snapshots/`: raw upstream snapshot inputs
- `priv/generated/provider_ir.json`: committed normalized provider IR
- `priv/generated/generation_manifest.json`: generation summary emitted by the shared compiler
- `priv/generated/docs_inventory.json`: operation docs and source-context inventory
- `priv/generated/source_inventory.json`: source fingerprint inventory
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

## Common override patterns

`mix notion.generate` is the low-friction default. It rebuilds from committed
fixtures and inventory artifacts already present in the repo.

Use path overrides when you need to point at a different workspace layout:

```bash
mix notion.generate \
  --reference-dir /tmp/notion/reference \
  --reference-context-dir /tmp/notion/reference_context \
  --generated-dir /tmp/notion/generated \
  --generated-artifact-dir /tmp/notion/artifacts

mix notion.refresh \
  --notion-docs-root /worktrees/notion_docs \
  --js-sdk-root /worktrees/notion-sdk-js
```

## Parity target

The committed test suite currently pins:

- JS SDK oracle: `@notionhq/client` `5.12.0`
- Default Notion API version: `2025-09-03`
- Documented endpoint surface: 35 operations

`test/notion_sdk/parity_endpoint_test.exs` compares the committed provider IR
against `priv/upstream/parity_inventory.json`.

## When to use `generate` vs `refresh`

Use `mix notion.generate` when the upstream fixtures are already in place and you only need to regenerate Elixir code from committed inputs.

Use `mix notion.refresh` when you want the full end-to-end workflow, including snapshotting and extraction.

Use `mix notion.refresh --snapshots-only` when you want to capture upstream changes before deciding whether to regenerate.

## Docs richness checks

The richer docs are proved from generated artifacts, not hand edits:

- `priv/upstream/reference_context/*.json` should retain warnings, limits, errors, sections, resources, and code samples
- `priv/generated/docs_inventory.json` should include source-context-backed operation docs
- generated sources such as `lib/notion_sdk/generated/pages.ex` should show `## Source Context` and `## Code Samples`
- generated schema helpers such as `__openapi_fields__/1` should include doc metadata keys beyond `name`, `type`, and `required`
- generated request maps should carry stable runtime metadata such as `resource`, `retry`, `circuit_breaker`, and `rate_limit`
- `priv/upstream/snapshots/metadata.json` should record provenance fields such as `captured_at`, git commit/origin when available, and stable tracked-file digests
