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

- `429` for all HTTP methods
- `500` and `503` for `GET`
- `500` and `503` for `DELETE`

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

## Connection and validation failures

The SDK also creates `NotionSDK.Error` values for non-HTTP failures:

- transport failures become `:api_connection`
- request or response validation failures become `:validation`

You can reuse the same error handling path for both network and HTTP failures.

Successful responses still default to maps. If you enable `typed_responses: true` on the client, the same validation path is used before generated structs are materialized.

## Request correlation

When Notion returns a request ID in the body or headers, the SDK keeps it on the error struct and includes it in `Exception.message/1`. That makes operational support easier:

```elixir
{:error, %NotionSDK.Error{request_id: request_id} = error} =
  NotionSDK.Users.get_self(client)

Logger.error("notion request failed", request_id: request_id, error: Exception.message(error))
```
