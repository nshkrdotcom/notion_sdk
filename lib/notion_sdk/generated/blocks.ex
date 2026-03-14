defmodule NotionSDK.Blocks do
  @moduledoc """
  Provides API endpoints related to blocks

  ## Operations

    * get `/v1/blocks/{block_id}`
    * delete `/v1/blocks/{block_id}`
    * patch `/v1/blocks/{block_id}`
    * get `/v1/blocks/{block_id}/children`
    * patch `/v1/blocks/{block_id}/children`
  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  use Pristine.OpenAPI.Operation

  @type append_children_200_json_resp :: %{
          block: NotionSDK.EmptyObject.t(),
          has_more: boolean,
          next_cursor: String.t() | nil,
          object: String.t(),
          results: [map | NotionSDK.PartialBlockObjectResponse.t()],
          type: String.t()
        }

  @doc """
  patch `/v1/blocks/{block_id}/children`

  ## Source Context
  Append block children
  Creates and appends new children blocks to the parent `block_id` specified. Blocks can be parented by other blocks, pages, or databases.

  ### Warnings

  Deprecated parameter

  The `after` parameter is deprecated. Use the `position` parameter instead, which provides more flexibility including inserting at the start of the children list.
  If you're currently using `after`, migrate to `position` with type `after_block`:
  You cannot specify both `after` and `position` in the same request.

    * **Before:** `{ "children": [...], "after": "<block_id>" }`
    * **After:** `{ "children": [...], "position": { "type": "after_block", "after_block": { "id": "<block_id>" } } }`

  ### Notes

  Integration capabilities

  This endpoint requires an integration to have insert content capabilities. Attempting to call this API without insert content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Controlling insert position

  By default, blocks are appended to the end of the parent block's children. Use the `position` parameter to insert blocks at a specific location:
  | Position type                                                      | Description                                                   |
  | ------------------------------------------------------------------ | ------------------------------------------------------------- |
  | `{ "type": "end" }`                                                | Insert at the end of the parent's children (default behavior) |
  | `{ "type": "start" }`                                              | Insert at the beginning of the parent's children              |
  | `{ "type": "after_block", "after_block": { "id": "<block_id>" } }` | Insert after the specified block                              |
  <CodeGroup>
  ```json Insert at start theme={null}
  {
  "children": [/* blocks */],
  "position": { "type": "start" }
  }
  ```
  ```json Insert after specific block theme={null}
  {
  "children": [/* blocks */],
  "position": {
  "type": "after_block",
  "after_block": { "id": "12345678-1234-1234-1234-123456789abc" }
  }
  }
  ```
  </CodeGroup>

  ### Errors

  Returns a 404 HTTP response if the block specified by `id` doesn't exist, or if the integration doesn't have access to the block.
  Returns a 400 or 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
  *Note: Each Public API endpoint can return several possible error codes. To see a full description of each type of error code, see the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation.*

  ### Resources

    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [request limits](https://developers.notion.com/reference/request-limits)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Append block children](https://developers.notion.com/reference/patch-block-children)

  ## Request Body
  **Content Types**: `application/json`

  ## Security

    * `bearerAuth`

  ## Resources

    * [Append block children](https://developers.notion.com/reference/patch-block-children)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.blocks.children.append({
    block_id: "c02fc1d3-db8b-45c5-a222-27595b15aea7",
    children: [
      {
        type: "paragraph",
        paragraph: {
          rich_text: [{ text: { content: "Hello, world!" } }]
        }
      }
    ]
  })
  ```
  """
  @spec append_children(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.Blocks.append_children_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec append_children(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.Blocks.append_children_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def append_children(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{keys: [{"children", :children}, {"position", :position}], mode: :keys},
        form_data: %{mode: :none},
        path: [{"block_id", :block_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :append_children},
      path_template: "/v1/blocks/{block_id}/children",
      url: render_path("/v1/blocks/{block_id}/children", partition.path_params),
      method: :patch,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"application/json", {NotionSDK.Blocks, :append_children_json_req}}],
      response: [
        {200, {NotionSDK.Blocks, :append_children_200_json_resp}},
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

  @doc """
  delete `/v1/blocks/{block_id}`

  ## Source Context
  Delete a block
  ### Notes

  Integration capabilities

  This endpoint requires an integration to have update content capabilities. Attempting to call this API without update content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Errors

  Returns a 404 HTTP response if the block doesn't exist, or if the integration doesn't have access to the block.
  Returns a 400 or 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
  *Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information*

  ### Resources

    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [request limits](https://developers.notion.com/reference/request-limits)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Delete a block](https://developers.notion.com/reference/delete-a-block)

  ## Security

    * `bearerAuth`

  ## Resources

    * [Delete a block](https://developers.notion.com/reference/delete-a-block)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.blocks.delete({
    block_id: "c02fc1d3-db8b-45c5-a222-27595b15aea7"
  })
  ```
  """
  @spec delete(client :: NotionSDK.Client.t()) ::
          {:ok, map | NotionSDK.PartialBlockObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec delete(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, map | NotionSDK.PartialBlockObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def delete(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"block_id", :block_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :delete},
      path_template: "/v1/blocks/{block_id}",
      url: render_path("/v1/blocks/{block_id}", partition.path_params),
      method: :delete,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {:union, [{NotionSDK.PartialBlockObjectResponse, :t}, :map]}},
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
      retry: "notion.delete",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @type list_children_200_json_resp :: %{
          block: NotionSDK.EmptyObject.t(),
          has_more: boolean,
          next_cursor: String.t() | nil,
          object: String.t(),
          results: [map | NotionSDK.PartialBlockObjectResponse.t()],
          type: String.t()
        }

  @doc """
  get `/v1/blocks/{block_id}/children`

  ## Source Context
  Retrieve block children
  Returns a paginated array of child [block objects](https://developers.notion.com/reference/block) contained in the block using the ID specified. In order to receive a complete representation of a block, you may need to recursively retrieve the block children of child blocks.

  ### Notes

  Integration capabilities

  This endpoint requires an integration to have read content capabilities. Attempting to call this API without read content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Errors

  Returns a 404 HTTP response if the block specified by `id` doesn't exist, or if the integration doesn't have access to the block.
  Returns a 400 or 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
  *Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*

  ### Resources

    * [block objects](https://developers.notion.com/reference/block)
    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [request limits](https://developers.notion.com/reference/request-limits)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Retrieve block children](https://developers.notion.com/reference/get-block-children)

  ## Options

    * `start_cursor`
    * `page_size`

  ## Security

    * `bearerAuth`

  ## Resources

    * [Retrieve block children](https://developers.notion.com/reference/get-block-children)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.blocks.children.list({
    block_id: "c02fc1d3-db8b-45c5-a222-27595b15aea7",
    start_cursor: undefined,
    page_size: 50
  })
  ```
  """
  @spec list_children(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.Blocks.list_children_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec list_children(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.Blocks.list_children_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def list_children(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"block_id", :block_id}],
        query: [{"start_cursor", :start_cursor}, {"page_size", :page_size}]
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :list_children},
      path_template: "/v1/blocks/{block_id}/children",
      url: render_path("/v1/blocks/{block_id}/children", partition.path_params),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {NotionSDK.Blocks, :list_children_200_json_resp}},
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
  get `/v1/blocks/{block_id}`

  ## Source Context
  Retrieve a block
  Retrieves a [Block object](https://developers.notion.com/reference/block) using the ID specified.

  ### Notes

  Integration capabilities

  This endpoint requires an integration to have read content capabilities. Attempting to call this API without read content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Errors

  Returns a 404 HTTP response if the block doesn't exist, or if the integration doesn't have access to the block.
  Returns a 400 or 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
  *Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*

  ### Resources

    * [Block object](https://developers.notion.com/reference/block)
    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [request limits](https://developers.notion.com/reference/request-limits)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Retrieve a block](https://developers.notion.com/reference/retrieve-a-block)

  ## Security

    * `bearerAuth`

  ## Resources

    * [Retrieve a block](https://developers.notion.com/reference/retrieve-a-block)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.blocks.retrieve({
    block_id: "c02fc1d3-db8b-45c5-a222-27595b15aea7"
  })
  ```
  """
  @spec retrieve(client :: NotionSDK.Client.t()) ::
          {:ok, map | NotionSDK.PartialBlockObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec retrieve(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, map | NotionSDK.PartialBlockObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def retrieve(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"block_id", :block_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :retrieve},
      path_template: "/v1/blocks/{block_id}",
      url: render_path("/v1/blocks/{block_id}", partition.path_params),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {:union, [{NotionSDK.PartialBlockObjectResponse, :t}, :map]}},
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
  patch `/v1/blocks/{block_id}`

  ## Source Context
  Update a block
  ### Notes

  Updating `child_page` blocks

  To update `child_page` type blocks, use the [Update page](https://developers.notion.com/reference/patch-page) endpoint. Updating the page's `title` updates the text displayed in the associated `child_page` block.

  Updating `child_database` blocks

  To update `child_database` type blocks, use the [Update database](https://developers.notion.com/reference/update-a-database) endpoint. Updating the page's `title` updates the text displayed in the associated `child_database` block.

  Updating `children`

  A block's children *CANNOT* be directly updated with this endpoint. Instead use [Append block children](https://developers.notion.com/reference/patch-block-children) to add children.

  Integration capabilities

  This endpoint requires an integration to have update content capabilities. Attempting to call this API without update content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Success

  Returns a 200 HTTP response containing the updated [block object](https://developers.notion.com/reference/block) on success.

  ### Errors

  Returns a 404 HTTP response if the block doesn't exist, is in the trash, or if the integration doesn't have access to the page.
  Returns a 400 if the `type` for the block is incorrect or the input is incorrect for a given field.
  Returns a 400 or a 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
  *Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*

  ### Resources

    * [Update page](https://developers.notion.com/reference/patch-page)
    * [Update database](https://developers.notion.com/reference/update-a-database)
    * [Append block children](https://developers.notion.com/reference/patch-block-children)
    * [block object](https://developers.notion.com/reference/block)
    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [request limits](https://developers.notion.com/reference/request-limits)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Update a block](https://developers.notion.com/reference/update-a-block)

  ## Request Body
  **Content Types**: `application/json`

  ## Security

    * `bearerAuth`

  ## Resources

    * [Update a block](https://developers.notion.com/reference/update-a-block)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.blocks.update({
    block_id: "c02fc1d3-db8b-45c5-a222-27595b15aea7",
    paragraph: {
      rich_text: [{ text: { content: "Updated paragraph text" } }]
    }
  })
  ```
  """
  @spec update(client :: NotionSDK.Client.t()) ::
          {:ok, map | NotionSDK.PartialBlockObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec update(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, map | NotionSDK.PartialBlockObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def update(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{keys: [{"in_trash", :in_trash}], mode: :keys},
        form_data: %{mode: :none},
        path: [{"block_id", :block_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :update},
      path_template: "/v1/blocks/{block_id}",
      url: render_path("/v1/blocks/{block_id}", partition.path_params),
      method: :patch,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"application/json", {:union, [{NotionSDK.Blocks, :update_json_req}, :map]}}],
      response: [
        {200, {:union, [{NotionSDK.PartialBlockObjectResponse, :t}, :map]}},
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

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :append_children_200_json_resp)

  def __fields__(:append_children_200_json_resp) do
    [
      block: {NotionSDK.EmptyObject, :t},
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      results: [union: [{NotionSDK.PartialBlockObjectResponse, :t}, :map]],
      type: {:const, "block"}
    ]
  end

  def __fields__(:append_children_json_req) do
    [
      children: [
        union: [
          {NotionSDK.Embed, :t},
          {NotionSDK.Bookmark, :t},
          {NotionSDK.Image, :t},
          {NotionSDK.Video, :t},
          {NotionSDK.Pdf, :t},
          {NotionSDK.File, :t},
          {NotionSDK.Audio, :t},
          {NotionSDK.Code, :t},
          {NotionSDK.Equation, :t},
          {NotionSDK.Divider, :t},
          {NotionSDK.Breadcrumb, :t},
          {NotionSDK.TableOfContents, :t},
          {NotionSDK.LinkToPage, :t},
          {NotionSDK.TableRow, :t},
          {NotionSDK.Table, :t},
          {NotionSDK.ColumnList, :t},
          {NotionSDK.Column, :t},
          {NotionSDK.Heading1, :t},
          {NotionSDK.Heading2, :t},
          {NotionSDK.Heading3, :t},
          {NotionSDK.Paragraph, :t},
          {NotionSDK.BulletedListItem, :t},
          {NotionSDK.NumberedListItem, :t},
          {NotionSDK.Quote, :t},
          {NotionSDK.ToDo, :t},
          {NotionSDK.Toggle, :t},
          {NotionSDK.Template, :t},
          {NotionSDK.Callout, :t},
          {NotionSDK.SyncedBlock, :t}
        ]
      ],
      position: {NotionSDK.Blocks, :append_children_json_req_position}
    ]
  end

  def __fields__(:append_children_json_req_position) do
    [
      after_block: {NotionSDK.Blocks, :append_children_json_req_position_after_block},
      type: {:enum, ["after_block", "end", "start"]}
    ]
  end

  def __fields__(:append_children_json_req_position_after_block) do
    [id: :string]
  end

  def __fields__(:list_children_200_json_resp) do
    [
      block: {NotionSDK.EmptyObject, :t},
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      results: [union: [{NotionSDK.PartialBlockObjectResponse, :t}, :map]],
      type: {:const, "block"}
    ]
  end

  def __fields__(:update_json_req) do
    [in_trash: :boolean]
  end

  (
    @doc false
    @spec __openapi_fields__(atom) :: [map()]
  )

  def __openapi_fields__(type \\ :append_children_200_json_resp)

  def __openapi_fields__(:append_children_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "block",
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
        extensions: nil,
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
        extensions: nil,
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
        extensions: nil,
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
        extensions: nil,
        external_docs: nil,
        name: "results",
        nullable: false,
        read_only: false,
        required: true,
        type: [union: [{NotionSDK.PartialBlockObjectResponse, :t}, :map]],
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "block"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:append_children_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "children",
        nullable: false,
        read_only: false,
        required: true,
        type: [
          union: [
            {NotionSDK.Embed, :t},
            {NotionSDK.Bookmark, :t},
            {NotionSDK.Image, :t},
            {NotionSDK.Video, :t},
            {NotionSDK.Pdf, :t},
            {NotionSDK.File, :t},
            {NotionSDK.Audio, :t},
            {NotionSDK.Code, :t},
            {NotionSDK.Equation, :t},
            {NotionSDK.Divider, :t},
            {NotionSDK.Breadcrumb, :t},
            {NotionSDK.TableOfContents, :t},
            {NotionSDK.LinkToPage, :t},
            {NotionSDK.TableRow, :t},
            {NotionSDK.Table, :t},
            {NotionSDK.ColumnList, :t},
            {NotionSDK.Column, :t},
            {NotionSDK.Heading1, :t},
            {NotionSDK.Heading2, :t},
            {NotionSDK.Heading3, :t},
            {NotionSDK.Paragraph, :t},
            {NotionSDK.BulletedListItem, :t},
            {NotionSDK.NumberedListItem, :t},
            {NotionSDK.Quote, :t},
            {NotionSDK.ToDo, :t},
            {NotionSDK.Toggle, :t},
            {NotionSDK.Template, :t},
            {NotionSDK.Callout, :t},
            {NotionSDK.SyncedBlock, :t}
          ]
        ],
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "position",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.Blocks, :append_children_json_req_position},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:append_children_json_req_position) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "after_block",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Blocks, :append_children_json_req_position_after_block},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:enum, ["after_block", "end", "start"]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:append_children_json_req_position_after_block) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "id",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:list_children_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "block",
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
        extensions: nil,
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
        extensions: nil,
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
        extensions: nil,
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
        extensions: nil,
        external_docs: nil,
        name: "results",
        nullable: false,
        read_only: false,
        required: true,
        type: [union: [{NotionSDK.PartialBlockObjectResponse, :t}, :map]],
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "block"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "in_trash",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      }
    ]
  end

  (
    @doc false
    @spec __schema__(atom) :: Sinter.Schema.t()
  )

  def __schema__(type \\ :append_children_200_json_resp)

  def __schema__(:append_children_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:append_children_200_json_resp))
  end

  def __schema__(:append_children_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:append_children_json_req))
  end

  def __schema__(:append_children_json_req_position) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:append_children_json_req_position))
  end

  def __schema__(:append_children_json_req_position_after_block) do
    OpenAPIRuntime.build_schema(
      __openapi_fields__(:append_children_json_req_position_after_block)
    )
  end

  def __schema__(:list_children_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:list_children_200_json_resp))
  end

  def __schema__(:update_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req))
  end

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :append_children_200_json_resp)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
