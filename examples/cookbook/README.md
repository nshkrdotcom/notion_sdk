# Cookbook Examples

These examples are workflow-oriented companions to the strict live regression
proofs in [`../README.md`](../README.md).

Use them when you want a complete task flow instead of a single endpoint proof.
They still call the real Notion service, but they optimize for readability and
end-to-end shape rather than parity-matrix coverage.

Run an individual workflow from the repo root:

```bash
mix run examples/cookbook/01_create_page_with_blocks.exs
mix run examples/cookbook/03_upload_and_attach_file.exs
```

Run the full cookbook suite:

```bash
./examples/run_all.sh cookbook
```

## Cleanup behavior

Most cookbook examples create temporary pages, databases, or data sources and
trash them before the script exits.

The file-upload flows do not delete the upload records afterward because Notion
does not expose a delete endpoint for uploads. The cookbook upload example uses
the `single_part` flow so it still runs on free-plan workspaces.

The OAuth cookbook example does not exchange or revoke a fresh token. It shows
the authorization URL you would present to a user, then uses the saved token
file produced by `mix notion.oauth --save`.

## Inventory

- `01_create_page_with_blocks.exs`: create a child page, seed blocks during page creation, append more blocks, and read the page back as markdown
- `02_create_and_query_data_source.exs`: create a temporary database and data source, insert a row, then query it
- `03_upload_and_attach_file.exs`: create a single-part upload, then attach it to a page comment
- `04_search_paginate_and_branch.exs`: search the shared workspace, follow pagination cursors, then branch to a typed follow-up retrieve
- `05_oauth_onboard_and_call_api.exs`: build an authorization URL and call the API with the saved OAuth token file

## Prerequisites

Use the same environment setup described in [`../README.md`](../README.md):

- `NOTION_TOKEN` and the shared fixture ids for the content and data workflows
- `NOTION_EXAMPLE_FILE_URL` only when you also run the regression `files` suite
- `NOTION_OAUTH_CLIENT_ID`, `NOTION_OAUTH_CLIENT_SECRET`, `NOTION_OAUTH_REDIRECT_URI`, and a saved token file for the OAuth cookbook flow
