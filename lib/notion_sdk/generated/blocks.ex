defmodule NotionSDK.Blocks do
  @moduledoc """
  Provides API endpoints related to blocks

  ## Operations

    * Retrieve a block
    * Delete a block
    * Update a block
    * Retrieve block children
    * Append block children
  """
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime
  use Pristine.OpenAPI.Operation

  @type append_children_200_json_resp :: %{
          block: NotionSDK.EmptyObject.t(),
          has_more: boolean,
          next_cursor: String.t() | nil,
          object: String.t(),
          results: [
            NotionSDK.AudioBlockObjectResponse.t()
            | NotionSDK.BookmarkBlockObjectResponse.t()
            | NotionSDK.BreadcrumbBlockObjectResponse.t()
            | NotionSDK.BulletedListItemBlockObjectResponse.t()
            | NotionSDK.CalloutBlockObjectResponse.t()
            | NotionSDK.ChildDatabaseBlockObjectResponse.t()
            | NotionSDK.ChildPageBlockObjectResponse.t()
            | NotionSDK.CodeBlockObjectResponse.t()
            | NotionSDK.ColumnBlockObjectResponse.t()
            | NotionSDK.ColumnListBlockObjectResponse.t()
            | NotionSDK.DividerBlockObjectResponse.t()
            | NotionSDK.EmbedBlockObjectResponse.t()
            | NotionSDK.EquationBlockObjectResponse.t()
            | NotionSDK.FileBlockObjectResponse.t()
            | NotionSDK.Heading1BlockObjectResponse.t()
            | NotionSDK.Heading2BlockObjectResponse.t()
            | NotionSDK.Heading3BlockObjectResponse.t()
            | NotionSDK.ImageBlockObjectResponse.t()
            | NotionSDK.LinkPreviewBlockObjectResponse.t()
            | NotionSDK.LinkToPageBlockObjectResponse.t()
            | NotionSDK.MeetingNotesBlockObjectResponse.t()
            | NotionSDK.NumberedListItemBlockObjectResponse.t()
            | NotionSDK.ParagraphBlockObjectResponse.t()
            | NotionSDK.PartialBlockObjectResponse.t()
            | NotionSDK.PdfBlockObjectResponse.t()
            | NotionSDK.QuoteBlockObjectResponse.t()
            | NotionSDK.SyncedBlockBlockObjectResponse.t()
            | NotionSDK.TableBlockObjectResponse.t()
            | NotionSDK.TableOfContentsBlockObjectResponse.t()
            | NotionSDK.TableRowBlockObjectResponse.t()
            | NotionSDK.TemplateBlockObjectResponse.t()
            | NotionSDK.ToDoBlockObjectResponse.t()
            | NotionSDK.ToggleBlockObjectResponse.t()
            | NotionSDK.UnsupportedBlockObjectResponse.t()
            | NotionSDK.VideoBlockObjectResponse.t()
          ],
          type: String.t()
        }

  @doc """
  Append block children

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

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :append_children},
      path_template: "/v1/blocks/{block_id}/children",
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
  Delete a block

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
          {:ok,
           NotionSDK.AudioBlockObjectResponse.t()
           | NotionSDK.BookmarkBlockObjectResponse.t()
           | NotionSDK.BreadcrumbBlockObjectResponse.t()
           | NotionSDK.BulletedListItemBlockObjectResponse.t()
           | NotionSDK.CalloutBlockObjectResponse.t()
           | NotionSDK.ChildDatabaseBlockObjectResponse.t()
           | NotionSDK.ChildPageBlockObjectResponse.t()
           | NotionSDK.CodeBlockObjectResponse.t()
           | NotionSDK.ColumnBlockObjectResponse.t()
           | NotionSDK.ColumnListBlockObjectResponse.t()
           | NotionSDK.DividerBlockObjectResponse.t()
           | NotionSDK.EmbedBlockObjectResponse.t()
           | NotionSDK.EquationBlockObjectResponse.t()
           | NotionSDK.FileBlockObjectResponse.t()
           | NotionSDK.Heading1BlockObjectResponse.t()
           | NotionSDK.Heading2BlockObjectResponse.t()
           | NotionSDK.Heading3BlockObjectResponse.t()
           | NotionSDK.ImageBlockObjectResponse.t()
           | NotionSDK.LinkPreviewBlockObjectResponse.t()
           | NotionSDK.LinkToPageBlockObjectResponse.t()
           | NotionSDK.MeetingNotesBlockObjectResponse.t()
           | NotionSDK.NumberedListItemBlockObjectResponse.t()
           | NotionSDK.ParagraphBlockObjectResponse.t()
           | NotionSDK.PartialBlockObjectResponse.t()
           | NotionSDK.PdfBlockObjectResponse.t()
           | NotionSDK.QuoteBlockObjectResponse.t()
           | NotionSDK.SyncedBlockBlockObjectResponse.t()
           | NotionSDK.TableBlockObjectResponse.t()
           | NotionSDK.TableOfContentsBlockObjectResponse.t()
           | NotionSDK.TableRowBlockObjectResponse.t()
           | NotionSDK.TemplateBlockObjectResponse.t()
           | NotionSDK.ToDoBlockObjectResponse.t()
           | NotionSDK.ToggleBlockObjectResponse.t()
           | NotionSDK.UnsupportedBlockObjectResponse.t()
           | NotionSDK.VideoBlockObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec delete(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.AudioBlockObjectResponse.t()
           | NotionSDK.BookmarkBlockObjectResponse.t()
           | NotionSDK.BreadcrumbBlockObjectResponse.t()
           | NotionSDK.BulletedListItemBlockObjectResponse.t()
           | NotionSDK.CalloutBlockObjectResponse.t()
           | NotionSDK.ChildDatabaseBlockObjectResponse.t()
           | NotionSDK.ChildPageBlockObjectResponse.t()
           | NotionSDK.CodeBlockObjectResponse.t()
           | NotionSDK.ColumnBlockObjectResponse.t()
           | NotionSDK.ColumnListBlockObjectResponse.t()
           | NotionSDK.DividerBlockObjectResponse.t()
           | NotionSDK.EmbedBlockObjectResponse.t()
           | NotionSDK.EquationBlockObjectResponse.t()
           | NotionSDK.FileBlockObjectResponse.t()
           | NotionSDK.Heading1BlockObjectResponse.t()
           | NotionSDK.Heading2BlockObjectResponse.t()
           | NotionSDK.Heading3BlockObjectResponse.t()
           | NotionSDK.ImageBlockObjectResponse.t()
           | NotionSDK.LinkPreviewBlockObjectResponse.t()
           | NotionSDK.LinkToPageBlockObjectResponse.t()
           | NotionSDK.MeetingNotesBlockObjectResponse.t()
           | NotionSDK.NumberedListItemBlockObjectResponse.t()
           | NotionSDK.ParagraphBlockObjectResponse.t()
           | NotionSDK.PartialBlockObjectResponse.t()
           | NotionSDK.PdfBlockObjectResponse.t()
           | NotionSDK.QuoteBlockObjectResponse.t()
           | NotionSDK.SyncedBlockBlockObjectResponse.t()
           | NotionSDK.TableBlockObjectResponse.t()
           | NotionSDK.TableOfContentsBlockObjectResponse.t()
           | NotionSDK.TableRowBlockObjectResponse.t()
           | NotionSDK.TemplateBlockObjectResponse.t()
           | NotionSDK.ToDoBlockObjectResponse.t()
           | NotionSDK.ToggleBlockObjectResponse.t()
           | NotionSDK.UnsupportedBlockObjectResponse.t()
           | NotionSDK.VideoBlockObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def delete(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"block_id", :block_id}],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :delete},
      path_template: "/v1/blocks/{block_id}",
      method: :delete,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200,
         {:union,
          [
            {NotionSDK.PartialBlockObjectResponse, :t},
            {NotionSDK.ParagraphBlockObjectResponse, :t},
            {NotionSDK.Heading1BlockObjectResponse, :t},
            {NotionSDK.Heading2BlockObjectResponse, :t},
            {NotionSDK.Heading3BlockObjectResponse, :t},
            {NotionSDK.BulletedListItemBlockObjectResponse, :t},
            {NotionSDK.NumberedListItemBlockObjectResponse, :t},
            {NotionSDK.QuoteBlockObjectResponse, :t},
            {NotionSDK.ToDoBlockObjectResponse, :t},
            {NotionSDK.ToggleBlockObjectResponse, :t},
            {NotionSDK.TemplateBlockObjectResponse, :t},
            {NotionSDK.SyncedBlockBlockObjectResponse, :t},
            {NotionSDK.ChildPageBlockObjectResponse, :t},
            {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
            {NotionSDK.EquationBlockObjectResponse, :t},
            {NotionSDK.CodeBlockObjectResponse, :t},
            {NotionSDK.CalloutBlockObjectResponse, :t},
            {NotionSDK.DividerBlockObjectResponse, :t},
            {NotionSDK.BreadcrumbBlockObjectResponse, :t},
            {NotionSDK.TableOfContentsBlockObjectResponse, :t},
            {NotionSDK.ColumnListBlockObjectResponse, :t},
            {NotionSDK.ColumnBlockObjectResponse, :t},
            {NotionSDK.LinkToPageBlockObjectResponse, :t},
            {NotionSDK.TableBlockObjectResponse, :t},
            {NotionSDK.TableRowBlockObjectResponse, :t},
            {NotionSDK.MeetingNotesBlockObjectResponse, :t},
            {NotionSDK.EmbedBlockObjectResponse, :t},
            {NotionSDK.BookmarkBlockObjectResponse, :t},
            {NotionSDK.ImageBlockObjectResponse, :t},
            {NotionSDK.VideoBlockObjectResponse, :t},
            {NotionSDK.PdfBlockObjectResponse, :t},
            {NotionSDK.FileBlockObjectResponse, :t},
            {NotionSDK.AudioBlockObjectResponse, :t},
            {NotionSDK.LinkPreviewBlockObjectResponse, :t},
            {NotionSDK.UnsupportedBlockObjectResponse, :t}
          ]}},
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
          results: [
            NotionSDK.AudioBlockObjectResponse.t()
            | NotionSDK.BookmarkBlockObjectResponse.t()
            | NotionSDK.BreadcrumbBlockObjectResponse.t()
            | NotionSDK.BulletedListItemBlockObjectResponse.t()
            | NotionSDK.CalloutBlockObjectResponse.t()
            | NotionSDK.ChildDatabaseBlockObjectResponse.t()
            | NotionSDK.ChildPageBlockObjectResponse.t()
            | NotionSDK.CodeBlockObjectResponse.t()
            | NotionSDK.ColumnBlockObjectResponse.t()
            | NotionSDK.ColumnListBlockObjectResponse.t()
            | NotionSDK.DividerBlockObjectResponse.t()
            | NotionSDK.EmbedBlockObjectResponse.t()
            | NotionSDK.EquationBlockObjectResponse.t()
            | NotionSDK.FileBlockObjectResponse.t()
            | NotionSDK.Heading1BlockObjectResponse.t()
            | NotionSDK.Heading2BlockObjectResponse.t()
            | NotionSDK.Heading3BlockObjectResponse.t()
            | NotionSDK.ImageBlockObjectResponse.t()
            | NotionSDK.LinkPreviewBlockObjectResponse.t()
            | NotionSDK.LinkToPageBlockObjectResponse.t()
            | NotionSDK.MeetingNotesBlockObjectResponse.t()
            | NotionSDK.NumberedListItemBlockObjectResponse.t()
            | NotionSDK.ParagraphBlockObjectResponse.t()
            | NotionSDK.PartialBlockObjectResponse.t()
            | NotionSDK.PdfBlockObjectResponse.t()
            | NotionSDK.QuoteBlockObjectResponse.t()
            | NotionSDK.SyncedBlockBlockObjectResponse.t()
            | NotionSDK.TableBlockObjectResponse.t()
            | NotionSDK.TableOfContentsBlockObjectResponse.t()
            | NotionSDK.TableRowBlockObjectResponse.t()
            | NotionSDK.TemplateBlockObjectResponse.t()
            | NotionSDK.ToDoBlockObjectResponse.t()
            | NotionSDK.ToggleBlockObjectResponse.t()
            | NotionSDK.UnsupportedBlockObjectResponse.t()
            | NotionSDK.VideoBlockObjectResponse.t()
          ],
          type: String.t()
        }

  @doc """
  Retrieve block children

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

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :list_children},
      path_template: "/v1/blocks/{block_id}/children",
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
  Retrieve a block

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
          {:ok,
           NotionSDK.AudioBlockObjectResponse.t()
           | NotionSDK.BookmarkBlockObjectResponse.t()
           | NotionSDK.BreadcrumbBlockObjectResponse.t()
           | NotionSDK.BulletedListItemBlockObjectResponse.t()
           | NotionSDK.CalloutBlockObjectResponse.t()
           | NotionSDK.ChildDatabaseBlockObjectResponse.t()
           | NotionSDK.ChildPageBlockObjectResponse.t()
           | NotionSDK.CodeBlockObjectResponse.t()
           | NotionSDK.ColumnBlockObjectResponse.t()
           | NotionSDK.ColumnListBlockObjectResponse.t()
           | NotionSDK.DividerBlockObjectResponse.t()
           | NotionSDK.EmbedBlockObjectResponse.t()
           | NotionSDK.EquationBlockObjectResponse.t()
           | NotionSDK.FileBlockObjectResponse.t()
           | NotionSDK.Heading1BlockObjectResponse.t()
           | NotionSDK.Heading2BlockObjectResponse.t()
           | NotionSDK.Heading3BlockObjectResponse.t()
           | NotionSDK.ImageBlockObjectResponse.t()
           | NotionSDK.LinkPreviewBlockObjectResponse.t()
           | NotionSDK.LinkToPageBlockObjectResponse.t()
           | NotionSDK.MeetingNotesBlockObjectResponse.t()
           | NotionSDK.NumberedListItemBlockObjectResponse.t()
           | NotionSDK.ParagraphBlockObjectResponse.t()
           | NotionSDK.PartialBlockObjectResponse.t()
           | NotionSDK.PdfBlockObjectResponse.t()
           | NotionSDK.QuoteBlockObjectResponse.t()
           | NotionSDK.SyncedBlockBlockObjectResponse.t()
           | NotionSDK.TableBlockObjectResponse.t()
           | NotionSDK.TableOfContentsBlockObjectResponse.t()
           | NotionSDK.TableRowBlockObjectResponse.t()
           | NotionSDK.TemplateBlockObjectResponse.t()
           | NotionSDK.ToDoBlockObjectResponse.t()
           | NotionSDK.ToggleBlockObjectResponse.t()
           | NotionSDK.UnsupportedBlockObjectResponse.t()
           | NotionSDK.VideoBlockObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec retrieve(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.AudioBlockObjectResponse.t()
           | NotionSDK.BookmarkBlockObjectResponse.t()
           | NotionSDK.BreadcrumbBlockObjectResponse.t()
           | NotionSDK.BulletedListItemBlockObjectResponse.t()
           | NotionSDK.CalloutBlockObjectResponse.t()
           | NotionSDK.ChildDatabaseBlockObjectResponse.t()
           | NotionSDK.ChildPageBlockObjectResponse.t()
           | NotionSDK.CodeBlockObjectResponse.t()
           | NotionSDK.ColumnBlockObjectResponse.t()
           | NotionSDK.ColumnListBlockObjectResponse.t()
           | NotionSDK.DividerBlockObjectResponse.t()
           | NotionSDK.EmbedBlockObjectResponse.t()
           | NotionSDK.EquationBlockObjectResponse.t()
           | NotionSDK.FileBlockObjectResponse.t()
           | NotionSDK.Heading1BlockObjectResponse.t()
           | NotionSDK.Heading2BlockObjectResponse.t()
           | NotionSDK.Heading3BlockObjectResponse.t()
           | NotionSDK.ImageBlockObjectResponse.t()
           | NotionSDK.LinkPreviewBlockObjectResponse.t()
           | NotionSDK.LinkToPageBlockObjectResponse.t()
           | NotionSDK.MeetingNotesBlockObjectResponse.t()
           | NotionSDK.NumberedListItemBlockObjectResponse.t()
           | NotionSDK.ParagraphBlockObjectResponse.t()
           | NotionSDK.PartialBlockObjectResponse.t()
           | NotionSDK.PdfBlockObjectResponse.t()
           | NotionSDK.QuoteBlockObjectResponse.t()
           | NotionSDK.SyncedBlockBlockObjectResponse.t()
           | NotionSDK.TableBlockObjectResponse.t()
           | NotionSDK.TableOfContentsBlockObjectResponse.t()
           | NotionSDK.TableRowBlockObjectResponse.t()
           | NotionSDK.TemplateBlockObjectResponse.t()
           | NotionSDK.ToDoBlockObjectResponse.t()
           | NotionSDK.ToggleBlockObjectResponse.t()
           | NotionSDK.UnsupportedBlockObjectResponse.t()
           | NotionSDK.VideoBlockObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def retrieve(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"block_id", :block_id}],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :retrieve},
      path_template: "/v1/blocks/{block_id}",
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200,
         {:union,
          [
            {NotionSDK.PartialBlockObjectResponse, :t},
            {NotionSDK.ParagraphBlockObjectResponse, :t},
            {NotionSDK.Heading1BlockObjectResponse, :t},
            {NotionSDK.Heading2BlockObjectResponse, :t},
            {NotionSDK.Heading3BlockObjectResponse, :t},
            {NotionSDK.BulletedListItemBlockObjectResponse, :t},
            {NotionSDK.NumberedListItemBlockObjectResponse, :t},
            {NotionSDK.QuoteBlockObjectResponse, :t},
            {NotionSDK.ToDoBlockObjectResponse, :t},
            {NotionSDK.ToggleBlockObjectResponse, :t},
            {NotionSDK.TemplateBlockObjectResponse, :t},
            {NotionSDK.SyncedBlockBlockObjectResponse, :t},
            {NotionSDK.ChildPageBlockObjectResponse, :t},
            {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
            {NotionSDK.EquationBlockObjectResponse, :t},
            {NotionSDK.CodeBlockObjectResponse, :t},
            {NotionSDK.CalloutBlockObjectResponse, :t},
            {NotionSDK.DividerBlockObjectResponse, :t},
            {NotionSDK.BreadcrumbBlockObjectResponse, :t},
            {NotionSDK.TableOfContentsBlockObjectResponse, :t},
            {NotionSDK.ColumnListBlockObjectResponse, :t},
            {NotionSDK.ColumnBlockObjectResponse, :t},
            {NotionSDK.LinkToPageBlockObjectResponse, :t},
            {NotionSDK.TableBlockObjectResponse, :t},
            {NotionSDK.TableRowBlockObjectResponse, :t},
            {NotionSDK.MeetingNotesBlockObjectResponse, :t},
            {NotionSDK.EmbedBlockObjectResponse, :t},
            {NotionSDK.BookmarkBlockObjectResponse, :t},
            {NotionSDK.ImageBlockObjectResponse, :t},
            {NotionSDK.VideoBlockObjectResponse, :t},
            {NotionSDK.PdfBlockObjectResponse, :t},
            {NotionSDK.FileBlockObjectResponse, :t},
            {NotionSDK.AudioBlockObjectResponse, :t},
            {NotionSDK.LinkPreviewBlockObjectResponse, :t},
            {NotionSDK.UnsupportedBlockObjectResponse, :t}
          ]}},
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
  Update a block

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
          {:ok,
           NotionSDK.AudioBlockObjectResponse.t()
           | NotionSDK.BookmarkBlockObjectResponse.t()
           | NotionSDK.BreadcrumbBlockObjectResponse.t()
           | NotionSDK.BulletedListItemBlockObjectResponse.t()
           | NotionSDK.CalloutBlockObjectResponse.t()
           | NotionSDK.ChildDatabaseBlockObjectResponse.t()
           | NotionSDK.ChildPageBlockObjectResponse.t()
           | NotionSDK.CodeBlockObjectResponse.t()
           | NotionSDK.ColumnBlockObjectResponse.t()
           | NotionSDK.ColumnListBlockObjectResponse.t()
           | NotionSDK.DividerBlockObjectResponse.t()
           | NotionSDK.EmbedBlockObjectResponse.t()
           | NotionSDK.EquationBlockObjectResponse.t()
           | NotionSDK.FileBlockObjectResponse.t()
           | NotionSDK.Heading1BlockObjectResponse.t()
           | NotionSDK.Heading2BlockObjectResponse.t()
           | NotionSDK.Heading3BlockObjectResponse.t()
           | NotionSDK.ImageBlockObjectResponse.t()
           | NotionSDK.LinkPreviewBlockObjectResponse.t()
           | NotionSDK.LinkToPageBlockObjectResponse.t()
           | NotionSDK.MeetingNotesBlockObjectResponse.t()
           | NotionSDK.NumberedListItemBlockObjectResponse.t()
           | NotionSDK.ParagraphBlockObjectResponse.t()
           | NotionSDK.PartialBlockObjectResponse.t()
           | NotionSDK.PdfBlockObjectResponse.t()
           | NotionSDK.QuoteBlockObjectResponse.t()
           | NotionSDK.SyncedBlockBlockObjectResponse.t()
           | NotionSDK.TableBlockObjectResponse.t()
           | NotionSDK.TableOfContentsBlockObjectResponse.t()
           | NotionSDK.TableRowBlockObjectResponse.t()
           | NotionSDK.TemplateBlockObjectResponse.t()
           | NotionSDK.ToDoBlockObjectResponse.t()
           | NotionSDK.ToggleBlockObjectResponse.t()
           | NotionSDK.UnsupportedBlockObjectResponse.t()
           | NotionSDK.VideoBlockObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec update(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.AudioBlockObjectResponse.t()
           | NotionSDK.BookmarkBlockObjectResponse.t()
           | NotionSDK.BreadcrumbBlockObjectResponse.t()
           | NotionSDK.BulletedListItemBlockObjectResponse.t()
           | NotionSDK.CalloutBlockObjectResponse.t()
           | NotionSDK.ChildDatabaseBlockObjectResponse.t()
           | NotionSDK.ChildPageBlockObjectResponse.t()
           | NotionSDK.CodeBlockObjectResponse.t()
           | NotionSDK.ColumnBlockObjectResponse.t()
           | NotionSDK.ColumnListBlockObjectResponse.t()
           | NotionSDK.DividerBlockObjectResponse.t()
           | NotionSDK.EmbedBlockObjectResponse.t()
           | NotionSDK.EquationBlockObjectResponse.t()
           | NotionSDK.FileBlockObjectResponse.t()
           | NotionSDK.Heading1BlockObjectResponse.t()
           | NotionSDK.Heading2BlockObjectResponse.t()
           | NotionSDK.Heading3BlockObjectResponse.t()
           | NotionSDK.ImageBlockObjectResponse.t()
           | NotionSDK.LinkPreviewBlockObjectResponse.t()
           | NotionSDK.LinkToPageBlockObjectResponse.t()
           | NotionSDK.MeetingNotesBlockObjectResponse.t()
           | NotionSDK.NumberedListItemBlockObjectResponse.t()
           | NotionSDK.ParagraphBlockObjectResponse.t()
           | NotionSDK.PartialBlockObjectResponse.t()
           | NotionSDK.PdfBlockObjectResponse.t()
           | NotionSDK.QuoteBlockObjectResponse.t()
           | NotionSDK.SyncedBlockBlockObjectResponse.t()
           | NotionSDK.TableBlockObjectResponse.t()
           | NotionSDK.TableOfContentsBlockObjectResponse.t()
           | NotionSDK.TableRowBlockObjectResponse.t()
           | NotionSDK.TemplateBlockObjectResponse.t()
           | NotionSDK.ToDoBlockObjectResponse.t()
           | NotionSDK.ToggleBlockObjectResponse.t()
           | NotionSDK.UnsupportedBlockObjectResponse.t()
           | NotionSDK.VideoBlockObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def update(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"audio", :audio},
            {"bookmark", :bookmark},
            {"breadcrumb", :breadcrumb},
            {"bulleted_list_item", :bulleted_list_item},
            {"callout", :callout},
            {"code", :code},
            {"column", :column},
            {"divider", :divider},
            {"embed", :embed},
            {"equation", :equation},
            {"file", :file},
            {"heading_1", :heading_1},
            {"heading_2", :heading_2},
            {"heading_3", :heading_3},
            {"image", :image},
            {"in_trash", :in_trash},
            {"link_to_page", :link_to_page},
            {"numbered_list_item", :numbered_list_item},
            {"paragraph", :paragraph},
            {"pdf", :pdf},
            {"quote", :quote},
            {"synced_block", :synced_block},
            {"table", :table},
            {"table_of_contents", :table_of_contents},
            {"table_row", :table_row},
            {"template", :template},
            {"to_do", :to_do},
            {"toggle", :toggle},
            {"type", :type},
            {"video", :video}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [{"block_id", :block_id}],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.Blocks, :update},
      path_template: "/v1/blocks/{block_id}",
      method: :patch,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"application/json", {NotionSDK.Blocks, :update_json_req}}],
      response: [
        {200,
         {:union,
          [
            {NotionSDK.PartialBlockObjectResponse, :t},
            {NotionSDK.ParagraphBlockObjectResponse, :t},
            {NotionSDK.Heading1BlockObjectResponse, :t},
            {NotionSDK.Heading2BlockObjectResponse, :t},
            {NotionSDK.Heading3BlockObjectResponse, :t},
            {NotionSDK.BulletedListItemBlockObjectResponse, :t},
            {NotionSDK.NumberedListItemBlockObjectResponse, :t},
            {NotionSDK.QuoteBlockObjectResponse, :t},
            {NotionSDK.ToDoBlockObjectResponse, :t},
            {NotionSDK.ToggleBlockObjectResponse, :t},
            {NotionSDK.TemplateBlockObjectResponse, :t},
            {NotionSDK.SyncedBlockBlockObjectResponse, :t},
            {NotionSDK.ChildPageBlockObjectResponse, :t},
            {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
            {NotionSDK.EquationBlockObjectResponse, :t},
            {NotionSDK.CodeBlockObjectResponse, :t},
            {NotionSDK.CalloutBlockObjectResponse, :t},
            {NotionSDK.DividerBlockObjectResponse, :t},
            {NotionSDK.BreadcrumbBlockObjectResponse, :t},
            {NotionSDK.TableOfContentsBlockObjectResponse, :t},
            {NotionSDK.ColumnListBlockObjectResponse, :t},
            {NotionSDK.ColumnBlockObjectResponse, :t},
            {NotionSDK.LinkToPageBlockObjectResponse, :t},
            {NotionSDK.TableBlockObjectResponse, :t},
            {NotionSDK.TableRowBlockObjectResponse, :t},
            {NotionSDK.MeetingNotesBlockObjectResponse, :t},
            {NotionSDK.EmbedBlockObjectResponse, :t},
            {NotionSDK.BookmarkBlockObjectResponse, :t},
            {NotionSDK.ImageBlockObjectResponse, :t},
            {NotionSDK.VideoBlockObjectResponse, :t},
            {NotionSDK.PdfBlockObjectResponse, :t},
            {NotionSDK.FileBlockObjectResponse, :t},
            {NotionSDK.AudioBlockObjectResponse, :t},
            {NotionSDK.LinkPreviewBlockObjectResponse, :t},
            {NotionSDK.UnsupportedBlockObjectResponse, :t}
          ]}},
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
      results: [
        union: [
          {NotionSDK.PartialBlockObjectResponse, :t},
          {NotionSDK.ParagraphBlockObjectResponse, :t},
          {NotionSDK.Heading1BlockObjectResponse, :t},
          {NotionSDK.Heading2BlockObjectResponse, :t},
          {NotionSDK.Heading3BlockObjectResponse, :t},
          {NotionSDK.BulletedListItemBlockObjectResponse, :t},
          {NotionSDK.NumberedListItemBlockObjectResponse, :t},
          {NotionSDK.QuoteBlockObjectResponse, :t},
          {NotionSDK.ToDoBlockObjectResponse, :t},
          {NotionSDK.ToggleBlockObjectResponse, :t},
          {NotionSDK.TemplateBlockObjectResponse, :t},
          {NotionSDK.SyncedBlockBlockObjectResponse, :t},
          {NotionSDK.ChildPageBlockObjectResponse, :t},
          {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
          {NotionSDK.EquationBlockObjectResponse, :t},
          {NotionSDK.CodeBlockObjectResponse, :t},
          {NotionSDK.CalloutBlockObjectResponse, :t},
          {NotionSDK.DividerBlockObjectResponse, :t},
          {NotionSDK.BreadcrumbBlockObjectResponse, :t},
          {NotionSDK.TableOfContentsBlockObjectResponse, :t},
          {NotionSDK.ColumnListBlockObjectResponse, :t},
          {NotionSDK.ColumnBlockObjectResponse, :t},
          {NotionSDK.LinkToPageBlockObjectResponse, :t},
          {NotionSDK.TableBlockObjectResponse, :t},
          {NotionSDK.TableRowBlockObjectResponse, :t},
          {NotionSDK.MeetingNotesBlockObjectResponse, :t},
          {NotionSDK.EmbedBlockObjectResponse, :t},
          {NotionSDK.BookmarkBlockObjectResponse, :t},
          {NotionSDK.ImageBlockObjectResponse, :t},
          {NotionSDK.VideoBlockObjectResponse, :t},
          {NotionSDK.PdfBlockObjectResponse, :t},
          {NotionSDK.FileBlockObjectResponse, :t},
          {NotionSDK.AudioBlockObjectResponse, :t},
          {NotionSDK.LinkPreviewBlockObjectResponse, :t},
          {NotionSDK.UnsupportedBlockObjectResponse, :t}
        ]
      ],
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
      results: [
        union: [
          {NotionSDK.PartialBlockObjectResponse, :t},
          {NotionSDK.ParagraphBlockObjectResponse, :t},
          {NotionSDK.Heading1BlockObjectResponse, :t},
          {NotionSDK.Heading2BlockObjectResponse, :t},
          {NotionSDK.Heading3BlockObjectResponse, :t},
          {NotionSDK.BulletedListItemBlockObjectResponse, :t},
          {NotionSDK.NumberedListItemBlockObjectResponse, :t},
          {NotionSDK.QuoteBlockObjectResponse, :t},
          {NotionSDK.ToDoBlockObjectResponse, :t},
          {NotionSDK.ToggleBlockObjectResponse, :t},
          {NotionSDK.TemplateBlockObjectResponse, :t},
          {NotionSDK.SyncedBlockBlockObjectResponse, :t},
          {NotionSDK.ChildPageBlockObjectResponse, :t},
          {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
          {NotionSDK.EquationBlockObjectResponse, :t},
          {NotionSDK.CodeBlockObjectResponse, :t},
          {NotionSDK.CalloutBlockObjectResponse, :t},
          {NotionSDK.DividerBlockObjectResponse, :t},
          {NotionSDK.BreadcrumbBlockObjectResponse, :t},
          {NotionSDK.TableOfContentsBlockObjectResponse, :t},
          {NotionSDK.ColumnListBlockObjectResponse, :t},
          {NotionSDK.ColumnBlockObjectResponse, :t},
          {NotionSDK.LinkToPageBlockObjectResponse, :t},
          {NotionSDK.TableBlockObjectResponse, :t},
          {NotionSDK.TableRowBlockObjectResponse, :t},
          {NotionSDK.MeetingNotesBlockObjectResponse, :t},
          {NotionSDK.EmbedBlockObjectResponse, :t},
          {NotionSDK.BookmarkBlockObjectResponse, :t},
          {NotionSDK.ImageBlockObjectResponse, :t},
          {NotionSDK.VideoBlockObjectResponse, :t},
          {NotionSDK.PdfBlockObjectResponse, :t},
          {NotionSDK.FileBlockObjectResponse, :t},
          {NotionSDK.AudioBlockObjectResponse, :t},
          {NotionSDK.LinkPreviewBlockObjectResponse, :t},
          {NotionSDK.UnsupportedBlockObjectResponse, :t}
        ]
      ],
      type: {:const, "block"}
    ]
  end

  def __fields__(:update_json_req) do
    [
      audio: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t},
      bookmark: {NotionSDK.UpdateMediaContentWithUrlAndCaptionRequest, :t},
      breadcrumb: {NotionSDK.EmptyObject, :t},
      bulleted_list_item: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
      callout: {NotionSDK.Blocks, :update_json_req_callout},
      code: {NotionSDK.Blocks, :update_json_req_code},
      column: {NotionSDK.Blocks, :update_json_req_column},
      divider: {NotionSDK.EmptyObject, :t},
      embed: {NotionSDK.UpdateMediaContentWithUrlAndCaptionRequest, :t},
      equation: {NotionSDK.ContentWithExpressionRequest, :t},
      file: {NotionSDK.UpdateMediaContentWithFileNameAndCaptionRequest, :t},
      heading_1: {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
      heading_2: {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
      heading_3: {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
      image: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t},
      in_trash: :boolean,
      link_to_page:
        {:union, [{NotionSDK.PageId, :t}, {NotionSDK.DatabaseId, :t}, {NotionSDK.CommentId, :t}]},
      numbered_list_item: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
      paragraph: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
      pdf: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t},
      quote: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
      synced_block: {NotionSDK.Blocks, :update_json_req_synced_block},
      table: {NotionSDK.Blocks, :update_json_req_table},
      table_of_contents: {NotionSDK.Blocks, :update_json_req_table_of_contents},
      table_row: {NotionSDK.ContentWithTableRowRequest, :t},
      template: {NotionSDK.ContentWithRichTextRequest, :t},
      to_do: {NotionSDK.Blocks, :update_json_req_to_do},
      toggle: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
      type:
        {:enum,
         [
           "audio",
           "bookmark",
           "breadcrumb",
           "bulleted_list_item",
           "callout",
           "code",
           "column",
           "divider",
           "embed",
           "equation",
           "file",
           "heading_1",
           "heading_2",
           "heading_3",
           "image",
           "link_to_page",
           "numbered_list_item",
           "paragraph",
           "pdf",
           "quote",
           "synced_block",
           "table",
           "table_of_contents",
           "table_row",
           "template",
           "to_do",
           "toggle",
           "video"
         ]},
      video: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t}
    ]
  end

  def __fields__(:update_json_req_callout) do
    [
      color:
        {:enum,
         [
           "default",
           "gray",
           "brown",
           "orange",
           "yellow",
           "green",
           "blue",
           "purple",
           "pink",
           "red",
           "default_background",
           "gray_background",
           "brown_background",
           "orange_background",
           "yellow_background",
           "green_background",
           "blue_background",
           "purple_background",
           "pink_background",
           "red_background"
         ]},
      icon:
        {:union,
         [
           {NotionSDK.FileUploadPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.CustomEmojiPageIconRequest, :t}
         ]},
      rich_text: [{NotionSDK.RichTextItemRequest, :t}]
    ]
  end

  def __fields__(:update_json_req_code) do
    [
      caption: [{NotionSDK.RichTextItemRequest, :t}],
      language:
        {:enum,
         [
           "abap",
           "abc",
           "agda",
           "arduino",
           "ascii art",
           "assembly",
           "bash",
           "basic",
           "bnf",
           "c",
           "c#",
           "c++",
           "clojure",
           "coffeescript",
           "coq",
           "css",
           "dart",
           "dhall",
           "diff",
           "docker",
           "ebnf",
           "elixir",
           "elm",
           "erlang",
           "f#",
           "flow",
           "fortran",
           "gherkin",
           "glsl",
           "go",
           "graphql",
           "groovy",
           "haskell",
           "hcl",
           "html",
           "idris",
           "java",
           "javascript",
           "json",
           "julia",
           "kotlin",
           "latex",
           "less",
           "lisp",
           "livescript",
           "llvm ir",
           "lua",
           "makefile",
           "markdown",
           "markup",
           "matlab",
           "mathematica",
           "mermaid",
           "nix",
           "notion formula",
           "objective-c",
           "ocaml",
           "pascal",
           "perl",
           "php",
           "plain text",
           "powershell",
           "prolog",
           "protobuf",
           "purescript",
           "python",
           "r",
           "racket",
           "reason",
           "ruby",
           "rust",
           "sass",
           "scala",
           "scheme",
           "scss",
           "shell",
           "smalltalk",
           "solidity",
           "sql",
           "swift",
           "toml",
           "typescript",
           "vb.net",
           "verilog",
           "vhdl",
           "visual basic",
           "webassembly",
           "xml",
           "yaml",
           "java/c/c++/c#"
         ]},
      rich_text: [{NotionSDK.RichTextItemRequest, :t}]
    ]
  end

  def __fields__(:update_json_req_column) do
    [width_ratio: :number]
  end

  def __fields__(:update_json_req_synced_block) do
    [synced_from: {:union, [:null, {NotionSDK.BlockId, :t}]}]
  end

  def __fields__(:update_json_req_table) do
    [has_column_header: :boolean, has_row_header: :boolean]
  end

  def __fields__(:update_json_req_table_of_contents) do
    [
      color:
        {:enum,
         [
           "default",
           "gray",
           "brown",
           "orange",
           "yellow",
           "green",
           "blue",
           "purple",
           "pink",
           "red",
           "default_background",
           "gray_background",
           "brown_background",
           "orange_background",
           "yellow_background",
           "green_background",
           "blue_background",
           "purple_background",
           "pink_background",
           "red_background"
         ]}
    ]
  end

  def __fields__(:update_json_req_to_do) do
    [
      checked: :boolean,
      color:
        {:enum,
         [
           "default",
           "gray",
           "brown",
           "orange",
           "yellow",
           "green",
           "blue",
           "purple",
           "pink",
           "red",
           "default_background",
           "gray_background",
           "brown_background",
           "orange_background",
           "yellow_background",
           "green_background",
           "blue_background",
           "purple_background",
           "pink_background",
           "red_background"
         ]},
      rich_text: [{NotionSDK.RichTextItemRequest, :t}]
    ]
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
        extensions: %{},
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
        type: [
          union: [
            {NotionSDK.PartialBlockObjectResponse, :t},
            {NotionSDK.ParagraphBlockObjectResponse, :t},
            {NotionSDK.Heading1BlockObjectResponse, :t},
            {NotionSDK.Heading2BlockObjectResponse, :t},
            {NotionSDK.Heading3BlockObjectResponse, :t},
            {NotionSDK.BulletedListItemBlockObjectResponse, :t},
            {NotionSDK.NumberedListItemBlockObjectResponse, :t},
            {NotionSDK.QuoteBlockObjectResponse, :t},
            {NotionSDK.ToDoBlockObjectResponse, :t},
            {NotionSDK.ToggleBlockObjectResponse, :t},
            {NotionSDK.TemplateBlockObjectResponse, :t},
            {NotionSDK.SyncedBlockBlockObjectResponse, :t},
            {NotionSDK.ChildPageBlockObjectResponse, :t},
            {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
            {NotionSDK.EquationBlockObjectResponse, :t},
            {NotionSDK.CodeBlockObjectResponse, :t},
            {NotionSDK.CalloutBlockObjectResponse, :t},
            {NotionSDK.DividerBlockObjectResponse, :t},
            {NotionSDK.BreadcrumbBlockObjectResponse, :t},
            {NotionSDK.TableOfContentsBlockObjectResponse, :t},
            {NotionSDK.ColumnListBlockObjectResponse, :t},
            {NotionSDK.ColumnBlockObjectResponse, :t},
            {NotionSDK.LinkToPageBlockObjectResponse, :t},
            {NotionSDK.TableBlockObjectResponse, :t},
            {NotionSDK.TableRowBlockObjectResponse, :t},
            {NotionSDK.MeetingNotesBlockObjectResponse, :t},
            {NotionSDK.EmbedBlockObjectResponse, :t},
            {NotionSDK.BookmarkBlockObjectResponse, :t},
            {NotionSDK.ImageBlockObjectResponse, :t},
            {NotionSDK.VideoBlockObjectResponse, :t},
            {NotionSDK.PdfBlockObjectResponse, :t},
            {NotionSDK.FileBlockObjectResponse, :t},
            {NotionSDK.AudioBlockObjectResponse, :t},
            {NotionSDK.LinkPreviewBlockObjectResponse, :t},
            {NotionSDK.UnsupportedBlockObjectResponse, :t}
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
        extensions: %{},
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
        extensions: %{},
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
        extensions: %{},
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
        extensions: %{},
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
        extensions: %{},
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
        extensions: %{},
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
        extensions: %{},
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
        type: [
          union: [
            {NotionSDK.PartialBlockObjectResponse, :t},
            {NotionSDK.ParagraphBlockObjectResponse, :t},
            {NotionSDK.Heading1BlockObjectResponse, :t},
            {NotionSDK.Heading2BlockObjectResponse, :t},
            {NotionSDK.Heading3BlockObjectResponse, :t},
            {NotionSDK.BulletedListItemBlockObjectResponse, :t},
            {NotionSDK.NumberedListItemBlockObjectResponse, :t},
            {NotionSDK.QuoteBlockObjectResponse, :t},
            {NotionSDK.ToDoBlockObjectResponse, :t},
            {NotionSDK.ToggleBlockObjectResponse, :t},
            {NotionSDK.TemplateBlockObjectResponse, :t},
            {NotionSDK.SyncedBlockBlockObjectResponse, :t},
            {NotionSDK.ChildPageBlockObjectResponse, :t},
            {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
            {NotionSDK.EquationBlockObjectResponse, :t},
            {NotionSDK.CodeBlockObjectResponse, :t},
            {NotionSDK.CalloutBlockObjectResponse, :t},
            {NotionSDK.DividerBlockObjectResponse, :t},
            {NotionSDK.BreadcrumbBlockObjectResponse, :t},
            {NotionSDK.TableOfContentsBlockObjectResponse, :t},
            {NotionSDK.ColumnListBlockObjectResponse, :t},
            {NotionSDK.ColumnBlockObjectResponse, :t},
            {NotionSDK.LinkToPageBlockObjectResponse, :t},
            {NotionSDK.TableBlockObjectResponse, :t},
            {NotionSDK.TableRowBlockObjectResponse, :t},
            {NotionSDK.MeetingNotesBlockObjectResponse, :t},
            {NotionSDK.EmbedBlockObjectResponse, :t},
            {NotionSDK.BookmarkBlockObjectResponse, :t},
            {NotionSDK.ImageBlockObjectResponse, :t},
            {NotionSDK.VideoBlockObjectResponse, :t},
            {NotionSDK.PdfBlockObjectResponse, :t},
            {NotionSDK.FileBlockObjectResponse, :t},
            {NotionSDK.AudioBlockObjectResponse, :t},
            {NotionSDK.LinkPreviewBlockObjectResponse, :t},
            {NotionSDK.UnsupportedBlockObjectResponse, :t}
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
        extensions: %{},
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
        extensions: %{},
        external_docs: nil,
        name: "audio",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t},
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
        name: "bookmark",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.UpdateMediaContentWithUrlAndCaptionRequest, :t},
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
        name: "breadcrumb",
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
        name: "bulleted_list_item",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
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
        name: "callout",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Blocks, :update_json_req_callout},
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
        name: "code",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Blocks, :update_json_req_code},
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
        name: "column",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Blocks, :update_json_req_column},
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
        name: "divider",
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
        name: "embed",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.UpdateMediaContentWithUrlAndCaptionRequest, :t},
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
        name: "equation",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithExpressionRequest, :t},
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
        name: "file",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.UpdateMediaContentWithFileNameAndCaptionRequest, :t},
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
        name: "heading_1",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
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
        name: "heading_2",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
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
        name: "heading_3",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
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
        name: "image",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t},
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
        name: "in_trash",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "link_to_page",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [{NotionSDK.PageId, :t}, {NotionSDK.DatabaseId, :t}, {NotionSDK.CommentId, :t}]},
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
        name: "numbered_list_item",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
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
        name: "paragraph",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
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
        name: "pdf",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t},
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
        name: "quote",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
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
        name: "synced_block",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Blocks, :update_json_req_synced_block},
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
        name: "table",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Blocks, :update_json_req_table},
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
        name: "table_of_contents",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Blocks, :update_json_req_table_of_contents},
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
        name: "table_row",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithTableRowRequest, :t},
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
        name: "template",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithRichTextRequest, :t},
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
        name: "to_do",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Blocks, :update_json_req_to_do},
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
        name: "toggle",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
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
        required: false,
        type:
          {:enum,
           [
             "audio",
             "bookmark",
             "breadcrumb",
             "bulleted_list_item",
             "callout",
             "code",
             "column",
             "divider",
             "embed",
             "equation",
             "file",
             "heading_1",
             "heading_2",
             "heading_3",
             "image",
             "link_to_page",
             "numbered_list_item",
             "paragraph",
             "pdf",
             "quote",
             "synced_block",
             "table",
             "table_of_contents",
             "table_row",
             "template",
             "to_do",
             "toggle",
             "video"
           ]},
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
        name: "video",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_callout) do
    [
      %{
        default: nil,
        deprecated: false,
        description:
          "One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`, `default_background`, `gray_background`, `brown_background`, `orange_background`, `yellow_background`, `green_background`, `blue_background`, `purple_background`, `pink_background`, `red_background`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "color",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:enum,
           [
             "default",
             "gray",
             "brown",
             "orange",
             "yellow",
             "green",
             "blue",
             "purple",
             "pink",
             "red",
             "default_background",
             "gray_background",
             "brown_background",
             "orange_background",
             "yellow_background",
             "green_background",
             "blue_background",
             "purple_background",
             "pink_background",
             "red_background"
           ]},
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
        name: "icon",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             {NotionSDK.FileUploadPageIconRequest, :t},
             {NotionSDK.EmojiPageIconRequest, :t},
             {NotionSDK.ExternalPageIconRequest, :t},
             {NotionSDK.CustomEmojiPageIconRequest, :t}
           ]},
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
        name: "rich_text",
        nullable: false,
        read_only: false,
        required: false,
        type: [{NotionSDK.RichTextItemRequest, :t}],
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_code) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "caption",
        nullable: false,
        read_only: false,
        required: false,
        type: [{NotionSDK.RichTextItemRequest, :t}],
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
        name: "language",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:enum,
           [
             "abap",
             "abc",
             "agda",
             "arduino",
             "ascii art",
             "assembly",
             "bash",
             "basic",
             "bnf",
             "c",
             "c#",
             "c++",
             "clojure",
             "coffeescript",
             "coq",
             "css",
             "dart",
             "dhall",
             "diff",
             "docker",
             "ebnf",
             "elixir",
             "elm",
             "erlang",
             "f#",
             "flow",
             "fortran",
             "gherkin",
             "glsl",
             "go",
             "graphql",
             "groovy",
             "haskell",
             "hcl",
             "html",
             "idris",
             "java",
             "javascript",
             "json",
             "julia",
             "kotlin",
             "latex",
             "less",
             "lisp",
             "livescript",
             "llvm ir",
             "lua",
             "makefile",
             "markdown",
             "markup",
             "matlab",
             "mathematica",
             "mermaid",
             "nix",
             "notion formula",
             "objective-c",
             "ocaml",
             "pascal",
             "perl",
             "php",
             "plain text",
             "powershell",
             "prolog",
             "protobuf",
             "purescript",
             "python",
             "r",
             "racket",
             "reason",
             "ruby",
             "rust",
             "sass",
             "scala",
             "scheme",
             "scss",
             "shell",
             "smalltalk",
             "solidity",
             "sql",
             "swift",
             "toml",
             "typescript",
             "vb.net",
             "verilog",
             "vhdl",
             "visual basic",
             "webassembly",
             "xml",
             "yaml",
             "java/c/c++/c#"
           ]},
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
        name: "rich_text",
        nullable: false,
        read_only: false,
        required: false,
        type: [{NotionSDK.RichTextItemRequest, :t}],
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_column) do
    [
      %{
        default: nil,
        deprecated: false,
        description:
          "Ratio between 0 and 1 of the width of this column relative to all columns in the list. If not provided, uses an equal width.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "width_ratio",
        nullable: false,
        read_only: false,
        required: false,
        type: :number,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_synced_block) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "synced_from",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, {NotionSDK.BlockId, :t}]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_table) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "has_column_header",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "has_row_header",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_table_of_contents) do
    [
      %{
        default: nil,
        deprecated: false,
        description:
          "One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`, `default_background`, `gray_background`, `brown_background`, `orange_background`, `yellow_background`, `green_background`, `blue_background`, `purple_background`, `pink_background`, `red_background`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "color",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:enum,
           [
             "default",
             "gray",
             "brown",
             "orange",
             "yellow",
             "green",
             "blue",
             "purple",
             "pink",
             "red",
             "default_background",
             "gray_background",
             "brown_background",
             "orange_background",
             "yellow_background",
             "green_background",
             "blue_background",
             "purple_background",
             "pink_background",
             "red_background"
           ]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_to_do) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "checked",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`, `default_background`, `gray_background`, `brown_background`, `orange_background`, `yellow_background`, `green_background`, `blue_background`, `purple_background`, `pink_background`, `red_background`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "color",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:enum,
           [
             "default",
             "gray",
             "brown",
             "orange",
             "yellow",
             "green",
             "blue",
             "purple",
             "pink",
             "red",
             "default_background",
             "gray_background",
             "brown_background",
             "orange_background",
             "yellow_background",
             "green_background",
             "blue_background",
             "purple_background",
             "pink_background",
             "red_background"
           ]},
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
        name: "rich_text",
        nullable: false,
        read_only: false,
        required: false,
        type: [{NotionSDK.RichTextItemRequest, :t}],
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

  def __schema__(:update_json_req_callout) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req_callout))
  end

  def __schema__(:update_json_req_code) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req_code))
  end

  def __schema__(:update_json_req_column) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req_column))
  end

  def __schema__(:update_json_req_synced_block) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req_synced_block))
  end

  def __schema__(:update_json_req_table) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req_table))
  end

  def __schema__(:update_json_req_table_of_contents) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req_table_of_contents))
  end

  def __schema__(:update_json_req_to_do) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req_to_do))
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
