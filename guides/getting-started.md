# Getting Started

`NotionSDK` is a thin Elixir client for the Notion API. The library stays close to the upstream JSON payloads, exposes the documented API namespaces as generated modules, and layers a small amount of Notion-specific behavior on top of `Pristine`.

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

Without `typed_responses: true`, success payloads remain maps for compatibility.

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

- Read the client options in `guides/client-configuration.md`
- Use the resource walkthroughs for pages, blocks, search, data sources, uploads, comments, and users
- Use the error and pagination guides before building higher-level wrappers
