<p align="center">
  <img src="assets/notion_sdk.svg" alt="NotionSDK" width="200"/>
</p>

<p align="center">
  <a href="https://hex.pm/packages/notion_sdk"><img src="https://img.shields.io/hexpm/v/notion_sdk.svg" alt="Hex.pm"/></a>
  <a href="https://hexdocs.pm/notion_sdk"><img src="https://img.shields.io/badge/hex-docs-blue.svg" alt="HexDocs"/></a>
  <a href="https://hex.pm/packages/notion_sdk"><img src="https://img.shields.io/hexpm/l/notion_sdk.svg" alt="License"/></a>
</p>

# NotionSDK

Elixir SDK for the Notion API, generated from committed upstream Notion
reference fixtures and executed through the shared `pristine` runtime.

## What this SDK is

`NotionSDK` is intentionally thin:

- generated endpoint modules stay close to upstream JSON payloads
- `NotionSDK.Client` owns Notion-specific runtime defaults and auth behavior
- generic transport, retry, telemetry, and path-safety behavior comes from `pristine`
- hand-written guides explain the runtime contract, compatibility story, and common workflows around the generated API reference

The client owns runtime concerns such as auth, retries, transport, and headers.
Workspace resource ids stay on each request:

```elixir
{:ok, page} =
  NotionSDK.Pages.retrieve(client, %{
    "page_id" => "00000000-0000-0000-0000-000000000000"
  })
```

## Install

```elixir
def deps do
  [
    {:notion_sdk, "~> 0.1.0"}
  ]
end
```

Then fetch dependencies:

```bash
mix deps.get
```

## Make one request

Create a client with a bearer token:

```elixir
client = NotionSDK.Client.new(auth: System.fetch_env!("NOTION_TOKEN"))
```

Fetch the bot user tied to that token:

```elixir
{:ok, me} = NotionSDK.Users.get_self(client)
```

Search the workspace:

```elixir
{:ok, result} =
  NotionSDK.Search.search(client, %{
    "query" => "Roadmap",
    "page_size" => 10
  })
```

Responses stay as JSON-shaped maps by default. Opt in to typed request/response
validation and generated structs only when you want them:

```elixir
typed_client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN"),
    typed_responses: true
  )
```

## Docs map

- [Getting Started](guides/getting-started.md): install, defaults, client creation, and first calls
- [Client Configuration](guides/client-configuration.md): client options, Foundation runtime integration, retry tuning, typed responses, and transport overrides
- [Versioning and Compatibility](guides/versioning-and-compatibility.md): default Notion version, override rules, deprecated database messaging, and newer generated concepts
- [Capabilities, Permissions, and Sharing](guides/capabilities-permissions-and-sharing.md): what must be enabled or shared before content, comment, and user calls succeed
- [Pages, Blocks, and Search](guides/pages-blocks-and-search.md): read-oriented page, block, markdown, and search flows
- [Content Creation and Mutation](guides/content-creation-and-mutation.md): create, move, update, and append content
- [Data Sources and Databases](guides/data-sources-and-databases.md): metadata, queries, templates, and the `2025-09-03` split
- [File Uploads, Comments, and Users](guides/file-uploads-comments-and-users.md): namespace walkthroughs and smaller edge workflows
- [File Uploads and Page Attachments](guides/file-uploads-and-page-attachments.md): upload-complete-attach workflows for files, covers, icons, and comments
- [OAuth and Auth Overrides](guides/oauth-and-auth-overrides.md): authorization URLs, token exchange, saved token files, and request-scoped auth
- [Low-Level Requests](guides/low-level-requests.md): the user-facing custom-request escape hatch on `NotionSDK.Client.request/2`
- [Pagination, Helpers, and Guards](guides/pagination-helpers-and-guards.md): helper surface around paginated responses and Notion ids
- [Errors, Retries, and Observability](guides/errors-retries-and-observability.md): `%NotionSDK.Error{}`, retry groups, request ids, and telemetry
- [Regeneration and Parity Workflow](guides/regeneration-and-parity.md): snapshot refresh, code generation, and the JS oracle contract

