# Client Configuration

`NotionSDK.Client` owns transport setup, default headers, retry behavior, and per-request auth overrides. Most applications only need one client per Notion integration token.

Resource ids such as page ids, database ids, and block ids are not client configuration. Pass them to endpoint calls instead of `Client.new/1`.

## Client constructors

Use either constructor form:

```elixir
NotionSDK.Client.new(auth: token)
NotionSDK.Client.new(token, timeout_ms: 15_000)
```

Both return a `%NotionSDK.Client{}` configured with:

- bearer auth when `auth` is present
- `Notion-Version` and `User-Agent` headers
- a default Finch transport
- a retry adapter tuned for Notion's rate-limit and transient server responses

## Supported options

`NotionSDK.Client.new/1` accepts these top-level options:

- `auth`: bearer token used for normal API calls
- `base_url`: defaults to `https://api.notion.com`
- `notion_version`: defaults to `2025-09-03`
- `timeout_ms`: defaults to `60_000`
- `user_agent`: defaults to `notion-sdk-elixir/<package-version>`
- `retry`: retry config map, keyword list, or `false`
- `log_level`: request logging level passed into the underlying runtime
- `logger`: optional custom logger callback
- `transport`: custom transport module
- `transport_opts`: options passed to the transport
- `finch`: custom Finch name when using the default Finch transport
- `typed_responses`: opt in to runtime request validation and generated response structs
- `oauth2`: explicit bearer-OAuth opt-in for endpoints whose generated security metadata requires `bearerAuth`

## Explicit OAuth-backed bearer auth

Bearer-authenticated Notion API endpoints and OAuth control endpoints do not share the same auth scheme. To keep that distinction explicit, `NotionSDK.Client.new/1` accepts a narrow `oauth2:` option:

```elixir
client =
  NotionSDK.Client.new(
    oauth2: [
      token_source:
        {Pristine.Adapters.TokenSource.Static,
         token: %Pristine.OAuth2.Token{access_token: "secret_..."}},
      allow_stale?: false
    ]
  )
```

Behavior:

- bearer-authenticated API endpoints use the OAuth-backed bearer adapter
- OAuth control endpoints do not silently inherit that bearer auth
- request-level `auth` overrides still win
- if you also pass `auth: token`, that static bearer token stays on the client's `"default"` auth path rather than overriding `bearerAuth`

## Configuration through `config/*.exs`

The client pulls defaults from the application environment when explicit options are not provided:

```elixir
import Config

config :notion_sdk,
  base_url: "https://api.notion.com",
  notion_version: "2025-09-03",
  timeout_ms: 60_000,
  user_agent: "my-app/1.0.0"

config :notion_sdk, :retry,
  max_retries: 2,
  initial_retry_delay_ms: 1_000,
  max_retry_delay_ms: 60_000
```

## Retry tuning

The retry option can be a map or a keyword list:

```elixir
client =
  NotionSDK.Client.new(
    auth: token,
    retry: %{
      max_retries: 4,
      initial_retry_delay_ms: 250,
      max_retry_delay_ms: 5_000
    }
  )
```

Legacy names are normalized, so this also works:

```elixir
client =
  NotionSDK.Client.new(
    auth: token,
    retry: [
      max_attempts: 4,
      base_delay_ms: 250,
      max_delay_ms: 5_000
    ]
  )
```

Disable retries entirely with:

```elixir
client = NotionSDK.Client.new(auth: token, retry: false)
```

## Per-request auth overrides

Generated endpoint modules forward an `"auth"` or `:auth` key into the low-level request layer.

Override the bearer token for a single call:

```elixir
NotionSDK.Users.get_self(client, %{
  "auth" => System.fetch_env!("SECONDARY_NOTION_TOKEN")
})
```

Provide Basic auth credentials for OAuth endpoints:

```elixir
NotionSDK.OAuth.introspect(client, %{
  "auth" => %{
    "client_id" => System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    "client_secret" => System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET")
  },
  "token" => refresh_token
})
```

These overrides are passed through to the underlying `Pristine.execute/5` call instead of mutating the client context, so bearer overrides, Basic overrides, and `auth: false` / `auth: []` all stay request-scoped.

Remove the client's default auth from one request with `false` or `[]`:

```elixir
NotionSDK.Client.request(client, %{
  call: {MyApp.Notion, :unauthenticated_ping},
  method: :get,
  path_template: "/v1/users",
  url: "/v1/users",
  path_params: %{},
  query: %{},
  body: %{},
  form_data: %{},
  auth: false
})
```

## Low-level requests

`NotionSDK.Client.request/2` is the escape hatch when you need to hit a path before a generated wrapper exists or when you want to attach custom headers.

```elixir
{:ok, response} =
  NotionSDK.Client.request(client, %{
    call: {MyApp.Notion, :list_comments},
    method: :get,
    path_template: "/v1/comments",
    url: "/v1/comments",
    path_params: %{},
    query: %{"page_size" => 25},
    body: %{},
    form_data: %{},
    headers: %{"X-Debug-Request" => "true"}
  })
```

The required request keys are the same ones the generated modules emit: `call`, `method`, `path_template`, `url`, `path_params`, `query`, `body`, and `form_data`.

## Typed responses

Default responses stay as maps:

```elixir
client = NotionSDK.Client.new(auth: token)
```

Enable typed request/response runtime support explicitly when you want generated structs on success:

```elixir
client =
  NotionSDK.Client.new(
    auth: token,
    typed_responses: true
  )
```

With `typed_responses: true`, request payloads are validated when generated schema refs are available and successful responses are materialized into generated structs where the schema module defines one.

## Transport customization

In normal production use the default Finch transport is enough. For tests, you can swap the transport module entirely:

```elixir
client =
  NotionSDK.Client.new(
    auth: token,
    transport: MyApp.TestTransport,
    transport_opts: [test_pid: self()]
  )
```

When you stay on Finch but want a custom pool name:

```elixir
client =
  NotionSDK.Client.new(
    auth: token,
    finch: MyApp.NotionFinch
  )
```

The application starts the default `NotionSDK.Finch` process for you.
