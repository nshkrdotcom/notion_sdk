# Client Configuration

`NotionSDK.Client` is a thin Notion-specific facade over the bounded
`pristine` family surface. It selects Notion defaults for headers, retry
groups, transport options, and per-request auth overrides, while the lower
unary HTTP lane stays inside `pristine` and its Execution Plane-backed
transport substrate. Most applications only need one client per Notion
integration token.

Related guides: `getting-started.md`, `low-level-requests.md`, `versioning-and-compatibility.md`, `errors-retries-and-observability.md`, `oauth-and-auth-overrides.md`.

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
- `governed_authority`: authority-materialized governed mode for externally
  selected credentials, target, workspace, base URL, and redaction policy
- `foundation`: curated Foundation-backed production runtime settings

The generic transport, retry, telemetry, and path-validation behavior behind
these options comes from `pristine`. `notion_sdk` keeps the Notion-specific
classifier, retry groups, breaker grouping, and default headers locally.
It depends on `Pristine.foundation_context/1`,
`Pristine.execute_request/3`, `Pristine.SDK.OpenAPI.Client`, and
`Pristine.OAuth2`, not broad runtime
internals.

## Governed Authority

Use `governed_authority:` only when an external authority has already selected
the Notion credential, lease, target, workspace, base URL, and materialized
credential headers:

```elixir
authority =
  NotionSDK.GovernedAuthority.new!(
    base_url: "https://api.notion.com",
    base_url_ref: "base-url://tenant-1/notion/api",
    authority_ref: "authority://tenant-1/notion/workspace-123",
    tenant_ref: "tenant://tenant-1",
    provider_account_ref: "provider-account://tenant-1/notion/workspace-123",
    connector_instance_ref: "connector-instance://tenant-1/notion/default",
    credential_handle_ref: "credential-handle://tenant-1/notion/workspace-123/bearer",
    credential_lease_ref: "credential-lease://tenant-1/notion/workspace-123/bearer",
    target_ref: "target://tenant-1/notion/http",
    request_scope_ref: "request-scope://tenant-1/notion/users/me",
    operation_policy_ref: "operation-policy://tenant-1/notion/read",
    workspace_ref: "workspace://tenant-1/notion/workspace-123",
    header_policy_ref: "header-policy://tenant-1/notion/default",
    redaction_ref: "redaction://tenant-1/notion/default",
    materialization_kind: "bearer",
    materialization_ref: "materialization://tenant-1/notion/users/me",
    bearer_token_ref: "bearer-token://tenant-1/notion/workspace-123",
    headers: %{"X-Governed-Workspace" => "workspace-123"},
    credential_headers: %{"Authorization" => "[REDACTED_BY_AUTHORITY]"},
    allowed_header_names: [
      "authorization",
      "notion-version",
      "user-agent",
      "x-governed-workspace"
    ]
  )

client = NotionSDK.Client.new(governed_authority: authority)
```

Governed mode is intentionally not a convenience wrapper around env or local
files. When `governed_authority:` is present, the client rejects `auth:`,
`base_url:`, `oauth2:`, saved-token file sources, generated and raw
request-level auth overrides, OAuth client credential overrides, direct auth
headers, and app-env base URL defaults. The underlying `Pristine` context uses
the authority value for base URL, non-secret provider headers, and credential
headers.

Direct bearer tokens, `oauth2:` token sources, `mix notion.oauth`, XDG/default
saved token paths, `NOTION_OAUTH_*`, and request-scoped auth overrides remain
supported only for standalone SDK usage where no governed authority is supplied.

## Foundation-backed production runtime

Use `foundation:` when you want shared rate-limit learning, circuit breaking,
structured telemetry, or Dispatch-based admission control:

```elixir
client =
  NotionSDK.Client.new(
    auth: token,
    foundation: [
      integration_key: {:my_app, :notion, :prod},
      rate_limit: [registry: MyApp.NotionRateLimits],
      circuit_breaker: [registry: MyApp.NotionBreakers],
      telemetry: [
        events: %{request_stop: [:notion_sdk, :request, :stop]},
        metadata: %{service: :notion}
      ],
      dispatch: [enabled: true, dispatch: MyApp.ApiDispatch]
    ]
  )
```

This is a provider-specific facade over the shared
`Pristine.foundation_context/1` runtime builder. NotionSDK adds Notion-specific
classification, retry groups, breaker naming, and integration-key behavior on
top of that generic Pristine profile.

Supported `foundation:` keys:

