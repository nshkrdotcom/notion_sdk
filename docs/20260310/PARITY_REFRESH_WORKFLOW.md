# Parity Acceptance and Refresh Workflow

This repo now treats the official JS SDK and local Notion docs mirror as the parity oracle and upgrade input set, with `priv/upstream/parity_inventory.json` defining the committed bounded surface.

## Commands

```bash
mix notion.generate
mix notion.refresh
mix notion.refresh --snapshots-only
```

Compatibility wrappers:

```bash
elixir scripts/generate_notion_sdk.exs
elixir scripts/refresh_notion_sdk.exs
```

## Refresh sequence

1. Update the local upstream sources first.
   - `notion-sdk-js/`
   - sibling `notion_docs/reference/`
2. Run `mix notion.refresh`.
3. Review grouped changes in:
   - `priv/upstream/parity_inventory.json`
   - `priv/upstream/snapshots/`
   - `priv/upstream/reference/`
   - `priv/upstream/reference_context/`
   - `priv/upstream/supplemental/`
   - `lib/notion_sdk/generated/`
   - `priv/generated/`
4. Inspect `priv/generated/refresh_report.json` for added, changed, and removed files by group.
5. Run the parity test suite before accepting the refresh.

## Review expectations

- upstream snapshot diffs should explain why extracted specs changed
- parity-inventory diffs should explain every added, removed, or renamed endpoint in the bounded surface
- reference-context diffs should explain any generated doc or docs-manifest changes
- generated code diffs should trace back to either upstream snapshot changes or supplemental spec changes
- bridge artifact diffs should remain deterministic and reviewable
- `docs_manifest.json` diffs should line up with `reference_context` or generated-source changes
- OAuth, markdown, file upload, retry, helper, and error-mapping parity tests should stay green after regeneration
