defmodule NotionSDK.Comments do
  @moduledoc """
  Provides API endpoints related to comments

  ## Operations

    * List comments
    * Create a comment
    * Retrieve a comment
  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @doc """
  Create a comment

  ## Source Context
  Create comment
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

  ## Request Body
  **Content Types**: `application/json`

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
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`

  ## Resources

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
  @spec create(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.CommentObjectResponse.t() | NotionSDK.PartialCommentObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec create(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.CommentObjectResponse.t() | NotionSDK.PartialCommentObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def create(client, params \\ %{}) when is_map(params) do
    partition =
      NotionSDK.GeneratedOperation.partition(params, %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"attachments", :attachments},
            {"display_name", :display_name},
            {"rich_text", :rich_text}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Comments, :create},
      path_template: "/v1/comments",
      url: NotionSDK.GeneratedOperation.render_path("/v1/comments", partition.path_params),
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []}
      ],
      request: [{"application/json", {NotionSDK.Comments, :create_json_req}}],
      response: [
        {200,
         {:union,
          [{NotionSDK.PartialCommentObjectResponse, :t}, {NotionSDK.CommentObjectResponse, :t}]}},
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
      retry: "notion.write",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @type list_200_json_resp :: %{
          comment: NotionSDK.EmptyObject.t(),
          has_more: boolean,
          next_cursor: String.t() | nil,
          object: String.t(),
          results: [NotionSDK.CommentObjectResponse.t()],
          type: String.t()
        }

  @doc """
  List comments

  ## Source Context
  List comments
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

  ## Options

    * `block_id`
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
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`

  ## Resources

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
  @spec list(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.Comments.list_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec list(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.Comments.list_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def list(client, params \\ %{}) when is_map(params) do
    partition =
      NotionSDK.GeneratedOperation.partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [],
        query: [
          {"block_id", :block_id},
          {"start_cursor", :start_cursor},
          {"page_size", :page_size}
        ]
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Comments, :list},
      path_template: "/v1/comments",
      url: NotionSDK.GeneratedOperation.render_path("/v1/comments", partition.path_params),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []}
      ],
      response: [
        {200, {NotionSDK.Comments, :list_200_json_resp}},
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
  Retrieve a comment

  ## Source Context
  Retrieve a comment
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
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`
    * `bearerAuth`

  ## Resources

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
  @spec retrieve(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.CommentObjectResponse.t() | NotionSDK.PartialCommentObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec retrieve(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.CommentObjectResponse.t() | NotionSDK.PartialCommentObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def retrieve(client, params \\ %{}) when is_map(params) do
    partition =
      NotionSDK.GeneratedOperation.partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"comment_id", :comment_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Comments, :retrieve},
      path_template: "/v1/comments/{comment_id}",
      url:
        NotionSDK.GeneratedOperation.render_path(
          "/v1/comments/{comment_id}",
          partition.path_params
        ),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []},
        %{"bearerAuth" => []}
      ],
      response: [
        {200,
         {:union,
          [{NotionSDK.PartialCommentObjectResponse, :t}, {NotionSDK.CommentObjectResponse, :t}]}},
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
  def __fields__(type \\ :create_json_req)

  def __fields__(:create_json_req) do
    [
      attachments: [{NotionSDK.Comments, :create_json_req_attachments}],
      display_name:
        {:union, [{NotionSDK.Integration, :t}, {NotionSDK.User, :t}, {NotionSDK.Custom, :t}]},
      rich_text: [{NotionSDK.RichTextItemRequest, :t}]
    ]
  end

  def __fields__(:create_json_req_attachments) do
    [file_upload_id: :string, type: {:const, "file_upload"}]
  end

  def __fields__(:list_200_json_resp) do
    [
      comment: {NotionSDK.EmptyObject, :t},
      has_more: :boolean,
      next_cursor: {:union, [:null, string: "uuid"]},
      object: {:const, "list"},
      results: [{NotionSDK.CommentObjectResponse, :t}],
      type: {:const, "comment"}
    ]
  end

  (
    @doc false
    @spec __openapi_fields__(atom) :: [map()]
  )

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
        type: [{NotionSDK.Comments, :create_json_req_attachments}],
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
          {:union, [{NotionSDK.Integration, :t}, {NotionSDK.User, :t}, {NotionSDK.Custom, :t}]},
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
        type: [{NotionSDK.RichTextItemRequest, :t}],
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
        type: [{NotionSDK.CommentObjectResponse, :t}],
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

  (
    @doc false
    @spec __schema__(atom) :: Sinter.Schema.t()
  )

  def __schema__(type \\ :create_json_req)

  def __schema__(:create_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:create_json_req))
  end

  def __schema__(:create_json_req_attachments) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:create_json_req_attachments))
  end

  def __schema__(:list_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:list_200_json_resp))
  end

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :create_json_req)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
