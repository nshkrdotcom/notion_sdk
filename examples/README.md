# Live Examples

These examples are for the real Notion service only.

The example harness uses `NOTION_EXAMPLE_*` env vars for fixture ids and URLs. Those values are example-only; the SDK client itself only needs auth and runtime configuration.

Rules:
- no mocks
- no fake transports
- no skipped runs because env was missing
- missing setup is a hard failure
- API errors are hard failures

Run every example through `mix run` from the repo root, or use [`run_all.sh`](./run_all.sh).

## What This Suite Covers

The example suite is intentionally broader than a single smoke check:
- real auth against `https://api.notion.com`
- `users.getSelf`, `search`, and `users.list`
- page retrieval, page property retrieval, and markdown retrieval
- block retrieval and page-child listing
- comment listing on a real page
- database retrieval
- data source retrieval, query, template listing, and template collection helper
- file upload listing, retrieval, external URL creation, and real multipart single-part upload
- OAuth token introspection for public integrations

## Onboarding

Use a disposable Notion workspace or a dedicated examples area. Some examples create file uploads. They do not mock or simulate anything.

### 1. Create an integration

Create a Notion integration and copy its token.

If you plan to run `06_list_page_comments.exs`, turn on the integration's
`Read comments` capability first. Comment capabilities are off by default in
Notion, and the comments endpoint returns `403 restricted_resource` until that
capability is enabled.

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

`NOTION_BASE_URL` and `NOTION_VERSION` are only needed when you want to override
the SDK defaults. If you set `NOTION_TIMEOUT_MS`, it must be a positive integer.

Production-oriented Foundation settings such as shared rate limiting, circuit
breaking, telemetry, or Dispatch admission control are configured through
`NotionSDK.Client.new(foundation: ...)` in application code. The example
harness does not map those runtime settings from environment variables. That
`foundation:` surface is implemented on top of Pristine's shared Foundation
runtime profile rather than a separate example-only code path.

### 2. Create one example database row page

Create a database or data source with at least one row page, then share that database with the integration.

That single row page is the anchor fixture for most of the suite:
- the page examples use it directly
- the block examples derive a child block from it
- the data examples derive the database and often the data source from it
- the comment example lists comments for that page id

The page should satisfy all of these:
- it belongs to a database-backed data source
- it has at least one child block
- it has at least one property

Export the page URL or UUID:

```bash
export NOTION_EXAMPLE_PAGE_ID="https://www.notion.so/...your-page-url..."
```

The examples accept either raw UUIDs or full Notion URLs anywhere an env var ends in `_ID`, except for `NOTION_EXAMPLE_PROPERTY_ID`, which is a raw property id string.

### 3. Optional explicit resource ids

Most examples can derive these from `NOTION_EXAMPLE_PAGE_ID`, but explicit values win if you set them:

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

If `NOTION_EXAMPLE_SEARCH_QUERY` is unset, `00_smoke.exs` runs `search` with an
empty query string.

### 4. External URL upload fixture for file suites

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
optional, but setting them removes ambiguity. If you do not want to provide an
external URL fixture, stop before the file suite and run only `smoke`,
`content`, or `data`.

### 5. Optional OAuth fixture

`16_oauth_introspect.exs`, `17_oauth_bearer_get_self.exs`, and
`18_oauth_refresh_and_get_self.exs` are for real OAuth/public-integration
credentials.

For most public integrations, use the redirect URI already registered under the
integration's `OAuth Domain & URIs` settings:

```bash
export NOTION_OAUTH_CLIENT_ID="..."
export NOTION_OAUTH_CLIENT_SECRET="..."
export NOTION_OAUTH_REDIRECT_URI="https://your-app.example.com/notion/callback"
mix notion.oauth --save --manual --no-browser
```

`NOTION_OAUTH_REDIRECT_URI` is the redirect URI, also called the callback URL.
If Notion shows only an `Authorization URL`, use the exact decoded value from
its `redirect_uri=...` parameter.

