# Parity Acceptance and Refresh Workflow

This repo now treats the official JS SDK and local Notion docs mirror as the parity oracle and upgrade input set, with `priv/upstream/parity_inventory.json` defining the committed bounded surface.

## Commands

```bash
mix notion.generate
mix notion.refresh
mix notion.refresh --snapshots-only
```

## Refresh sequence

1. Update the local upstream sources first.
   - `notion-sdk-js/`
   - any Notion docs checkout or prepared snapshot root you plan to point `mix notion.refresh` at
2. Run `mix notion.refresh`.
   - use `--notion-docs-root`, `--reference-root`, and `--js-sdk-root` if your sources do not live in the default layout
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
- snapshot metadata diffs should show auditable provenance fields, not just file lists
- reference-context diffs should explain any generated doc or docs-manifest changes
- generated code diffs should trace back to either upstream snapshot changes or supplemental spec changes
- bridge artifact diffs should remain deterministic and reviewable
- `docs_manifest.json` diffs should line up with `reference_context` or generated-source changes
- OAuth, markdown, file upload, retry, helper, and error-mapping parity tests should stay green after regeneration
