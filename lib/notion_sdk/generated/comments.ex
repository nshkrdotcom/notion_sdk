defmodule NotionSDK.Comments do
  @moduledoc """
  Generated Notion Sdk operations module `NotionSDK.Comments`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  alias Pristine.SDK.OpenAPI.Client, as: OpenAPIClient

  @create_partition_spec %{
    path: [],
    auth: {"auth", :auth},
    body: %{
      keys: [
        {"attachments", :attachments},
        {"display_name", :display_name},
        {"rich_text", :rich_text}
      ],
      mode: :keys
    },
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Create comment
       ## Source Context
       ### Notes

       Reminder: Turn on integration comment capabilities

       Integration capabilities for reading and inserting comments are off by default.
       This endpoint requires an integration to have insert comment capabilities. Attempting to call this endpoint without insert comment capabilities will return an HTTP response with a 403 status code.
       For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities). To update your integration settings, visit the [integration dashboard](https://www.notion.so/profile/integrations).

       ### Errors

       Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

       ### Resources

       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [capabilities guide](https://developers.notion.com/reference/capabilities)
       * [integration dashboard](https://www.notion.so/profile/integrations)
       * [Create comment](https://developers.notion.com/reference/create-a-comment)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.comments.create({
       parent: { page_id: "b55c9c91-384d-452b-81db-d1ef79372b75" },
       rich_text: [{ text: { content: "This is a comment" } }]
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec create(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def create(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_create_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  defp build_create_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @create_partition_spec)

    %{
      id: "comments/create",
      args: params,
      call: {__MODULE__, :create},
      opts: opts,
      method: :post,
      path_template: "/v1/comments",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.Comments, :create_json_req},
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.CommentObjectResponse, :t}, {NotionSDK.PartialCommentObjectResponse, :t}]},
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
      retry: "notion.write",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :comments, :create],
      timeout: nil,
      pagination: nil
    }
  end

  @list_partition_spec %{
    path: [],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [
      {"block_id", :block_id},
      {"start_cursor", :start_cursor},
      {"page_size", :page_size}
    ],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       List comments
       ## Source Context
       Retrieves a list of un-resolved [Comment objects](https://developers.notion.com/reference/comment-object) from a page or block.

       ### Notes

       Reminder: Turn on integration comment capabilities

       Integration capabilities for reading and inserting comments are off by default.
       This endpoint requires an integration to have read comment capabilities. Attempting to call this endpoint without read comment capabilities will return an HTTP response with a 403 status code.
       For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities). To update your integration settings, visit the [integration dashboard](https://www.notion.so/profile/integrations).

       ### Errors

       Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

       ### Resources

       * [Comment objects](https://developers.notion.com/reference/comment-object)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [capabilities guide](https://developers.notion.com/reference/capabilities)
       * [integration dashboard](https://www.notion.so/profile/integrations)
       * [List comments](https://developers.notion.com/reference/list-comments)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.comments.list({
       block_id: "b55c9c91-384d-452b-81db-d1ef79372b75",
       start_cursor: undefined,
       page_size: 50
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
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
      id: "comments/list",
      args: params,
      call: {__MODULE__, :list},
      opts: opts,
      method: :get,
      path_template: "/v1/comments",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.Comments, :list_200_json_resp},
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
      telemetry: [:notion_sdk, :comments, :list],
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
    path: [{"comment_id", :comment_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Retrieve a comment
       ## Source Context
       Retrieves a [Comment object](https://developers.notion.com/reference/comment-object) from its `comment_id`.

       ### Notes

       Reminder: Turn on integration comment capabilities

       Integration capabilities for reading and inserting comments are off by default.
       This endpoint requires an integration to have read comment capabilities. Attempting to call this endpoint without read comment capabilities will return an HTTP response with a 403 status code.
       For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities). To update your integration settings, visit the [integration dashboard](https://www.notion.so/profile/integrations).

       ### Errors

       Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

       ### Resources

       * [Comment object](https://developers.notion.com/reference/comment-object)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [capabilities guide](https://developers.notion.com/reference/capabilities)
       * [integration dashboard](https://www.notion.so/profile/integrations)
       * [Retrieve a comment](https://developers.notion.com/reference/retrieve-comment)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.comments.retrieve({
       comment_id: "c02fc1d3-db8b-45c5-a222-27595b15aea7"
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
      id: "comments/retrieve",
      args: params,
      call: {__MODULE__, :retrieve},
      opts: opts,
      method: :get,
      path_template: "/v1/comments/{comment_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.CommentObjectResponse, :t}, {NotionSDK.PartialCommentObjectResponse, :t}]},
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
      telemetry: [:notion_sdk, :comments, :retrieve],
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
  def __fields__(type \\ :create_json_req)

  def __fields__(:create_json_req) do
    [
      attachments: {:array, {NotionSDK.Comments, :create_json_req_attachments}},
      display_name:
        {:union, [{NotionSDK.Custom, :t}, {NotionSDK.Integration, :t}, {NotionSDK.User, :t}]},
      rich_text: {:array, {NotionSDK.RichTextItemRequest, :t}}
    ]
  end

  def __fields__(:create_json_req_attachments) do
    [
      file_upload_id: :string,
      type: {:const, "file_upload"}
    ]
  end

  def __fields__(:list_200_json_resp) do
    [
      comment: {NotionSDK.EmptyObject, :t},
      has_more: :boolean,
      next_cursor: {:union, [:null, string: "uuid"]},
      object: {:const, "list"},
      results: {:array, {NotionSDK.CommentObjectResponse, :t}},
      type: {:const, "comment"}
    ]
  end

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
  def __openapi_fields__(type \\ :create_json_req)

  def __openapi_fields__(:create_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "An array of files to attach to the comment. Maximum of 3 allowed.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "attachments",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.Comments, :create_json_req_attachments}},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Display name for the comment.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "display_name",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union, [{NotionSDK.Custom, :t}, {NotionSDK.Integration, :t}, {NotionSDK.User, :t}]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "An array of rich text objects that represent the content of the comment.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "rich_text",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:create_json_req_attachments) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "ID of a FileUpload object that has the status `uploaded`.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "file_upload_id",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `file_upload`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "file_upload"},
        write_only: false
      }
    ]
  end

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
        name: "comment",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.EmptyObject, :t},
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
        type: {:union, [:null, string: "uuid"]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `list`",
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
        type: {:array, {NotionSDK.CommentObjectResponse, :t}},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `comment`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "comment"},
        write_only: false
      }
    ]
  end

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :create_json_req) when is_atom(type) do
    RuntimeSchema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :create_json_req)

  def decode(data, type) when is_map(data) and is_atom(type) do
    RuntimeSchema.decode_module_type(__MODULE__, type, data)
  end
end
