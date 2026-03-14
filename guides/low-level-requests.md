# Low-Level Requests

`NotionSDK.Client.request/2` is the public escape hatch when you need a path
before a generated wrapper exists, when you want to send the exact body shape
yourself, or when you need request-scoped headers or auth behavior.

Only `method` and `path` are required. Every other field is optional.

## The public raw request shape

The minimal request is:

```elixir
%{
  method: :get | :post | :patch | :delete,
  path: "/v1/..."
}
```

You can also supply these optional fields when you need them:

- `path_params`
- `query`
- `body`
- `form_data`
- `headers`
- `auth`
- `security`
- `request_schema`
- `response_schema`
- `typed_responses`
- `id`
- `resource`
- `retry`
- `rate_limit`
- `circuit_breaker`
- `telemetry`
- `timeout`
- `retry_opts`

If you omit `path_params`, `query`, `body`, `form_data`, or `headers`, the
client normalizes them for you.

All raw requests still execute through the shared `pristine` runtime. That
means they keep:

- path and path-parameter traversal validation
- the client's default `Notion-Version` and `User-Agent` headers
- the client's configured transport, retry, telemetry, and Foundation adapters
- Notion-specific resource, retry-group, rate-limit, and circuit-breaker inference when you omit those fields

This escape hatch is still implemented on top of `Pristine.execute_request/3`
and the `Pristine.SDK.*` boundary.

On non-OAuth paths, raw requests inherit the client's bearer auth unless you
override or disable it. OAuth control paths do not inherit bearer auth
automatically.

## Sparse JSON requests

You do not need to build the full request map when the defaults are fine:

```elixir
{:ok, result} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/search",
    body: %{"query" => "Roadmap"}
  })
```

This is also the shape used by the live examples for comment creation, because
it lets the full body pass through unchanged:

```elixir
{:ok, comment} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/comments",
    body: %{
      "parent" => %{"page_id" => page_id},
      "rich_text" => [%{"text" => %{"content" => "Created from a raw request"}}]
    }
  })
```

## Query params and custom headers

```elixir
{:ok, comments} =
  NotionSDK.Client.request(client, %{
    method: :get,
    path: "/v1/comments",
    query: %{"page_size" => 25},
    headers: %{"X-Debug-Request" => "true"}
  })
```

## Request-scoped auth overrides

Use `auth: false` or `auth: []` to strip inherited bearer auth:

```elixir
{:ok, response} =
  NotionSDK.Client.request(client, %{
    method: :get,
    path: "/v1/users/me",
    auth: false
  })
```

Use a different bearer token for one call:

```elixir
{:ok, me} =
  NotionSDK.Client.request(client, %{
    method: :get,
    path: "/v1/users/me",
    auth: System.fetch_env!("SECONDARY_NOTION_TOKEN")
  })
```

Use Basic credentials for OAuth control endpoints:

```elixir
{:ok, response} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/oauth/introspect",
    body: %{"token" => refresh_token},
    auth: %{
      client_id: System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
      client_secret: System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET")
    }
  })
```

## Multipart form data

Raw requests also support multipart upload bodies:

```elixir
{:ok, response} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/file_uploads/{file_upload_id}/send",
    path_params: %{"file_upload_id" => upload_id},
    form_data: %{
      "part_number" => "1",
      "file" => %{
        "filename" => "roadmap.pdf",
        "data" => File.read!("roadmap.pdf"),
        "content_type" => "application/pdf"
      }
    }
  })
```

## Typed validation and materialization

When the client has `typed_responses: true`, or when the raw request sets
`typed_responses: true`, you can supply schema refs directly.

Materialize a typed response:

```elixir
typed_client =
  NotionSDK.Client.new(
    auth: System.fetch_env!("NOTION_TOKEN"),
    typed_responses: true
  )

{:ok, %NotionSDK.PageObjectResponse{} = page} =
  NotionSDK.Client.request(typed_client, %{
    method: :get,
    path: "/v1/pages/{page_id}",
    path_params: %{"page_id" => page_id},
    response_schema: {NotionSDK.PageObjectResponse, :t}
  })
```

Validate a request body before the transport runs:

```elixir
{:error, %NotionSDK.Error{code: :validation}} =
  NotionSDK.Client.request(typed_client, %{
    method: :post,
    path: "/v1/file_uploads",
    body: %{
      "filename" => "test.txt",
      "content_type" => "text/plain",
      "mode" => "not-a-real-mode"
    },
    request_schema: {NotionSDK.FileUploads, :create_json_req}
  })
```

## Advanced runtime overrides

Most callers should let the client infer runtime metadata, but raw requests can
override it explicitly when necessary:

- `security` to replace the default auth-scheme inference
- `id` to force a stable request identifier
- `resource`, `retry`, `rate_limit`, `circuit_breaker`, and `telemetry` to override Foundation metadata
- `timeout` to override the client's default timeout for one request
- `retry_opts` to pass retry execution options through to `Pristine.execute_request/3`

If you do not set these fields, `NotionSDK.Client` infers them from the path
and method in the same way it does for generated wrappers.

## Internal generated requests

Generated endpoint modules use a different internal request shape. That shape is
part of the generated/runtime boundary, not the public manual-request API, and
`NotionSDK.Client.request/2` rejects it.

## Related guides

- `client-configuration.md` for client-wide defaults and Foundation runtime wiring
- `oauth-and-auth-overrides.md` for bearer, Basic, and OAuth-backed token-source flows
- `errors-retries-and-observability.md` for retry and validation behavior
