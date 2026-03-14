# Execution Checklist

Repo-local mirror of the packet checklist, updated to match the implementation that exists in `notion_sdk`.

## Scope Freeze

- [x] official target pinned to JS SDK `5.12.0`
- [x] default Notion API version pinned to `2025-09-03`
- [x] 35 documented endpoint defs tracked in the committed parity inventory and tests
- [x] refresh workflow moved onto committed wrapper tasks instead of one-off codegen glue

## Thin Rebuild Reality

- [x] generated endpoint modules committed under `lib/notion_sdk/generated/`
- [x] thin `NotionSDK.Client` layered on `pristine`
- [x] thin `NotionSDK.Error` implemented
- [x] thin helper modules implemented (`Helpers`, `Guards`, `Pagination`)
- [x] upstream extracted specs committed under `priv/upstream/reference/`
- [x] bounded parity inventory committed under `priv/upstream/parity_inventory.json`
- [x] supplemental specs committed under `priv/upstream/supplemental/`

## Parity Validation

- [x] endpoint presence matrix asserted in tests
- [x] markdown endpoints covered
- [x] file upload lifecycle request building covered
- [x] OAuth basic-auth request building covered
- [x] retry behavior covered by status and method
- [x] helper behavior covered
- [x] error mapping and `additional_data` handling covered

## Refresh Workflow

- [x] `mix notion.generate` added
- [x] `mix notion.refresh` added
- [x] script wrappers kept for compatibility
- [x] upstream snapshot capture path defined under `priv/upstream/snapshots/`
- [x] grouped diff report emitted to `priv/generated/refresh_report.json`

## Remaining Follow-Up

- [ ] refresh the committed snapshot contents in-repo by running `mix notion.refresh`
- [ ] mirror these checklist updates back into the external packet files if those paths need to stay authoritative
