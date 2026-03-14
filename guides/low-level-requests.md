# Low-Level Requests

`NotionSDK.Client.request/2` is the custom-request escape hatch for
application code. It accepts the public raw request spec only.

## The raw request shape

The simplified request shape is:

```elixir
%{
  method: :get | :post | :patch | :delete,
  path: "/v1/...",
  path_params: %{},
  query: %{},
  body: nil | %{},
  form_data: nil | %{},
  headers: %{},
  auth: nil | false | [] | "token" | %{client_id: "...", client_secret: "..."},
  request_schema: nil | term(),
  response_schema: nil | term()
}
```

All of these requests still execute through the shared `pristine` runtime. That
means they inherit:

- path and path-parameter traversal validation
- the client's default `Notion-Version` and `User-Agent` headers
- the client's configured retry, telemetry, and transport adapters
- Notion-specific resource, retry-group, and circuit-breaker inference when you omit those fields

This user-facing escape hatch is still implemented on top of
`Pristine.execute_request/3` and the `Pristine.SDK.*` boundary.

On non-OAuth paths, raw requests also use the client's configured bearer auth
unless you override or disable it. OAuth control paths do not inherit bearer
auth automatically; provide Basic credentials explicitly or use the
`NotionSDK.OAuth.*` helpers.

## JSON body example

```elixir
{:ok, result} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/search",
    path_params: %{},
    query: %{},
    body: %{"query" => "Roadmap"},
    form_data: nil,
    headers: %{}
  })
```

## Query params and custom headers

```elixir
{:ok, comments} =
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

## Request-scoped auth overrides

Use `auth: false` or `auth: []` to strip inherited bearer auth:

```elixir
{:ok, response} =
  NotionSDK.Client.request(client, %{
    method: :get,
    path: "/v1/users/me",
    path_params: %{},
    query: %{},
    body: nil,
    form_data: nil,
    headers: %{},
    auth: false
  })
```

Use Basic auth credentials for OAuth control endpoints:

```elixir
{:ok, response} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/oauth/introspect",
    path_params: %{},
    query: %{},
    body: %{"token" => refresh_token},
    form_data: nil,
    headers: %{},
    auth: %{
      client_id: System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
      client_secret: System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET")
    }
  })
```

## Multipart form data

The raw request shape also supports multipart uploads:

```elixir
{:ok, response} =
  NotionSDK.Client.request(client, %{
    method: :post,
    path: "/v1/file_uploads/{file_upload_id}/send",
    path_params: %{"file_upload_id" => upload_id},
    query: %{},
    body: nil,
    form_data: %{
      "part_number" => "1",
      "file" => %{
        "filename" => "roadmap.pdf",
        "data" => File.read!("roadmap.pdf"),
        "content_type" => "application/pdf"
      }
    },
    headers: %{}
  })
```

## Typed schema refs

When the client has `typed_responses: true` or the request sets
`typed_responses: true`, you can supply schema refs directly:

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
    query: %{},
    body: nil,
    form_data: nil,
    headers: %{},
    response_schema: {NotionSDK.PageObjectResponse, :t}
  })
```

You can also validate request payloads before the transport runs:

```elixir
{:error, %NotionSDK.Error{code: :validation}} =
  NotionSDK.Client.request(typed_client, %{
    method: :post,
    path: "/v1/file_uploads",
    path_params: %{},
    query: %{},
    body: %{
      "filename" => "test.txt",
      "content_type" => "text/plain",
      "mode" => "not-a-real-mode"
    },
    form_data: nil,
    headers: %{},
    request_schema: {NotionSDK.FileUploads, :create_json_req}
  })
```

## Internal generated requests

Generated endpoint modules use an internal generated-request helper. That
helper is part of the generated/runtime boundary, not the manual request API
for application code.

## Related guides

- `client-configuration.md` for client-wide defaults and runtime options
- `errors-retries-and-observability.md` for retry and error behavior
- `oauth-and-auth-overrides.md` for auth rules around bearer and Basic flows
