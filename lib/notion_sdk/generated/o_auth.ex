defmodule NotionSDK.OAuth do
  @moduledoc """
  Provides API endpoints related to o auth

  ## Operations

    * Introspect a token
    * Revoke a token
    * Exchange an authorization code for an access and refresh token
  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime
  use Pristine.SDK.OpenAPI.Operation

  alias Pristine.SDK.OAuth2, as: OAuth2

  @oauth_client_opts [
    :base_url,
    :finch,
    :foundation,
    :log_level,
    :logger,
    :notion_version,
    :retry,
    :timeout_ms,
    :transport,
    :transport_opts,
    :typed_responses,
    :user_agent
  ]
  @spec provider() :: OAuth2.Provider.t()
  def provider do
    OAuth2.Provider.new(
      name: "notion",
      flow: :authorization_code,
      site: "https://api.notion.com",
      authorize_url: "/v1/oauth/authorize",
      token_url: "/v1/oauth/token",
      revocation_url: "/v1/oauth/revoke",
      introspection_url: "/v1/oauth/introspect",
      client_auth_method: :basic,
      token_method: :post,
      token_content_type: "application/json"
    )
  end

  @spec authorization_request(keyword()) ::
          {:ok, OAuth2.AuthorizationRequest.t()} | {:error, OAuth2.Error.t()}
  def authorization_request(opts \\ []) when is_list(opts) do
    with {:ok, authorization_opts} <- authorization_opts(opts) do
      OAuth2.authorization_request(provider(), authorization_opts)
    end
  end

  @spec authorize_url(keyword()) :: {:ok, String.t()} | {:error, OAuth2.Error.t()}
  def authorize_url(opts \\ []) when is_list(opts) do
    with {:ok, authorization_opts} <- authorization_opts(opts) do
      OAuth2.authorize_url(provider(), authorization_opts)
    end
  end

  @spec exchange_code(String.t(), keyword()) ::
          {:ok, OAuth2.Token.t()} | {:error, OAuth2.Error.t()}
  def exchange_code(code, opts \\ []) when is_binary(code) and is_list(opts) do
    OAuth2.exchange_code(provider(), code, oauth_runtime_opts(opts))
  end

  @spec refresh_token(String.t(), keyword()) ::
          {:ok, OAuth2.Token.t()} | {:error, OAuth2.Error.t()}
  def refresh_token(refresh_token, opts \\ []) when is_binary(refresh_token) and is_list(opts) do
    OAuth2.refresh_token(provider(), refresh_token, oauth_runtime_opts(opts))
  end

  defp authorization_opts(opts) do
    params =
      opts
      |> Keyword.get(:params, [])
      |> normalize_keyword()
      |> maybe_put_owner(Keyword.get(opts, :owner))

    case Keyword.get(opts, :redirect_uri) do
      redirect_uri when is_binary(redirect_uri) and redirect_uri != "" ->
        {:ok, opts |> Keyword.put(:params, params) |> Keyword.put(:redirect_uri, redirect_uri)}

      _other ->
        {:error, OAuth2.Error.new(:missing_redirect_uri, provider: provider().name)}
    end
  end

  defp oauth_runtime_opts(opts) do
    client = Keyword.get(opts, :client) || NotionSDK.Client.new(client_opts(opts))

    token_params =
      []
      |> maybe_put(:external_account, Keyword.get(opts, :external_account))
      |> Keyword.merge(opts |> Keyword.get(:token_params, []) |> normalize_keyword())

    []
    |> Keyword.put(:context, client.context)
    |> maybe_put(:client_id, Keyword.get(opts, :client_id))
    |> maybe_put(:client_secret, Keyword.get(opts, :client_secret))
    |> maybe_put(:redirect_uri, Keyword.get(opts, :redirect_uri))
    |> maybe_put(:token_params, token_params)
  end

  defp client_opts(opts) do
    Keyword.take(opts, @oauth_client_opts)
  end

  defp maybe_put_owner(params, value) when is_binary(value) and value != "" do
    Keyword.put(params, :owner, value)
  end

  defp maybe_put_owner(params, _value) do
    Keyword.put_new(params, :owner, "user")
  end

  defp maybe_put(opts, _key, nil) do
    opts
  end

  defp maybe_put(opts, _key, []) do
    opts
  end

  defp maybe_put(opts, key, value) do
    Keyword.put(opts, key, value)
  end

  defp normalize_keyword(value) when is_list(value) do
    value
  end

  defp normalize_keyword(value) when is_map(value) do
    Enum.into(value, [])
  end

  defp normalize_keyword(_value) do
    []
  end

  @type introspect_200_json_resp :: %{
          active: boolean,
          iat: integer | nil,
          request_id: String.t() | nil,
          scope: String.t() | nil
        }

  @doc """
  Introspect a token

  ## Source Context
  Introspect a token
  Get a token's active status, scope, and issued time.

  ### Resources

    * [Introspect a token](https://developers.notion.com/reference/introspect-token)

  ## Request Body
  **Content Types**: `application/json`

  ## Responses

    * `200` (application/json)
    * `400` (application/json)
    * `401` (application/json)
    * `403` (application/json)
    * `500` (application/json)

  ## Security

    * `basicAuth`

  ## Resources

    * [Introspect a token](https://developers.notion.com/reference/introspect-token)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client()

  const response = await notion.oauth.introspect({
    client_id: process.env.OAUTH_CLIENT_ID,
    client_secret: process.env.OAUTH_CLIENT_SECRET,
    token: "access_token_to_introspect"
  })
  ```
  """
  @spec introspect(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.OAuth.introspect_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec introspect(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.OAuth.introspect_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def introspect(client, params \\ %{}) when is_map(params) do
    partition =
      partition(NotionSDK.Client.drop_oauth_credentials(params), %{
        auth: {"auth", :auth},
        body: %{keys: [{"token", :token}], mode: :keys},
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.OAuth, :introspect},
      path_template: "/v1/oauth/introspect",
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: NotionSDK.Client.oauth_request_auth(params),
      security: [%{"basicAuth" => []}],
      request: [{"application/json", {NotionSDK.OAuth, :introspect_json_req}}],
      response: [
        {200, {NotionSDK.OAuth, :introspect_200_json_resp}},
        {400, {NotionSDK.ErrorOauth400, :t}},
        {401, {NotionSDK.ErrorOauth401, :t}},
        {403, {NotionSDK.ErrorOauth403, :t}},
        {500, {NotionSDK.ErrorOauth500, :t}}
      ],
      resource: "oauth_control",
      retry: "notion.oauth_control",
      circuit_breaker: "oauth_control",
      rate_limit: "notion.integration"
    })
  end

  @type revoke_200_json_resp :: %{request_id: String.t() | nil}

  @doc """
  Revoke a token

  ## Source Context
  Revoke a token
  Revoke an access token.

  ### Resources

    * [Revoke a token](https://developers.notion.com/reference/revoke-token)

  ## Request Body
  **Content Types**: `application/json`

  ## Responses

    * `200` (application/json)
    * `400` (application/json)
    * `401` (application/json)
    * `403` (application/json)
    * `500` (application/json)

  ## Security

    * `basicAuth`

  ## Resources

    * [Revoke a token](https://developers.notion.com/reference/revoke-token)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client()

  const response = await notion.oauth.revoke({
    client_id: process.env.OAUTH_CLIENT_ID,
    client_secret: process.env.OAUTH_CLIENT_SECRET,
    token: "access_token_to_revoke"
  })
  ```
  """
  @spec revoke(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.OAuth.revoke_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec revoke(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.OAuth.revoke_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def revoke(client, params \\ %{}) when is_map(params) do
    partition =
      partition(NotionSDK.Client.drop_oauth_credentials(params), %{
        auth: {"auth", :auth},
        body: %{keys: [{"token", :token}], mode: :keys},
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.OAuth, :revoke},
      path_template: "/v1/oauth/revoke",
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: NotionSDK.Client.oauth_request_auth(params),
      security: [%{"basicAuth" => []}],
      request: [{"application/json", {NotionSDK.OAuth, :revoke_json_req}}],
      response: [
        {200, {NotionSDK.OAuth, :revoke_200_json_resp}},
        {400, {NotionSDK.ErrorOauth400, :t}},
        {401, {NotionSDK.ErrorOauth401, :t}},
        {403, {NotionSDK.ErrorOauth403, :t}},
        {500, {NotionSDK.ErrorOauth500, :t}}
      ],
      resource: "oauth_control",
      retry: "notion.oauth_control",
      circuit_breaker: "oauth_control",
      rate_limit: "notion.integration"
    })
  end

  @type token_200_json_resp :: %{
          access_token: String.t(),
          bot_id: String.t(),
          duplicated_template_id: String.t() | nil,
          owner: NotionSDK.User.t() | NotionSDK.Workspace.t(),
          refresh_token: String.t() | nil,
          request_id: String.t() | nil,
          token_type: String.t(),
          workspace_icon: String.t() | nil,
          workspace_id: String.t(),
          workspace_name: String.t() | nil
        }

  @doc """
  Exchange an authorization code for an access and refresh token

  ## Source Context
  Create a token
  ### Warnings

  Redirect URI requirements for public integrations

  The `redirect_uri` is a *required* field in the request body for this endpoint if:
  In most cases, the `redirect_uri` field is required.
  This field is not allowed in the request body if:
  Learn more in the public integration section of the [Authorization Guide](https://developers.notion.com/guides/get-started/authorization#public-integration-auth-flow-set-up).
  *Note: Each Public API endpoint can return several possible error codes. To see a full description of each type of error code, see the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation.*

    * the `redirect_uri` query parameter was set in the [Authorization URL](https://developers.notion.com/guides/get-started/authorization#step-1-navigate-the-user-to-the-integrations-authorization-url) provided to users, *or*;
    * there are more than one `redirect_uri`s included in the [integration's settings](https://www.notion.so/profile/integrations) under **OAuth Domain & URIs**.
    * there is one `redirect_uri` included in the [integration's settings](https://www.notion.so/profile/integrations) under **OAuth Domain & URIs**, *and* the `redirect_uri` query parameter was not included in the Authorization URL.

  ### Notes

  For step-by-step instructions on how to use this endpoint to create a public integration, check out the [Authorization guide](https://developers.notion.com/guides/get-started/authorization#set-up-the-auth-flow-for-a-public-integration). To walkthrough how to create tokens for Link Previews, refer to the [Link Previews guide](https://developers.notion.com/guides/link-previews/build-a-link-preview-integration).

  ### Resources

    * [Authorization guide](https://developers.notion.com/guides/get-started/authorization#set-up-the-auth-flow-for-a-public-integration)
    * [Link Previews guide](https://developers.notion.com/guides/link-previews/build-a-link-preview-integration)
    * [Authorization URL](https://developers.notion.com/guides/get-started/authorization#step-1-navigate-the-user-to-the-integrations-authorization-url)
    * [integration's settings](https://www.notion.so/profile/integrations)
    * [Authorization Guide](https://developers.notion.com/guides/get-started/authorization#public-integration-auth-flow-set-up)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Create a token](https://developers.notion.com/reference/create-a-token)

  ## Request Body
  **Content Types**: `application/json`

  ## Responses

    * `200` (application/json)
    * `400` (application/json)
    * `401` (application/json)
    * `403` (application/json)
    * `500` (application/json)

  ## Security

    * `basicAuth`

  ## Resources

    * [Create a token](https://developers.notion.com/reference/create-a-token)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client()

  const response = await notion.oauth.token({
    client_id: process.env.OAUTH_CLIENT_ID,
    client_secret: process.env.OAUTH_CLIENT_SECRET,
    grant_type: "authorization_code",
    code: "abc123-authorization-code",
    redirect_uri: "https://example.com/callback"
  })
  ```
  """
  @spec token(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.OAuth.token_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec token(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.OAuth.token_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def token(client, params \\ %{}) when is_map(params) do
    partition =
      partition(NotionSDK.Client.drop_oauth_credentials(params), %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"code", :code},
            {"external_account", :external_account},
            {"grant_type", :grant_type},
            {"redirect_uri", :redirect_uri},
            {"refresh_token", :refresh_token}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.OAuth, :token},
      path_template: "/v1/oauth/token",
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: NotionSDK.Client.oauth_request_auth(params),
      security: [%{"basicAuth" => []}],
      request: [{"application/json", {NotionSDK.OAuth, :token_json_req}}],
      response: [
        {200, {NotionSDK.OAuth, :token_200_json_resp}},
        {400, {NotionSDK.ErrorOauth400, :t}},
        {401, {NotionSDK.ErrorOauth401, :t}},
        {403, {NotionSDK.ErrorOauth403, :t}},
        {500, {NotionSDK.ErrorOauth500, :t}}
      ],
      resource: "oauth_control",
      retry: "notion.oauth_control",
      circuit_breaker: "oauth_control",
      rate_limit: "notion.integration"
    })
  end

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :introspect_200_json_resp)

  def __fields__(:introspect_200_json_resp) do
    [active: :boolean, iat: :integer, request_id: {:string, "uuid"}, scope: :string]
  end

  def __fields__(:introspect_json_req) do
    [token: :string]
  end

  def __fields__(:revoke_200_json_resp) do
    [request_id: {:string, "uuid"}]
  end

  def __fields__(:revoke_json_req) do
    [token: :string]
  end

  def __fields__(:token_200_json_resp) do
    [
      access_token: :string,
      bot_id: {:string, "uuid"},
      duplicated_template_id: {:union, [:null, string: "uuid"]},
      owner: {:union, [{NotionSDK.User, :t}, {NotionSDK.Workspace, :t}]},
      refresh_token: {:union, [:null, :string]},
      request_id: {:string, "uuid"},
      token_type: {:const, "bearer"},
      workspace_icon: {:union, [:null, :string]},
      workspace_id: {:string, "uuid"},
      workspace_name: {:union, [:null, :string]}
    ]
  end

  def __fields__(:token_json_req) do
    [
      code: :string,
      external_account: {NotionSDK.OAuth, :token_json_req_external_account},
      grant_type: {:enum, ["authorization_code", "refresh_token"]},
      redirect_uri: :string,
      refresh_token: :string
    ]
  end

  def __fields__(:token_json_req_external_account) do
    [key: :string, name: :string]
  end

  (
    @doc false
    @spec __openapi_fields__(atom) :: [map()]
  )

  def __openapi_fields__(type \\ :introspect_200_json_resp)

  def __openapi_fields__(:introspect_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "active",
        nullable: false,
        read_only: false,
        required: true,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "iat",
        nullable: false,
        read_only: false,
        required: false,
        type: :integer,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "request_id",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "uuid"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "scope",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:introspect_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "token",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:revoke_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "request_id",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "uuid"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:revoke_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "token",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:token_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "access_token",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "bot_id",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "uuid"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "duplicated_template_id",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, string: "uuid"]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "owner",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [{NotionSDK.User, :t}, {NotionSDK.Workspace, :t}]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "refresh_token",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "request_id",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "uuid"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "token_type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "bearer"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "workspace_icon",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "workspace_id",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "uuid"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "workspace_name",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:token_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "code",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "external_account",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.OAuth, :token_json_req_external_account},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "grant_type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:enum, ["authorization_code", "refresh_token"]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "redirect_uri",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "refresh_token",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:token_json_req_external_account) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "key",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "name",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  (
    @doc false
    @spec __schema__(atom) :: Sinter.Schema.t()
  )

  def __schema__(type \\ :introspect_200_json_resp)

  def __schema__(:introspect_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:introspect_200_json_resp))
  end

  def __schema__(:introspect_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:introspect_json_req))
  end

  def __schema__(:revoke_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:revoke_200_json_resp))
  end

  def __schema__(:revoke_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:revoke_json_req))
  end

  def __schema__(:token_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:token_200_json_resp))
  end

  def __schema__(:token_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:token_json_req))
  end

  def __schema__(:token_json_req_external_account) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:token_json_req_external_account))
  end

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :introspect_200_json_resp)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
