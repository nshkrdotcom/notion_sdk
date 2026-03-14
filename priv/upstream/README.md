This directory stores the committed upstream inputs used to generate `notion_sdk`.

- `parity_inventory.json` is the bounded parity source of truth for the vendored JS SDK surface.
- `reference/*.yaml` are extracted from whichever markdown source is passed to `mix notion.refresh` or `mix notion.generate`.
- `reference_context/*.json` stores deterministic page-context artifacts extracted from the same markdown pages.
- `supplemental/*.yaml` contains small committed OpenAPI roots or overlays used by codegen.
- `snapshots/` stores raw upstream docs and JS SDK source snapshots captured for refresh review.
- Regenerate extracted code with `mix notion.generate`.
- Refresh snapshots, extracted specs, persisted page context, generated code, and bridge artifacts with `mix notion.refresh`.
