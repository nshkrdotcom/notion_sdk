defmodule NotionSDK.Users do
  @moduledoc """
  Generated Notion Sdk operations module `NotionSDK.Users`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  alias Pristine.SDK.OpenAPI.Client, as: OpenAPIClient

  @get_self_partition_spec %{
    path: [],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc "Retrieve your token's bot user\n## Source Context\nRetrieves the bot [User](https://developers.notion.com/reference/user) associated with the API token provided in the authorization header. The bot will have an `owner` field with information about the person who authorized the integration.\n\n### Notes\n\nIntegration capabilities\n\nThis endpoint is accessible from by integrations with any level of capabilities. The [user object](https://developers.notion.com/reference/user) returned will adhere to the limitations of the integration's capabilities. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).\n\n### Errors\n\nEach Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.\n\n### Resources\n\n  * [User](https://developers.notion.com/reference/user)\n  * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)\n  * [user object](https://developers.notion.com/reference/user)\n  * [capabilities guide](https://developers.notion.com/reference/capabilities)\n  * [Retrieve your token's bot user](https://developers.notion.com/reference/get-self)\n## Code Samples\n\nTypeScript SDK\n```javascript\nimport { Client } from \"@notionhq/client\"\n\nconst notion = new Client({ auth: process.env.NOTION_API_KEY })\n\nconst response = await notion.users.me()\n```\n"
  @spec get_self(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def get_self(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_get_self_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  defp build_get_self_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @get_self_partition_spec)

    %{
      id: "users/get_self",
      args: params,
      call: {__MODULE__, :get_self},
      opts: opts,
      method: :get,
      path_template: "/v1/users/me",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.UserObjectResponse, :t},
        400 => {NotionSDK.ErrorApi400, :t},
        401 => {NotionSDK.ErrorApi401, :t},
        403 => {NotionSDK.ErrorApi403, :t},
        404 => {NotionSDK.ErrorApi404, :t},
        409 => {NotionSDK.ErrorApi409, :t},
        429 => {NotionSDK.ErrorApi429, :t},
        500 => {NotionSDK.ErrorApi500, :t},
        503 => {NotionSDK.ErrorApi503, :t}
      },
      auth: %{
        use_client_default?: true,
        override: partition.auth,
        security_schemes: ["bearerAuth"]
      },
      resource: "core_api",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :users, :get_self],
      timeout: nil,
      pagination: nil
    }
  end

  @list_partition_spec %{
    path: [],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [{"start_cursor", :start_cursor}, {"page_size", :page_size}],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc "List all users\n## Source Context\nReturns a paginated list of [Users](https://developers.notion.com/reference/user) for the workspace. The response may contain fewer than `page_size` of results.\n\n### Notes\n\nThe API does not currently support filtering users by their email and/or name.\n\nIntegration capabilities\n\nThis endpoint requires an integration to have user information capabilities. Attempting to call this API without user information capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).\n\n### Errors\n\nEach Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.\n\n### Resources\n\n  * [Users](https://developers.notion.com/reference/user)\n  * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)\n  * [capabilities guide](https://developers.notion.com/reference/capabilities)\n  * [List all users](https://developers.notion.com/reference/get-users)\n## Code Samples\n\nTypeScript SDK\n```javascript\nimport { Client } from \"@notionhq/client\"\n\nconst notion = new Client({ auth: process.env.NOTION_API_KEY })\n\nconst response = await notion.users.list({\n  start_cursor: undefined,\n  page_size: 10\n})\n```\n"
  @spec list(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def list(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_list_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  @spec stream_list(term(), map(), keyword()) :: Enumerable.t()
  def stream_list(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)

    Stream.resource(
      fn -> build_list_request(client, params, opts) end,
      fn
        nil ->
          {:halt, nil}

        request when is_map(request) ->
          wrapped_request =
            update_in(request[:opts], fn request_opts ->
              Keyword.put(request_opts || [], :response, :wrapped)
            end)

          case NotionSDK.Client.execute_generated_request(client, wrapped_request) do
            {:ok, response} ->
              items = List.wrap(OpenAPIClient.items(request, response))
              {items, OpenAPIClient.next_page_request(request, response)}

            {:error, reason} ->
              raise "pagination failed: " <> inspect(reason)
          end
      end,
      fn _state -> :ok end
    )
  end

  defp build_list_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @list_partition_spec)

    %{
      id: "users/list",
      args: params,
      call: {__MODULE__, :list},
      opts: opts,
      method: :get,
      path_template: "/v1/users",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.Users, :list_200_json_resp},
        400 => {NotionSDK.ErrorApi400, :t},
        401 => {NotionSDK.ErrorApi401, :t},
        403 => {NotionSDK.ErrorApi403, :t},
        404 => {NotionSDK.ErrorApi404, :t},
        409 => {NotionSDK.ErrorApi409, :t},
        429 => {NotionSDK.ErrorApi429, :t},
        500 => {NotionSDK.ErrorApi500, :t},
        503 => {NotionSDK.ErrorApi503, :t}
      },
      auth: %{
        use_client_default?: true,
        override: partition.auth,
        security_schemes: ["bearerAuth"]
      },
      resource: "core_api",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :users, :list],
      timeout: nil,
      pagination: %{
        default_limit: nil,
        items_path: ["results"],
        request_mapping: %{cursor_location: :query, cursor_param: "start_cursor"},
        response_mapping: %{cursor_path: ["next_cursor"]},
        strategy: :cursor
      }
    }
  end

  @retrieve_partition_spec %{
    path: [{"user_id", :user_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Retrieve a user
       ## Source Context
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
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec retrieve(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def retrieve(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_retrieve_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  defp build_retrieve_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @retrieve_partition_spec)

    %{
      id: "users/retrieve",
      args: params,
      call: {__MODULE__, :retrieve},
      opts: opts,
      method: :get,
      path_template: "/v1/users/{user_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.UserObjectResponse, :t},
        400 => {NotionSDK.ErrorApi400, :t},
        401 => {NotionSDK.ErrorApi401, :t},
        403 => {NotionSDK.ErrorApi403, :t},
        404 => {NotionSDK.ErrorApi404, :t},
        409 => {NotionSDK.ErrorApi409, :t},
        429 => {NotionSDK.ErrorApi429, :t},
        500 => {NotionSDK.ErrorApi500, :t},
        503 => {NotionSDK.ErrorApi503, :t}
      },
      auth: %{
        use_client_default?: true,
        override: partition.auth,
        security_schemes: ["bearerAuth"]
      },
      resource: "core_api",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :users, :retrieve],
      timeout: nil,
      pagination: nil
    }
  end

  @spec normalize_request_opts!(list()) :: keyword()
  defp normalize_request_opts!(opts) when is_list(opts) do
    if Keyword.keyword?(opts) do
      opts
    else
      raise ArgumentError, "request opts must be a keyword list"
    end
  end

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :list_200_json_resp)

  def __fields__(:list_200_json_resp) do
    [
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      results: {:array, {NotionSDK.UserObjectResponse, :t}},
      type: {:const, "user"},
      user: {NotionSDK.EmptyObject, :t}
    ]
  end

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
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
        type: {:array, {NotionSDK.UserObjectResponse, :t}},
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

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :list_200_json_resp) when is_atom(type) do
    RuntimeSchema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :list_200_json_resp)

  def decode(data, type) when is_map(data) and is_atom(type) do
    RuntimeSchema.decode_module_type(__MODULE__, type, data)
  end
end