That flow prints the authorization URL, waits for approval in the browser, then
asks you to paste back the final redirected URL containing the temporary code.

Important distinctions:

- use the redirect URI already registered under `OAuth Domain & URIs`
- the Notion `Authorization URL` is the consent URL for OAuth
- the Notion `Webhook URL` field is unrelated to OAuth
- `NOTION_OAUTH_TOKEN_PATH` is only an optional override for the saved token
  file path on your machine

If you explicitly register a literal loopback redirect URI such as
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

`NOTION_OAUTH_ACCESS_TOKEN` is the access token returned from
`NotionSDK.OAuth.exchange_code/2`. It is not a value shown on the Notion
integration settings page. `mix notion.oauth refresh` updates the saved file in
place and preserves a rotated refresh token when Notion returns one.

Programmatic onboarding path:

```elixir
{:ok, request} =
  NotionSDK.OAuth.authorization_request(
    client_id: System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    redirect_uri: "https://example.com/callback"
  )

{:ok, token} =
  NotionSDK.OAuth.exchange_code("code-from-callback",
    client_id: System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    client_secret: System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET"),
    redirect_uri: "https://example.com/callback"
  )
```

Use a redirect URI that is already registered under `OAuth Domain & URIs`. The
current Notion docs also require `owner: "user"` on the
authorization URL, and the generated helper defaults that value for you.
`16_oauth_introspect.exs` can use either `NOTION_OAUTH_ACCESS_TOKEN` or the
saved file. `17_oauth_bearer_get_self.exs` and
`18_oauth_refresh_and_get_self.exs` use the default saved path automatically.
Set `NOTION_OAUTH_TOKEN_PATH` only if you want to override that path.
`18_oauth_refresh_and_get_self.exs` also requires `NOTION_OAUTH_CLIENT_ID` and
`NOTION_OAUTH_CLIENT_SECRET`.
Notion does not expose expiry metadata you can rely on for transparent
pre-expiry refresh, so this suite keeps refresh explicit.

## Running

Single example:

```bash
mix run examples/00_smoke.exs
mix run examples/03_retrieve_page_markdown.exs
mix run examples/15_upload_small_text_file.exs
```

Grouped suites:

```bash
./examples/run_all.sh smoke
./examples/run_all.sh content
./examples/run_all.sh data
./examples/run_all.sh files
./examples/run_all.sh all
./examples/run_all.sh oauth
./examples/run_all.sh everything
```

`all` runs every non-OAuth example. `everything` runs `all` plus the OAuth
examples.

## Example Inventory

Core:
- `00_smoke.exs`: `get_self`, `search`, and `list_users`

Content:
- `01_retrieve_page.exs`
- `02_retrieve_page_property.exs`
- `03_retrieve_page_markdown.exs`
- `04_retrieve_first_child_block.exs`
- `05_list_page_children.exs`
- `06_list_page_comments.exs`

Data:
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

OAuth:
- `16_oauth_introspect.exs`
- `17_oauth_bearer_get_self.exs`
- `18_oauth_refresh_and_get_self.exs`

## Operational Notes

- `15_upload_small_text_file.exs` creates a real file upload and sends real multipart form data.
- `13_create_external_file_upload.exs` creates a real external URL import.
- `06_list_page_comments.exs` succeeds even when the page has zero comments; zero comments is a real service response, not a skipped case.
- `06_list_page_comments.exs` also requires the integration's `Read comments` capability; otherwise Notion returns `403 restricted_resource`.
- `02_retrieve_page_property.exs` is most reliable when `NOTION_EXAMPLE_PAGE_ID` points at a row page inside a database-backed data source.
- `18_oauth_refresh_and_get_self.exs` is the explicit Notion proof flow: refresh the saved token, persist it, then call a bearer-authenticated endpoint with that saved file.
