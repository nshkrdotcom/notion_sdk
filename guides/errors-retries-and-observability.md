# Errors, Retries, and Observability

All endpoint wrappers return either `{:ok, response}` or `{:error, %NotionSDK.Error{}}`. The error struct preserves Notion response metadata closely enough to drive both user-facing messages and retry policy.

## Handle `%NotionSDK.Error{}`

Pattern match on the fields you care about:

```elixir
case NotionSDK.Pages.retrieve(client, %{"page_id" => page_id}) do
  {:ok, page} ->
    {:ok, page}

  {:error, %NotionSDK.Error{code: :object_not_found}} ->
    {:error, :missing_page}

  {:error, %NotionSDK.Error{code: :rate_limited, retry_after_ms: retry_after_ms}} ->
    {:retry_later, retry_after_ms}

  {:error, %NotionSDK.Error{} = error} ->
    {:error, Exception.message(error)}
end
```

The struct includes:

- `code`
- `message`
- `status`
- `request_id`
- `retry_after_ms`
- `headers`
- `body`
- `additional_data`

Use `NotionSDK.Error.retryable?/1` when you want the same coarse retryability
check the SDK uses for common caller logic:

```elixir
{:error, %NotionSDK.Error{} = error} = NotionSDK.Users.get_self(client)

if NotionSDK.Error.retryable?(error) do
  {:retry, error}
else
  {:error, error}
end
```

## Error code mapping

The SDK maps the common Notion API codes into atoms such as:

- `:unauthorized`
- `:restricted_resource`
- `:object_not_found`
- `:validation_error`
- `:rate_limited`
- `:internal_server_error`
- `:bad_gateway`
- `:service_unavailable`
- `:gateway_timeout`

If Notion omits a body code, the SDK falls back to the HTTP status code.

## Retry behavior

Retries are configured on the client, not per endpoint module. By default the SDK retries:

- `429` for all request groups
- `408`, `500`, `502`, `503`, and `504` for `notion.read`
- `408`, `500`, `502`, `503`, and `504` for `notion.delete`
- `408`, `500`, `502`, `503`, and `504` for `notion.file_upload_send`
- `409` for `notion.file_upload_send`
- transient transport failures such as Mint transport/HTTP errors and `:timeout`

The default configuration is:

```elixir
%{
  max_retries: 2,
  initial_retry_delay_ms: 1_000,
  max_retry_delay_ms: 60_000
}
```

Disable retries:

```elixir
client = NotionSDK.Client.new(auth: token, retry: false)
```

Tune retries:

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

## `Retry-After` handling

The retry adapter parses both:

- `Retry-After`
- `Retry-After-Ms`

The parsed value is copied into `%NotionSDK.Error{retry_after_ms: ...}` when available, which makes it straightforward to hand off scheduling decisions to your own job system.

When you enable the Foundation-backed rate limiter through `foundation:`, the
same classified `429` result also updates the shared backoff window for the
integration key. Concurrent callers on the same node then learn that backoff
without waiting for their own `429`.

## Connection and validation failures

The SDK also creates `NotionSDK.Error` values for non-HTTP failures:

- transport failures become `:api_connection`
- request or response validation failures become `:validation`

Only clearly transient transport failures are retried automatically. Local
errors such as `:nxdomain` still map to `:api_connection`, but they do not
blindly retry.

You can reuse the same error handling path for both network and HTTP failures.

Successful responses still default to maps. If you enable `typed_responses: true` on the client, the same validation path is used before generated structs are materialized.

## Request correlation

When Notion returns a request ID in the body or headers, the SDK keeps it on the error struct and includes it in `Exception.message/1`. That makes operational support easier:

```elixir
{:error, %NotionSDK.Error{request_id: request_id} = error} =
  NotionSDK.Users.get_self(client)

Logger.error("notion request failed", request_id: request_id, error: Exception.message(error))
```

## Foundation-backed observability and circuit health

With `foundation:` enabled on the client:

- `429` responses set shared limiter backoff and are ignored by the circuit breaker
- caller-side `4xx` responses such as `400`, `401`, `403`, `404`, `409` (outside upload send), and `422` are ignored by the circuit breaker
- `408`/`500`/`502`/`503`/`504` and transport failures count as breaker failures
- telemetry defaults to `[:notion_sdk, :request, :start|:stop|:exception]`
- telemetry metadata includes safe runtime fields such as `resource`, `retry_group`, `breaker_name`, and classified outcome metadata

Example:

```elixir
client =
  NotionSDK.Client.new(
    auth: token,
    foundation: [
      integration_key: {:my_app, :notion, :prod},
      rate_limit: [registry: MyApp.NotionRateLimits],
      circuit_breaker: [registry: MyApp.NotionBreakers],
      telemetry: [metadata: %{service: :notion}]
    ]
  )
```

If you also provide `dispatch: [enabled: true, dispatch: server_handle]`, classified
Notion backoff is forwarded into that shared `Foundation.Dispatch` process.

Foundation registries are ETS-backed and node-local. Shared backoff and breaker
state coordinate callers on one node unless you add your own cross-node layer.

To export that same telemetry stream externally, attach a reporter to the
client's Pristine context:

```elixir
{:ok, handler_id} =
  Pristine.Profiles.Foundation.attach_reporter(
    client.context,
    reporter: MyApp.NotionTelemetryReporter
  )
```

Supervise the reporter itself with
`Pristine.Profiles.Foundation.reporter_child_spec/1`.