## Examples map

- [Live Examples README](examples/README.md): the real-service regression-proof suite, fixture requirements, mutation notes, and grouped runner commands
- [Cookbook Examples README](examples/cookbook/README.md): task-oriented workflows that layer multiple endpoints into one runnable flow
- `examples/run_all.sh`: run `smoke`, `content`, `data`, `files`, `mutations`, `oauth`, `cookbook`, `all`, or `everything`
- Generated module docs on HexDocs: the source of truth for exact request/response shapes on each endpoint wrapper

The live examples use `NOTION_EXAMPLE_*` environment variables for fixture ids
and URLs. The SDK itself does not read those values unless an example passes
them into a request.

For custom requests that are not covered by a generated wrapper yet, use the
simplified raw request shape documented in
[Low-Level Requests](guides/low-level-requests.md). That escape hatch still runs
through the shared `pristine` request pipeline and path-safety checks.

## OAuth onboarding

Most public integrations already have a registered HTTPS redirect URI in
Notion. That is the easiest onboarding path:

```bash
export NOTION_OAUTH_CLIENT_ID="..."
export NOTION_OAUTH_CLIENT_SECRET="..."
export NOTION_OAUTH_REDIRECT_URI="https://your-app.example.com/notion/callback"

mix notion.oauth --save --manual --no-browser
```

That flow prints the authorization URL, waits for approval in the browser, then
exchanges the temporary code and saves the token JSON to
`~/.config/notion_sdk/oauth/notion.json` by default.

For persisted bearer auth, point the client at the generic file token source:

```elixir
client =
  NotionSDK.Client.new(
    oauth2: [
      token_source:
        {Pristine.Adapters.TokenSource.File,
         path: NotionSDK.OAuthTokenFile.default_path()}
    ]
  )
```

Use the full walkthrough in [OAuth and Auth Overrides](guides/oauth-and-auth-overrides.md) for loopback redirects, programmatic authorization URLs, refresh flows, and explicit Basic auth overrides on OAuth control endpoints.

## Compatibility, API versions, and newer concepts

The public default remains:

- Notion API version header: `2025-09-03`
- JS SDK oracle: `@notionhq/client` `5.12.0`
- Bounded parity inventory: `priv/upstream/parity_inventory.json`

You can override the version header per client:

```elixir
client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN"),
    notion_version: "2025-09-03"
  )
```

The vendored JS SDK README documents both `2025-09-03` and `2026-03-11`.
`notion_sdk` does not claim a blanket `2026-03-11` default today. Its public
contract is narrower: `2025-09-03` by default, plus additive newer schema
concepts that are already present in the committed generated surface.

That generated surface currently includes newer concepts such as:

- block append `position` with `after_block`, `start`, and `end`
- page create `position` with `after_block`, `page_start`, and `page_end`
- `in_trash` fields on modern page, block, database, data source, and upload responses
- `NotionSDK.MeetingNotesBlockObjectResponse`

Use [Versioning and Compatibility](guides/versioning-and-compatibility.md) for
the detailed support contract and migration guidance.

## Parity and regeneration

Surface proved in this package today:

- 35 documented endpoint definitions in the committed bounded parity inventory
- request building for OAuth, markdown, multipart uploads, and custom headers
- helper behavior, retry behavior, and error mapping

Supported maintenance commands:

```bash
mix notion.generate
mix notion.refresh
mix notion.refresh --snapshots-only
```

Use [Regeneration and Parity Workflow](guides/regeneration-and-parity.md) for
the artifact map, refresh steps, and oracle details.

## Tests and maintenance

Recommended verification loop:

```bash
mix compile --warnings-as-errors
mix test
mix dialyzer
mix credo --strict
mix docs
```
