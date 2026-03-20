# Getting Started

`NotionSDK` is a thin Elixir client for the Notion API. The library stays close to the upstream JSON payloads, exposes the documented API namespaces as generated modules, and layers a small amount of Notion-specific behavior on top of `Pristine`.

The dependency on `pristine` is intentional. `notion_sdk` targets
`Pristine.Operation`, `Pristine.execute/3`, `Pristine.stream/3`,
`Pristine.Client.foundation/1`, and `Pristine.OAuth2` as its supported runtime
boundary.

Related guides: `client-configuration.md`, `low-level-requests.md`, `versioning-and-compatibility.md`, `capabilities-permissions-and-sharing.md`, `examples/README.md`.

## Add the dependency

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

## Configure SDK defaults

The client already ships with sensible defaults:

- Base URL: `https://api.notion.com`
- Notion API version: `2025-09-03`
- Timeout: `60_000` ms
- Retry policy: two retries with exponential backoff

The committed generated surface already includes current Notion concepts such
as `position`, `in_trash`, and `meeting_notes`. Use the versioning guide when
you need to override the default `Notion-Version` header.

Only configure values you want to override:

```elixir
import Config

config :notion_sdk,
  notion_version: "2025-09-03",
  timeout_ms: 60_000,
  user_agent: "my-app/1.0.0"
```

## Create a client

The usual entry point is `NotionSDK.Client.new/1` with a bearer token:

```elixir
client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN")
  )
```

There is also a shorthand that accepts the token as the first argument:

```elixir
client =
  NotionSDK.Client.new(
    System.fetch_env!("NOTION_TOKEN"),
    timeout_ms: 15_000
  )
```

If you only need OAuth control endpoints such as token exchange, introspection,
or revoke, `NotionSDK.Client.new()` without `auth:` is valid too.

Examples in these guides use string keys. That matches the upstream JSON field names and mirrors the shapes exercised in the test suite.

The client does not take a page id or other workspace fixture ids at initialization time. Those ids are per-request inputs:

```elixir
{:ok, page} =
  NotionSDK.Pages.retrieve(client, %{
    "page_id" => page_id
  })
```

If you want generated structs instead of raw maps, opt in explicitly:

```elixir
typed_client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN"),
    typed_responses: true
  )
```

Without `typed_responses: true`, success payloads remain JSON-shaped maps.

## Production Runtime

When you want shared rate-limit learning, circuit breaking, structured
telemetry, or Dispatch-based admission control, use the curated
`foundation:` facade:

```elixir
client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN"),
    foundation: [
      integration_key: {:my_app, :notion, :prod},
      rate_limit: [registry: MyApp.NotionRateLimits],
      circuit_breaker: [registry: MyApp.NotionBreakers],
      telemetry: [metadata: %{service: :notion}]
    ]
  )
```

That configuration is implemented on top of the shared
`Pristine.Client.foundation/1` runtime profile. NotionSDK keeps only the
provider-specific classifier and grouping logic.

## Make a first request

Fetch the bot user tied to the current token:

```elixir
case NotionSDK.Users.get_self(client) do
  {:ok, user} ->
    user

  {:error, %NotionSDK.Error{} = error} ->
    raise Exception.message(error)
end
```

Search the workspace:

```elixir
{:ok, result} =
  NotionSDK.Search.search(client, %{
    "query" => "Roadmap",
    "page_size" => 10
  })

result["results"]
```

## Main namespaces

The top-level API surface is organized by Notion resource:

- `NotionSDK.Pages`
- `NotionSDK.Blocks`
- `NotionSDK.DataSources`
- `NotionSDK.Databases`
- `NotionSDK.FileUploads`
- `NotionSDK.Comments`
- `NotionSDK.Users`
- `NotionSDK.OAuth`
- `NotionSDK.Search`

The supporting utilities live in:

- `NotionSDK.Client`
- `NotionSDK.Pagination`
- `NotionSDK.Helpers`
- `NotionSDK.Guards`
- `NotionSDK.Error`

## Where to go next

- Read `guides/client-configuration.md` for all client options and production runtime wiring
- Read `guides/low-level-requests.md` when you need a custom path before a generated wrapper exists
- Read `guides/versioning-and-compatibility.md` before changing the `Notion-Version` header
- Read `guides/capabilities-permissions-and-sharing.md` before debugging `403 restricted_resource` failures
- Use the workflow guides for pages, blocks, data sources, uploads, comments, and users
- Use `examples/README.md` when you want live proofs against a real Notion workspace
