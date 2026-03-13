# Live Examples

These examples are strict real-service proofs for the Notion API surface in
this package.

If you want workflow-oriented examples instead of one-operation proofs, see the
[Cookbook README](./cookbook/README.md).

The example harness uses `NOTION_EXAMPLE_*` env vars for fixture ids and URLs.
Those values are example-only; the SDK client itself only needs auth and
runtime configuration.

Rules:

- no mocks
- no fake transports
- missing setup is a hard failure
- API errors are hard failures
- the mutation suite assumes you are using a disposable workspace or a dedicated examples area

Run every example through `mix run` from the repo root, or use
[`run_all.sh`](./run_all.sh).

## What This Suite Covers

The live suite now directly covers all 35 operations in
`test/notion_sdk/parity_endpoint_test.exs`.

That includes:

- auth and user retrieval flows
- page, property, markdown, block, and comment reads
- database and data source reads plus queries and templates
- file upload list, retrieve, create, send, and complete flows
- page, block, comment, database, and data source mutations
- OAuth introspection, bearer calls, refresh, token exchange, and revoke

## Onboarding

Use a disposable Notion workspace or a dedicated examples area. The mutation
suite creates temporary pages, comments, databases, and data sources.

### 1. Create an integration and enable the right capabilities

Create a Notion integration and copy its token.

Export:

```bash
export NOTION_TOKEN="secret_..."
```

Optional client runtime overrides:

```bash
export NOTION_BASE_URL="https://api.notion.com"
export NOTION_VERSION="2025-09-03"
export NOTION_TIMEOUT_MS="60000"
```

`NOTION_BASE_URL` and `NOTION_VERSION` are only needed when you want to
override the SDK defaults. If you set `NOTION_TIMEOUT_MS`, it must be a
positive integer.

Capability checklist:

- enable `Read comments` before running `06_list_page_comments.exs`
- enable comment-insert capability before running `27_create_comment.exs` or `28_retrieve_comment.exs`
- enable content-insert and content-update capability before running the `mutations` suite

Production-oriented Foundation settings such as shared rate limiting, circuit
breaking, telemetry, or Dispatch admission control are configured through
`NotionSDK.Client.new(foundation: ...)` in application code. The example
harness does not map those runtime settings from environment variables.

### 2. Choose one anchor page fixture

Create a page that satisfies all of these:

- it belongs to a database-backed data source
- it has at least one child block
- it has at least one property
- it is shared with the integration

That single page anchors the full regression suite:

- the read examples use it directly
- database and data source reads derive ids from it when explicit ids are unset
- the mutation suite creates and later trashes temporary pages, comments, databases, and data sources under it

Export the page URL or UUID:

```bash
export NOTION_EXAMPLE_PAGE_ID="https://www.notion.so/...your-page-url..."
```

The examples accept either raw UUIDs or full Notion URLs anywhere an env var
ends in `_ID`, except for `NOTION_EXAMPLE_PROPERTY_ID`, which is a raw property
id string.

### 3. Optional explicit resource ids

Most examples can derive these from `NOTION_EXAMPLE_PAGE_ID`, but explicit
values win if you set them:

```bash
export NOTION_EXAMPLE_DATABASE_ID="https://www.notion.so/...database-url..."
export NOTION_EXAMPLE_DATA_SOURCE_ID="https://www.notion.so/...data-source-url..."
export NOTION_EXAMPLE_BLOCK_ID="https://www.notion.so/...block-url-or-uuid..."
export NOTION_EXAMPLE_PROPERTY_ID="f%3A%5Dq"
export NOTION_EXAMPLE_PROPERTY_NAME="Name"
export NOTION_EXAMPLE_FILE_UPLOAD_ID="aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
```

Useful behavior:

- if `NOTION_EXAMPLE_DATABASE_ID` is missing, examples derive it from the page parent
- if `NOTION_EXAMPLE_DATA_SOURCE_ID` is missing, examples derive it from the page parent or the database response
- if `NOTION_EXAMPLE_BLOCK_ID` is missing, examples derive the first child block from the page
- if `NOTION_EXAMPLE_PROPERTY_ID` is missing, examples use `NOTION_EXAMPLE_PROPERTY_NAME` or the first page property
- if `NOTION_EXAMPLE_FILE_UPLOAD_ID` is missing, retrieval falls back to the first result from `fileUploads.list`