- `integration_key`: stable integration identity used for shared Notion controls
- `rate_limit`: `false` or keyword options for `Pristine.Adapters.RateLimit.BackoffWindow`
- `circuit_breaker`: `false` or keyword options for `Pristine.Adapters.CircuitBreaker.Foundation`
- `telemetry`: `false` or keyword options for `Pristine.Adapters.Telemetry.Foundation`
- `dispatch`: `false` or keyword options for `Pristine.Adapters.AdmissionControl.Dispatch`
- `pool_base` and `pool_manager`: optional pool-routing inputs for the underlying `pristine` runtime

Telemetry defaults to the `[:notion_sdk, ...]` namespace unless you override it
explicitly under `foundation: [telemetry: ...]`.

Notion-specific defaults:

- rate-limit scope is per integration, not per endpoint
- generated request maps carry stable `resource`, retry group, breaker group, and rate-limit metadata
- low-level ad hoc requests still fall back to client inference when those runtime fields are omitted
- breaker groups default to `core_api`, `file_upload_send`, and `oauth_control`
- default retry groups are `notion.read`, `notion.delete`, `notion.write`, `notion.file_upload_send`, and `notion.oauth_control`

`integration_key` should usually be explicit. When shared rate limiting is
enabled with a static bearer token, the client can derive a safe fallback key
from a token hash, but it never emits the raw token in telemetry.

`dispatch` is optional and expects a started `Foundation.Dispatch` process in
`dispatch: [dispatch: server_handle]`. Pids and registered `GenServer.server()`
handles both work. The SDK wires that process into the generic
admission-control seam; lifecycle ownership stays in your application.

If you enable `dispatch`, you must provide the `:dispatch` server handle. The
client raises on missing explicit dispatch config instead of silently falling
back to noop behavior.

Foundation registries and dispatch processes are node-local. If several nodes
share one Notion integration, route that integration through one node or add a
distributed coordination layer.

### Exporting telemetry

The recommended exporter path is normal `:telemetry` handlers attached to the
events emitted by the client runtime:

```elixir
:telemetry.attach_many(
  "my-app-notion-events",
  [
    [:notion_sdk, :request, :start],
    [:notion_sdk, :request, :stop],
    [:notion_sdk, :request, :exception]
  ],
  &MyApp.NotionTelemetry.handle_event/4,
  %{}
)
```

If you need a supervised consumer, supervise your own handler process and
attach from there.

## Explicit OAuth-backed bearer auth

Bearer-authenticated Notion API endpoints and OAuth control endpoints do not share the same auth scheme. To keep that distinction explicit, `NotionSDK.Client.new/1` accepts a narrow `oauth2:` option:

```elixir
client =
  NotionSDK.Client.new(
    oauth2: [
      token_source:
        {Pristine.Adapters.TokenSource.Static,
         token: Pristine.OAuth2.Token.from_map(%{access_token: "secret_..."})},
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

These app-env defaults are standalone configuration only. They do not select
the base URL, token source, workspace, or credential material for governed
clients.

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

Use the current keys only: `:max_retries`, `:initial_retry_delay_ms`, and
`:max_retry_delay_ms`. Legacy aliases are rejected so retry configuration stays
unambiguous across the public and generated layers.

Disable retries entirely with:

```elixir
client = NotionSDK.Client.new(auth: token, retry: false)
```

The retry option still controls retry count and backoff. The actual decision to
retry is Notion-specific and comes from the endpoint's retry group:

- `429` retries for all request groups
- `408`/`500`/`502`/`503`/`504` retry for `notion.read`, `notion.delete`, and `notion.file_upload_send`
- `409` retries only for `file_uploads.send`

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

These overrides are partitioned into a request spec and passed through
`Pristine.execute_request/3` instead of mutating the client context, so bearer
overrides, Basic overrides, and `auth: false` / `auth: []` all stay
request-scoped.

Governed clients reject these overrides. A governed request can only use the
credential headers carried by `NotionSDK.GovernedAuthority`.

Remove the client's default auth from one request with `false` or `[]`:

```elixir
NotionSDK.Client.request(client, %{
  method: :get,
  path: "/v1/users",
  path_params: %{},
  query: %{},
  body: nil,
  form_data: nil,
  auth: false
})
```

## Low-level requests

`NotionSDK.Client.request/2` is the escape hatch when you need to hit a path
before a generated wrapper exists or when you want to attach custom headers.

End users should prefer the simplified raw request shape:

```elixir
{:ok, response} =
  NotionSDK.Client.request(client, %{
    method: :get,
    path: "/v1/comments",
    path_params: %{},
    query: %{"page_size" => 25},
    body: nil,
    form_data: nil,
    headers: %{"X-Debug-Request" => "true"}
  })
```

The generated modules still use a richer internal request shape, but that is
not the recommended user-facing contract anymore.

See `low-level-requests.md` for auth overrides, typed schema refs, and the full
request-spec walkthrough.

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
