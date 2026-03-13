<p align="center">
  <img src="assets/notion_sdk.svg" alt="NotionSDK" width="200"/>
</p>

<p align="center">
  <a href="https://hex.pm/packages/notion_sdk"><img src="https://img.shields.io/hexpm/v/notion_sdk.svg" alt="Hex.pm"/></a>
  <a href="https://hexdocs.pm/notion_sdk"><img src="https://img.shields.io/badge/hex-docs-blue.svg" alt="HexDocs"/></a>
  <a href="https://hex.pm/packages/notion_sdk"><img src="https://img.shields.io/hexpm/l/notion_sdk.svg" alt="License"/></a>
</p>

# NotionSDK

Elixir SDK for the Notion API, generated from the official Notion docs snippets through `oapi_generator` and executed through `pristine`.

## Runtime usage

Create a client with a bearer token:

```elixir
client = NotionSDK.Client.new(auth: System.fetch_env!("NOTION_TOKEN"))
```

Or opt into OAuth-backed bearer auth explicitly for bearer-authenticated API endpoints only:

```elixir
client =
  NotionSDK.Client.new(
    oauth2: [
      token_source:
        {Pristine.Adapters.TokenSource.Static,
         token: %Pristine.OAuth2.Token{access_token: System.fetch_env!("NOTION_OAUTH_ACCESS_TOKEN")}}
    ]
  )
```

That opt-in does not turn the whole SDK into an "OAuth mode". Bearer-authenticated API endpoints can use the token source, while OAuth control endpoints still require explicit Basic auth credentials or the high-level helper functions below.

For persisted bearer auth, point the client at the generic file token source:

```elixir
client =
  NotionSDK.Client.new(
    oauth2: [
      token_source:
        {Pristine.Adapters.TokenSource.File,
         path: System.fetch_env!("NOTION_OAUTH_TOKEN_PATH")}
    ]
  )
```

The client only owns runtime concerns such as auth, retries, transport, and headers. It does not require a page id, database id, or any other workspace resource id at initialization time. Those stay on each request:

```elixir
{:ok, page} =
  NotionSDK.Pages.retrieve(client, %{
    "page_id" => "00000000-0000-0000-0000-000000000000"
  })
```

Responses stay as JSON-shaped maps by default. Opt in to typed response materialization when you want generated structs and runtime request/response validation:

```elixir
typed_client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN"),
    typed_responses: true
  )
```

The live examples use `NOTION_EXAMPLE_*` environment variables for fixture ids and URLs. Legacy names such as `NOTION_PAGE_ID` still work during the transition, but the SDK itself does not read those values unless an example passes them into a request.

## Programmatic OAuth Onboarding

The preferred onboarding path is the interactive Mix task:

```bash
export NOTION_OAUTH_CLIENT_ID="..."
export NOTION_OAUTH_CLIENT_SECRET="..."
export NOTION_OAUTH_REDIRECT_URI="http://127.0.0.1:40071/callback"

mix notion.oauth
mix notion.oauth --save
mix notion.oauth --manual --no-browser
mix notion.oauth refresh
mix notion.oauth refresh --path="$HOME/.config/notion_sdk/oauth/notion.json"
```

Use a redirect URI that is already registered in the Notion integration
settings. If you use loopback, keep it exact and prefer a literal loopback IP
such as `127.0.0.1` instead of `localhost`.
The task does not choose a random loopback port for you.
The task prints the access token, any refresh token, and ready-to-paste export
commands.
When `--save` is set, `notion_sdk` writes the generic token envelope to
`$XDG_CONFIG_HOME/notion_sdk/oauth/notion.json`, or to
`~/.config/notion_sdk/oauth/notion.json` when `XDG_CONFIG_HOME` is unset.
Use `--path=...` to override that location.
Use `mix notion.oauth refresh` to explicitly refresh that saved file in place.
The task preserves a rotated refresh token when Notion returns one.

Use the helper layer on `NotionSDK.OAuth` to generate authorization URLs and exchange codes without falling back to shell or `curl` flows:

```elixir
{:ok, auth_request} =
  NotionSDK.OAuth.authorization_request(
    client_id: System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    redirect_uri: "https://example.com/callback",
    generate_state: true
  )

{:ok, token} =
  NotionSDK.OAuth.exchange_code("code-from-callback",
    client_id: System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    client_secret: System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET"),
    redirect_uri: "https://example.com/callback"
  )
```

Per the current Notion OAuth docs, the authorization URL should include both
`redirect_uri` and `owner: "user"`. `NotionSDK.OAuth.authorization_request/1`
defaults `owner=user` and fails clearly if `redirect_uri` is missing.
`pristine` supports PKCE generically, but the current Notion docs do not
document PKCE support, so it is omitted here.

`NOTION_OAUTH_ACCESS_TOKEN` in examples is the access token returned by that
code exchange. It is not a dashboard field shown on the Notion integration
settings page. `NOTION_OAUTH_TOKEN_PATH` points at the saved JSON token file
when you use `mix notion.oauth --save`.
Notion's OAuth docs do not expose expiry metadata you can rely on for
transparent pre-expiry refresh, so `notion_sdk` keeps refresh explicit through
`mix notion.oauth refresh` and the live refresh example instead of claiming
automatic Notion token refresh inside bearer-authenticated requests.

## Parity target

- JS SDK oracle: `@notionhq/client` `5.12.0`
- Default Notion API version: `2025-09-03`
- Surface proved in this package: 35 documented endpoint definitions, helper behavior, retry behavior, request building, and error mapping

## Regeneration

The committed wrapper tasks are the supported path:

```bash
mix notion.generate
mix notion.refresh
mix notion.refresh --snapshots-only
```

Script wrappers are kept for compatibility:

```bash
elixir scripts/generate_notion_sdk.exs
elixir scripts/refresh_notion_sdk.exs
```

`mix notion.refresh` performs five steps:

1. snapshots the upstream Notion docs pages and vendored JS SDK oracle files into `priv/upstream/snapshots/`
2. extracts the OpenAPI fixtures used for generation into `priv/upstream/reference/`
3. persists structured page-context artifacts into `priv/upstream/reference_context/`
4. regenerates the SDK surface and bridge artifacts
5. writes `priv/generated/refresh_report.json` with grouped diffs for review

## Key artifacts

- `priv/upstream/reference/*.yaml`: extracted upstream OpenAPI fixtures
- `priv/upstream/reference_context/*.json`: persisted page-context artifacts keyed by slug and `{method, path}`
- `priv/upstream/supplemental/*.yaml`: committed supplemental specs
- `priv/upstream/snapshots/`: raw upstream snapshot inputs for review
- `priv/generated/manifest.json`: generated endpoint manifest
- `priv/generated/docs_manifest.json`: shared `pristine` docs-manifest projection for generated review
- `priv/generated/open_api_state.snapshot.term`: bridge snapshot
- `priv/generated/refresh_report.json`: grouped refresh diff report

## Oracle sources

- `notion-sdk-js/`: vendored official JS SDK source and tests
- sibling `notion_docs/reference/`: local Notion docs mirror used for OpenAPI extraction

## Tests

The parity suite lives under `test/notion_sdk/` and covers:

- endpoint presence against the documented 35-operation matrix
- request-building parity for OAuth, markdown, multipart uploads, and low-level custom headers
- retry parity by status and method
- helper parity for pagination, template iteration, guards, and ID extraction
- error mapping parity including `additional_data` and `Retry-After` handling

Recommended verification loop:

```bash
mix compile --warnings-as-errors
mix test
mix dialyzer
mix credo --strict
```