Optional smoke search query:

```bash
export NOTION_EXAMPLE_SEARCH_QUERY="roadmap"
```

If `NOTION_EXAMPLE_SEARCH_QUERY` is unset, `00_smoke.exs` and the cookbook
search example run `search` with an empty query string.

### 4. External URL upload fixture

`13_create_external_file_upload.exs` requires a real HTTPS file URL. That means
`NOTION_EXAMPLE_FILE_URL` is required when you run:

- `mix run examples/13_create_external_file_upload.exs`
- `./examples/run_all.sh files`
- `./examples/run_all.sh all`
- `./examples/run_all.sh everything`

Set:

```bash
export NOTION_EXAMPLE_FILE_URL="https://example.com/path/to/file.pdf"
export NOTION_EXAMPLE_FILE_FILENAME="file.pdf"
export NOTION_EXAMPLE_FILE_CONTENT_TYPE="application/pdf"
```

`NOTION_EXAMPLE_FILE_FILENAME` and `NOTION_EXAMPLE_FILE_CONTENT_TYPE` are
optional, but setting them removes ambiguity.

`33_complete_file_upload.exs` is different from the other upload examples: it
proves the multipart `fileUploads.complete` endpoint and therefore requires a
workspace plan that supports multipart uploads. Free-plan workspaces reject the
multipart create call before the example can reach `complete`.

### 5. OAuth fixture

`16_oauth_introspect.exs`, `17_oauth_bearer_get_self.exs`,
`18_oauth_refresh_and_get_self.exs`, `34_oauth_token_exchange.exs`, and
`35_oauth_revoke.exs` are for real OAuth public-integration credentials.

Set:

```bash
export NOTION_OAUTH_CLIENT_ID="..."
export NOTION_OAUTH_CLIENT_SECRET="..."
export NOTION_OAUTH_REDIRECT_URI="https://your-app.example.com/notion/callback"
```

If you want the saved-token flow used by `16` through `18` and the cookbook
OAuth example:

```bash
mix notion.oauth --save --manual --no-browser
```

If you explicitly registered a loopback redirect URI such as
`http://127.0.0.1:40071/callback`, you can use automatic callback capture:

```bash
export NOTION_OAUTH_REDIRECT_URI="http://127.0.0.1:40071/callback"
mix notion.oauth --save
```

By default `mix notion.oauth --save` writes the token file to:

```bash
~/.config/notion_sdk/oauth/notion.json
```

The OAuth examples use that same default path automatically. Set
`NOTION_OAUTH_TOKEN_PATH` only if you want to override it.

`34_oauth_token_exchange.exs` proves the raw `POST /v1/oauth/token` endpoint,
so it needs a fresh authorization code. You can provide one up front:

```bash
export NOTION_OAUTH_AUTH_CODE="code-from-the-redirect"
```

If `NOTION_OAUTH_AUTH_CODE` is unset, `34_oauth_token_exchange.exs` falls back
to the same manual pattern used by `mix notion.oauth --manual --no-browser`: it
prints the authorization URL and asks you to paste either the final redirected
URL or the raw code.

That script saves the exchanged token to a separate temporary path so it does
not overwrite the saved token file used by `16` through `18`.

Optional overrides for the exchange-and-revoke pair:

```bash
export NOTION_OAUTH_EXCHANGE_TOKEN_PATH="/tmp/notion_sdk_example_oauth_exchange.json"
export NOTION_OAUTH_REVOKE_TOKEN="access_token_to_revoke"
```

Behavior:

- if `NOTION_OAUTH_REVOKE_TOKEN` is unset, `35_oauth_revoke.exs` revokes the token saved by `34_oauth_token_exchange.exs`
- if `NOTION_OAUTH_REVOKE_TOKEN` is set, `35_oauth_revoke.exs` revokes that explicit token instead

