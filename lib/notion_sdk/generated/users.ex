defmodule NotionSDK.Users do
  @moduledoc """
  Provides API endpoints related to users

  ## Operations

    * List all users
    * Retrieve your token's bot user
    * Retrieve a user
  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  use Pristine.OpenAPI.Operation
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @doc """
  Retrieve your token's bot user

  ## Source Context
  Retrieve your token's bot user
  Retrieves the bot [User](https://developers.notion.com/reference/user) associated with the API token provided in the authorization header. The bot will have an `owner` field with information about the person who authorized the integration.

  ### Notes

  Integration capabilities

  This endpoint is accessible from by integrations with any level of capabilities. The [user object](https://developers.notion.com/reference/user) returned will adhere to the limitations of the integration's capabilities. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Errors

  Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

  ### Resources

    * [User](https://developers.notion.com/reference/user)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [user object](https://developers.notion.com/reference/user)
    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [Retrieve your token's bot user](https://developers.notion.com/reference/get-self)

  ## Responses

    * `200` (application/json)
    * `400` (application/json)
    * `401` (application/json)
    * `403` (application/json)
    * `404` (application/json)
    * `409` (application/json)
    * `429` (application/json)
    * `500` (application/json)
    * `503` (application/json)

  ## Security

    * `bearerAuth`

  ## Resources

    * [Retrieve your token's bot user](https://developers.notion.com/reference/get-self)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.users.me()
  ```
  """
  @spec get_self(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.UserObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec get_self(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.UserObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def get_self(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Users, :get_self},
      path_template: "/v1/users/me",
      url: render_path("/v1/users/me", partition.path_params),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {NotionSDK.UserObjectResponse, :t}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ],
      resource: "core_api",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @type list_200_json_resp :: %{
          has_more: boolean,
          next_cursor: String.t() | nil,
          object: String.t(),
          results: [NotionSDK.UserObjectResponse.t()],
          type: String.t(),
          user: NotionSDK.EmptyObject.t()
        }

  @doc """
  List all users

  ## Source Context
  List all users
  Returns a paginated list of [Users](https://developers.notion.com/reference/user) for the workspace. The response may contain fewer than `page_size` of results.

  ### Notes

  The API does not currently support filtering users by their email and/or name.

  Integration capabilities

  This endpoint requires an integration to have user information capabilities. Attempting to call this API without user information capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Errors

  Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

  ### Resources

    * [Users](https://developers.notion.com/reference/user)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [List all users](https://developers.notion.com/reference/get-users)

  ## Options

    * `start_cursor`
    * `page_size`

  ## Responses

    * `200` (application/json)
    * `400` (application/json)
    * `401` (application/json)
    * `403` (application/json)
    * `404` (application/json)
    * `409` (application/json)
    * `429` (application/json)
    * `500` (application/json)
    * `503` (application/json)

  ## Security

    * `bearerAuth`

  ## Resources

    * [List all users](https://developers.notion.com/reference/get-users)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.users.list({
    start_cursor: undefined,
    page_size: 10
  })
  ```
  """
  @spec list(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.Users.list_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec list(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.Users.list_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def list(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [],
        query: [{"start_cursor", :start_cursor}, {"page_size", :page_size}]
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Users, :list},
      path_template: "/v1/users",
      url: render_path("/v1/users", partition.path_params),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {NotionSDK.Users, :list_200_json_resp}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ],
      resource: "core_api",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @doc """
  Retrieve a user

  ## Source Context
  Retrieve a user
  Retrieves a [User](https://developers.notion.com/reference/user) using the ID specified.

  ### Notes

  Integration capabilities

  This endpoint requires an integration to have user information capabilities. Attempting to call this API without user information capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Errors

  Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

  ### Resources

    * [User](https://developers.notion.com/reference/user)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [Retrieve a user](https://developers.notion.com/reference/get-user)

  ## Responses

    * `200` (application/json)
    * `400` (application/json)
    * `401` (application/json)
    * `403` (application/json)
    * `404` (application/json)
    * `409` (application/json)
    * `429` (application/json)
    * `500` (application/json)
    * `503` (application/json)

  ## Security

    * `bearerAuth`

  ## Resources

    * [Retrieve a user](https://developers.notion.com/reference/get-user)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.users.retrieve({
    user_id: "e79a0b74-3aba-4149-9f74-0bb5791a6ee6"
  })
  ```
  """
  @spec retrieve(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.UserObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec retrieve(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.UserObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def retrieve(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"user_id", :user_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Users, :retrieve},
      path_template: "/v1/users/{user_id}",
      url: render_path("/v1/users/{user_id}", partition.path_params),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {NotionSDK.UserObjectResponse, :t}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ],
      resource: "core_api",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :list_200_json_resp)

  def __fields__(:list_200_json_resp) do
    [
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      results: [{NotionSDK.UserObjectResponse, :t}],
      type: {:const, "user"},
      user: {NotionSDK.EmptyObject, :t}
    ]
  end

  (
    @doc false
    @spec __openapi_fields__(atom) :: [map()]
  )

  def __openapi_fields__(type \\ :list_200_json_resp)

  def __openapi_fields__(:list_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "has_more",
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
        name: "next_cursor",
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
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "list"},
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
        name: "results",
        nullable: false,
        read_only: false,
        required: true,
        type: [{NotionSDK.UserObjectResponse, :t}],
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
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "user"},
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
        name: "user",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.EmptyObject, :t},
        write_only: false
      }
    ]
  end

  (
    @doc false
    @spec __schema__(atom) :: Sinter.Schema.t()
  )

  def __schema__(type \\ :list_200_json_resp)

  def __schema__(:list_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:list_200_json_resp))
  end

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :list_200_json_resp)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
