# OAuth and Auth Overrides

Normal Notion API calls use bearer auth. OAuth token exchange and token
lifecycle operations use Basic auth credentials instead. `NotionSDK` supports
both without forcing you to create separate client types.

For most public integrations, use the redirect URI already registered under the
integration's `OAuth Domain & URIs` settings and let the CLI guide you through
the browser step:

```bash
export NOTION_OAUTH_CLIENT_ID="..."
export NOTION_OAUTH_CLIENT_SECRET="..."
export NOTION_OAUTH_REDIRECT_URI="https://your-app.example.com/notion/callback"

mix notion.oauth --save --manual --no-browser
```

`NOTION_OAUTH_REDIRECT_URI` is the redirect URI, also called the callback URL.
If Notion shows an `Authorization URL`, use the exact decoded value from its
`redirect_uri=...` parameter.

That flow prints the authorization URL, waits for you to approve access, then
asks you to paste back the final redirected URL containing the temporary
authorization code.

Important distinctions:

- the Notion `Authorization URL` is the consent URL for OAuth
- the Notion `Webhook URL` field is unrelated to OAuth
- `NOTION_OAUTH_TOKEN_PATH` is only an optional override for where the saved
  token JSON lives on your machine

If you explicitly register a literal loopback redirect URI such as
`http://127.0.0.1:40071/callback`, you can use automatic callback capture:

```bash
export NOTION_OAUTH_REDIRECT_URI="http://127.0.0.1:40071/callback"
mix notion.oauth --save
```

When you add `--save`, `notion_sdk` stores the token JSON at
`~/.config/notion_sdk/oauth/notion.json` by default, or under
`$XDG_CONFIG_HOME/notion_sdk/oauth/notion.json` when `XDG_CONFIG_HOME` is set.
Use `--path=...` to override the save location.
Use `mix notion.oauth refresh` to explicitly refresh that saved file in place.
The command preserves a rotated refresh token when Notion returns one.

## Generate authorization URLs programmatically

Use the high-level helper layer when onboarding a public integration:

```elixir
{:ok, request} =
  NotionSDK.OAuth.authorization_request(
    client_id: System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    redirect_uri: "https://example.com/callback",
    generate_state: true
  )

request.url
```

The current Notion OAuth docs require `redirect_uri` and `owner: "user"` on the
authorization URL. `NotionSDK.OAuth.authorization_request/1` defaults
`owner=user` and fails clearly if `redirect_uri` is missing. `pristine`
supports PKCE generically, but the current Notion docs do not document PKCE
support, so the Notion examples here omit it.

Exchange the returned authorization code programmatically:

```elixir
{:ok, token} =
  NotionSDK.OAuth.exchange_code("code-from-callback",
    client_id: System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    client_secret: System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET"),
    redirect_uri: "https://example.com/callback"
  )
```

`NOTION_OAUTH_ACCESS_TOKEN` is an example input after that exchange step. It is
not shown on the Notion integration settings page. `NOTION_OAUTH_TOKEN_PATH` is
only an optional override for the saved token file path.
Notion's OAuth docs do not expose expiry metadata you can rely on for
transparent pre-expiry refresh, so `notion_sdk` keeps refresh explicit instead
of claiming automatic refresh inside bearer-authenticated API calls.

## Use an unauthenticated client for raw token endpoints

You can create a client without a bearer token when you only need OAuth endpoints:

```elixir
client = NotionSDK.Client.new()
```

Exchange an authorization code for an access token:

```elixir
{:ok, token_response} =
  NotionSDK.OAuth.token(client, %{
    "client_id" => System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    "client_secret" => System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET"),
    "code" => code,
    "grant_type" => "authorization_code",
    "redirect_uri" => redirect_uri
  })
```

The SDK strips `client_id` and `client_secret` from the JSON body and sends them as HTTP Basic auth credentials.

These raw wrappers remain available when you need the full Notion token response payload. For onboarding flows, prefer the high-level helpers above.

## Refresh or revoke tokens

For the saved-file workflow, prefer the explicit task:

```bash
mix notion.oauth refresh
```

That command loads the saved token JSON, sends a real
`grant_type=refresh_token` request through `Pristine.OAuth2`, and writes any
rotated refresh token back to disk before you reuse the file for bearer auth.

Refresh flows use the same endpoint with a different grant type:

```elixir
{:ok, refreshed_token} =
  NotionSDK.OAuth.token(client, %{
    "client_id" => System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    "client_secret" => System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET"),
    "grant_type" => "refresh_token",
    "refresh_token" => refresh_token
  })
```

Revoke a token:

```elixir
{:ok, revoke_response} =
  NotionSDK.OAuth.revoke(client, %{
    "client_id" => System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    "client_secret" => System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET"),
    "token" => refresh_token
  })
```

Introspect a token:

```elixir
{:ok, introspection} =
  NotionSDK.OAuth.introspect(client, %{
    "client_id" => System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
    "client_secret" => System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET"),
    "token" => refresh_token
  })
```

## Use the explicit `"auth"` override

If you already have a bearer-authenticated client, you can still send Basic auth per request:

```elixir
{:ok, introspection} =
  NotionSDK.OAuth.introspect(client, %{
    "auth" => %{
      "client_id" => System.fetch_env!("NOTION_OAUTH_CLIENT_ID"),
      "client_secret" => System.fetch_env!("NOTION_OAUTH_CLIENT_SECRET")
    },
    "token" => refresh_token
  })
```

You can also override bearer auth with another token:

```elixir
{:ok, other_user} =
  NotionSDK.Users.get_self(client, %{
    "auth" => System.fetch_env!("SECONDARY_NOTION_TOKEN")
  })
```

## Opt into OAuth-backed bearer auth explicitly

If you want normal bearer-authenticated API endpoints to read access tokens from a token source, opt in at the client level:

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

That opt-in is scheme-scoped. `bearerAuth` endpoints can use the token source, while `basicAuth` OAuth control endpoints still require explicit Basic credentials or helper calls such as `NotionSDK.OAuth.exchange_code/2`.

For persisted storage from `mix notion.oauth --save`, point the client at the
generic file token source:

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

Set `NOTION_OAUTH_TOKEN_PATH` only if you want to override that default save
location.

Because Notion does not publish expiry metadata in the OAuth token response, do
not assume `Pristine.Adapters.TokenSource.Refreshable` can transparently
pre-refresh these saved Notion tokens. Refresh them explicitly, then reuse the
saved file.

## Disable inherited bearer auth

For one-off low-level requests, pass `auth: false` or `auth: []` to remove the client's default auth entirely:

```elixir
NotionSDK.Client.request(client, %{
  call: {MyApp.Notion, :probe},
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

This is mostly useful for testing or for endpoints whose auth behavior you want to control manually.

The top-level `"client_id"` / `"client_secret"` request sugar is specific to Notion OAuth endpoints. The SDK still supports it, but the behavior stays in `NotionSDK.OAuth.*` instead of the generic `Pristine` runtime.