## Running

Single example:

```bash
mix run examples/00_smoke.exs
mix run examples/23_update_page_markdown.exs
mix run examples/33_complete_file_upload.exs
mix run examples/cookbook/03_upload_and_attach_file.exs
```

Grouped suites:

```bash
./examples/run_all.sh smoke
./examples/run_all.sh content
./examples/run_all.sh data
./examples/run_all.sh files
./examples/run_all.sh mutations
./examples/run_all.sh oauth
./examples/run_all.sh cookbook
./examples/run_all.sh all
./examples/run_all.sh everything
```

Suite behavior:

- `all` runs every non-OAuth regression proof
- `everything` runs `all` plus the OAuth proofs
- `cookbook` runs only the task-oriented workflow examples
- `mutations`, `all`, and `everything` include `33_complete_file_upload.exs`, so they inherit the multipart-upload plan requirement described above

## Example Inventory

Smoke:

- `00_smoke.exs`: `users.getSelf`, `search`, and `users.list`
- `19_retrieve_user.exs`: `users.retrieve`

Content reads:

- `01_retrieve_page.exs`
- `02_retrieve_page_property.exs`
- `03_retrieve_page_markdown.exs`
- `04_retrieve_first_child_block.exs`
- `05_list_page_children.exs`
- `06_list_page_comments.exs`

Data reads:

- `07_retrieve_database.exs`
- `08_retrieve_data_source.exs`
- `09_query_data_source.exs`
- `10_list_data_source_templates.exs`
- `11_collect_data_source_templates.exs`

Files:

- `12_list_file_uploads.exs`
- `13_create_external_file_upload.exs`
- `14_retrieve_file_upload.exs`
- `15_upload_small_text_file.exs`

Mutations:

- `20_create_page.exs`
- `21_update_page.exs`
- `22_move_page.exs`
- `23_update_page_markdown.exs`
- `24_append_block_children.exs`
- `25_update_block.exs`
- `26_delete_block.exs`
- `27_create_comment.exs`
- `28_retrieve_comment.exs`
- `29_create_database.exs`
- `30_update_database.exs`
- `31_create_data_source.exs`
- `32_update_data_source.exs`
- `33_complete_file_upload.exs`

OAuth:

- `16_oauth_introspect.exs`
- `17_oauth_bearer_get_self.exs`
- `18_oauth_refresh_and_get_self.exs`
- `34_oauth_token_exchange.exs`
- `35_oauth_revoke.exs`

Cookbook:

- `cookbook/01_create_page_with_blocks.exs`
- `cookbook/02_create_and_query_data_source.exs`
- `cookbook/03_upload_and_attach_file.exs`
- `cookbook/04_search_paginate_and_branch.exs`
- `cookbook/05_oauth_onboard_and_call_api.exs`

## Operational Notes

- `15_upload_small_text_file.exs` creates a real file upload and sends real multipart form data
- `33_complete_file_upload.exs` creates a one-part multipart upload and then finalizes it with `fileUploads.complete`
- `33_complete_file_upload.exs` requires a workspace plan with multipart upload support; free-plan workspaces fail that example with a real `validation_error`
- `20_create_page.exs` through `32_update_data_source.exs` create temporary resources and trash them before exit
- `27_create_comment.exs` and `28_retrieve_comment.exs` create comments on a temporary page and then trash that page
- `13_create_external_file_upload.exs` creates a real external URL import
- `06_list_page_comments.exs` succeeds even when the page has zero comments; zero comments is a real service response
- `06_list_page_comments.exs`, `27_create_comment.exs`, and `28_retrieve_comment.exs` require explicit comment capabilities
- `34_oauth_token_exchange.exs` writes the exchanged token to `NOTION_OAUTH_EXCHANGE_TOKEN_PATH` or a temporary default path instead of the saved token file used by the other OAuth examples
- `34_oauth_token_exchange.exs` can either read `NOTION_OAUTH_AUTH_CODE` or prompt interactively for the redirected callback URL, mirroring the existing `mix notion.oauth` manual flow
