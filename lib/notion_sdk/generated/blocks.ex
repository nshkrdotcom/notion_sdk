defmodule NotionSDK.Blocks do
  @moduledoc """
  Generated Notion Sdk operations for blocks.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @append_children_partition_spec %{
    path: [{"block_id", :block_id}],
    auth: {"auth", :auth},
    body: %{keys: [{"children", :children}, {"position", :position}], mode: :keys},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Append block children
       ## Source Context
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
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec append_children(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def append_children(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_append_children_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_append_children_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @append_children_partition_spec)

    Pristine.Operation.new(%{
      id: "blocks/append_children",
      method: :patch,
      path_template: "/v1/blocks/{block_id}/children",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.Blocks, :append_children_json_req},
      response_schemas: %{
        200 => {NotionSDK.Blocks, :append_children_200_json_resp},
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
      runtime: %{
        circuit_breaker: "core_api",
        rate_limit_group: "notion.integration",
        resource: "core_api",
        retry_group: "notion.write",
        telemetry_event: [:notion_sdk, :blocks, :append_children],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @delete_partition_spec %{
    path: [{"block_id", :block_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Delete a block
       ## Source Context
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
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec delete(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def delete(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_delete_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_delete_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @delete_partition_spec)

    Pristine.Operation.new(%{
      id: "blocks/delete",
      method: :delete,
      path_template: "/v1/blocks/{block_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 =>
          {:union,
           [
             {NotionSDK.AudioBlockObjectResponse, :t},
             {NotionSDK.BookmarkBlockObjectResponse, :t},
             {NotionSDK.BreadcrumbBlockObjectResponse, :t},
             {NotionSDK.BulletedListItemBlockObjectResponse, :t},
             {NotionSDK.CalloutBlockObjectResponse, :t},
             {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
             {NotionSDK.ChildPageBlockObjectResponse, :t},
             {NotionSDK.CodeBlockObjectResponse, :t},
             {NotionSDK.ColumnBlockObjectResponse, :t},
             {NotionSDK.ColumnListBlockObjectResponse, :t},
             {NotionSDK.DividerBlockObjectResponse, :t},
             {NotionSDK.EmbedBlockObjectResponse, :t},
             {NotionSDK.EquationBlockObjectResponse, :t},
             {NotionSDK.FileBlockObjectResponse, :t},
             {NotionSDK.Heading1BlockObjectResponse, :t},
             {NotionSDK.Heading2BlockObjectResponse, :t},
             {NotionSDK.Heading3BlockObjectResponse, :t},
             {NotionSDK.ImageBlockObjectResponse, :t},
             {NotionSDK.LinkPreviewBlockObjectResponse, :t},
             {NotionSDK.LinkToPageBlockObjectResponse, :t},
             {NotionSDK.MeetingNotesBlockObjectResponse, :t},
             {NotionSDK.NumberedListItemBlockObjectResponse, :t},
             {NotionSDK.ParagraphBlockObjectResponse, :t},
             {NotionSDK.PartialBlockObjectResponse, :t},
             {NotionSDK.PdfBlockObjectResponse, :t},
             {NotionSDK.QuoteBlockObjectResponse, :t},
             {NotionSDK.SyncedBlockBlockObjectResponse, :t},
             {NotionSDK.TableBlockObjectResponse, :t},
             {NotionSDK.TableOfContentsBlockObjectResponse, :t},
             {NotionSDK.TableRowBlockObjectResponse, :t},
             {NotionSDK.TemplateBlockObjectResponse, :t},
             {NotionSDK.ToDoBlockObjectResponse, :t},
             {NotionSDK.ToggleBlockObjectResponse, :t},
             {NotionSDK.UnsupportedBlockObjectResponse, :t},
             {NotionSDK.VideoBlockObjectResponse, :t}
           ]},
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
      runtime: %{
        circuit_breaker: "core_api",
        rate_limit_group: "notion.integration",
        resource: "core_api",
        retry_group: "notion.delete",
        telemetry_event: [:notion_sdk, :blocks, :delete],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @list_children_partition_spec %{
    path: [{"block_id", :block_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [{"start_cursor", :start_cursor}, {"page_size", :page_size}],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Retrieve block children
       ## Source Context
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
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec list_children(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def list_children(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_list_children_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  @spec stream_list_children(term(), map(), keyword()) :: Enumerable.t()
  def stream_list_children(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)

    Stream.resource(
      fn -> build_list_children_operation(params) end,
      fn
        nil ->
          {:halt, nil}

        %Pristine.Operation{} = operation ->
          operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

          case Pristine.execute(runtime_client, operation, execute_opts) do
            {:ok, response} ->
              items = List.wrap(Pristine.Operation.items(operation, response))
              {items, Pristine.Operation.next_page(operation, response)}

            {:error, reason} ->
              raise "pagination failed: " <> inspect(reason)
          end
      end,
      fn _state -> :ok end
    )
  end

  defp build_list_children_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @list_children_partition_spec)

    Pristine.Operation.new(%{
      id: "blocks/list_children",
      method: :get,
      path_template: "/v1/blocks/{block_id}/children",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.Blocks, :list_children_200_json_resp},
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
      runtime: %{
        circuit_breaker: "core_api",
        rate_limit_group: "notion.integration",
        resource: "core_api",
        retry_group: "notion.read",
        telemetry_event: [:notion_sdk, :blocks, :list_children],
        timeout_ms: nil
      },
      pagination: %{
        default_limit: nil,
        items_path: ["results"],
        request_mapping: %{cursor_location: :query, cursor_param: "start_cursor"},
        response_mapping: %{cursor_path: ["next_cursor"]},
        strategy: :cursor
      }
    })
  end

  @retrieve_partition_spec %{
    path: [{"block_id", :block_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Retrieve a block
       ## Source Context
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
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec retrieve(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def retrieve(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_retrieve_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_retrieve_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @retrieve_partition_spec)

    Pristine.Operation.new(%{
      id: "blocks/retrieve",
      method: :get,
      path_template: "/v1/blocks/{block_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 =>
          {:union,
           [
             {NotionSDK.AudioBlockObjectResponse, :t},
             {NotionSDK.BookmarkBlockObjectResponse, :t},
             {NotionSDK.BreadcrumbBlockObjectResponse, :t},
             {NotionSDK.BulletedListItemBlockObjectResponse, :t},
             {NotionSDK.CalloutBlockObjectResponse, :t},
             {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
             {NotionSDK.ChildPageBlockObjectResponse, :t},
             {NotionSDK.CodeBlockObjectResponse, :t},
             {NotionSDK.ColumnBlockObjectResponse, :t},
             {NotionSDK.ColumnListBlockObjectResponse, :t},
             {NotionSDK.DividerBlockObjectResponse, :t},
             {NotionSDK.EmbedBlockObjectResponse, :t},
             {NotionSDK.EquationBlockObjectResponse, :t},
             {NotionSDK.FileBlockObjectResponse, :t},
             {NotionSDK.Heading1BlockObjectResponse, :t},
             {NotionSDK.Heading2BlockObjectResponse, :t},
             {NotionSDK.Heading3BlockObjectResponse, :t},
             {NotionSDK.ImageBlockObjectResponse, :t},
             {NotionSDK.LinkPreviewBlockObjectResponse, :t},
             {NotionSDK.LinkToPageBlockObjectResponse, :t},
             {NotionSDK.MeetingNotesBlockObjectResponse, :t},
             {NotionSDK.NumberedListItemBlockObjectResponse, :t},
             {NotionSDK.ParagraphBlockObjectResponse, :t},
             {NotionSDK.PartialBlockObjectResponse, :t},
             {NotionSDK.PdfBlockObjectResponse, :t},
             {NotionSDK.QuoteBlockObjectResponse, :t},
             {NotionSDK.SyncedBlockBlockObjectResponse, :t},
             {NotionSDK.TableBlockObjectResponse, :t},
             {NotionSDK.TableOfContentsBlockObjectResponse, :t},
             {NotionSDK.TableRowBlockObjectResponse, :t},
             {NotionSDK.TemplateBlockObjectResponse, :t},
             {NotionSDK.ToDoBlockObjectResponse, :t},
             {NotionSDK.ToggleBlockObjectResponse, :t},
             {NotionSDK.UnsupportedBlockObjectResponse, :t},
             {NotionSDK.VideoBlockObjectResponse, :t}
           ]},
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
      runtime: %{
        circuit_breaker: "core_api",
        rate_limit_group: "notion.integration",
        resource: "core_api",
        retry_group: "notion.read",
        telemetry_event: [:notion_sdk, :blocks, :retrieve],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @update_partition_spec %{
    path: [{"block_id", :block_id}],
    auth: {"auth", :auth},
    body: %{mode: :remaining},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Update a block
       ## Source Context
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
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec update(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def update(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_update_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_update_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @update_partition_spec)

    Pristine.Operation.new(%{
      id: "blocks/update",
      method: :patch,
      path_template: "/v1/blocks/{block_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema:
        {:union,
         [
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req},
           {NotionSDK.Blocks, :update_json_req}
         ]},
      response_schemas: %{
        200 =>
          {:union,
           [
             {NotionSDK.AudioBlockObjectResponse, :t},
             {NotionSDK.BookmarkBlockObjectResponse, :t},
             {NotionSDK.BreadcrumbBlockObjectResponse, :t},
             {NotionSDK.BulletedListItemBlockObjectResponse, :t},
             {NotionSDK.CalloutBlockObjectResponse, :t},
             {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
             {NotionSDK.ChildPageBlockObjectResponse, :t},
             {NotionSDK.CodeBlockObjectResponse, :t},
             {NotionSDK.ColumnBlockObjectResponse, :t},
             {NotionSDK.ColumnListBlockObjectResponse, :t},
             {NotionSDK.DividerBlockObjectResponse, :t},
             {NotionSDK.EmbedBlockObjectResponse, :t},
             {NotionSDK.EquationBlockObjectResponse, :t},
             {NotionSDK.FileBlockObjectResponse, :t},
             {NotionSDK.Heading1BlockObjectResponse, :t},
             {NotionSDK.Heading2BlockObjectResponse, :t},
             {NotionSDK.Heading3BlockObjectResponse, :t},
             {NotionSDK.ImageBlockObjectResponse, :t},
             {NotionSDK.LinkPreviewBlockObjectResponse, :t},
             {NotionSDK.LinkToPageBlockObjectResponse, :t},
             {NotionSDK.MeetingNotesBlockObjectResponse, :t},
             {NotionSDK.NumberedListItemBlockObjectResponse, :t},
             {NotionSDK.ParagraphBlockObjectResponse, :t},
             {NotionSDK.PartialBlockObjectResponse, :t},
             {NotionSDK.PdfBlockObjectResponse, :t},
             {NotionSDK.QuoteBlockObjectResponse, :t},
             {NotionSDK.SyncedBlockBlockObjectResponse, :t},
             {NotionSDK.TableBlockObjectResponse, :t},
             {NotionSDK.TableOfContentsBlockObjectResponse, :t},
             {NotionSDK.TableRowBlockObjectResponse, :t},
             {NotionSDK.TemplateBlockObjectResponse, :t},
             {NotionSDK.ToDoBlockObjectResponse, :t},
             {NotionSDK.ToggleBlockObjectResponse, :t},
             {NotionSDK.UnsupportedBlockObjectResponse, :t},
             {NotionSDK.VideoBlockObjectResponse, :t}
           ]},
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
      runtime: %{
        circuit_breaker: "core_api",
        rate_limit_group: "notion.integration",
        resource: "core_api",
        retry_group: "notion.write",
        telemetry_event: [:notion_sdk, :blocks, :update],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :append_children_200_json_resp)

  def __fields__(:append_children_200_json_resp) do
    [
      block: {NotionSDK.EmptyObject, :t},
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      results:
        {:array,
         {:union,
          [
            {NotionSDK.AudioBlockObjectResponse, :t},
            {NotionSDK.BookmarkBlockObjectResponse, :t},
            {NotionSDK.BreadcrumbBlockObjectResponse, :t},
            {NotionSDK.BulletedListItemBlockObjectResponse, :t},
            {NotionSDK.CalloutBlockObjectResponse, :t},
            {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
            {NotionSDK.ChildPageBlockObjectResponse, :t},
            {NotionSDK.CodeBlockObjectResponse, :t},
            {NotionSDK.ColumnBlockObjectResponse, :t},
            {NotionSDK.ColumnListBlockObjectResponse, :t},
            {NotionSDK.DividerBlockObjectResponse, :t},
            {NotionSDK.EmbedBlockObjectResponse, :t},
            {NotionSDK.EquationBlockObjectResponse, :t},
            {NotionSDK.FileBlockObjectResponse, :t},
            {NotionSDK.Heading1BlockObjectResponse, :t},
            {NotionSDK.Heading2BlockObjectResponse, :t},
            {NotionSDK.Heading3BlockObjectResponse, :t},
            {NotionSDK.ImageBlockObjectResponse, :t},
            {NotionSDK.LinkPreviewBlockObjectResponse, :t},
            {NotionSDK.LinkToPageBlockObjectResponse, :t},
            {NotionSDK.MeetingNotesBlockObjectResponse, :t},
            {NotionSDK.NumberedListItemBlockObjectResponse, :t},
            {NotionSDK.ParagraphBlockObjectResponse, :t},
            {NotionSDK.PartialBlockObjectResponse, :t},
            {NotionSDK.PdfBlockObjectResponse, :t},
            {NotionSDK.QuoteBlockObjectResponse, :t},
            {NotionSDK.SyncedBlockBlockObjectResponse, :t},
            {NotionSDK.TableBlockObjectResponse, :t},
            {NotionSDK.TableOfContentsBlockObjectResponse, :t},
            {NotionSDK.TableRowBlockObjectResponse, :t},
            {NotionSDK.TemplateBlockObjectResponse, :t},
            {NotionSDK.ToDoBlockObjectResponse, :t},
            {NotionSDK.ToggleBlockObjectResponse, :t},
            {NotionSDK.UnsupportedBlockObjectResponse, :t},
            {NotionSDK.VideoBlockObjectResponse, :t}
          ]}},
      type: {:const, "block"}
    ]
  end

  def __fields__(:append_children_json_req) do
    [
      children:
        {:array,
         {:union,
          [
            {NotionSDK.Audio, :t},
            {NotionSDK.Bookmark, :t},
            {NotionSDK.Breadcrumb, :t},
            {NotionSDK.BulletedListItem, :t},
            {NotionSDK.Callout, :t},
            {NotionSDK.Code, :t},
            {NotionSDK.Column, :t},
            {NotionSDK.ColumnList, :t},
            {NotionSDK.Divider, :t},
            {NotionSDK.Embed, :t},
            {NotionSDK.Equation, :t},
            {NotionSDK.File, :t},
            {NotionSDK.Heading1, :t},
            {NotionSDK.Heading2, :t},
            {NotionSDK.Heading3, :t},
            {NotionSDK.Image, :t},
            {NotionSDK.LinkToPage, :t},
            {NotionSDK.NumberedListItem, :t},
            {NotionSDK.Paragraph, :t},
            {NotionSDK.Pdf, :t},
            {NotionSDK.Quote, :t},
            {NotionSDK.SyncedBlock, :t},
            {NotionSDK.Table, :t},
            {NotionSDK.TableOfContents, :t},
            {NotionSDK.TableRow, :t},
            {NotionSDK.Template, :t},
            {NotionSDK.ToDo, :t},
            {NotionSDK.Toggle, :t},
            {NotionSDK.Video, :t}
          ]}},
      position:
        {:union,
         [
           {NotionSDK.Blocks, :append_children_json_req_position},
           {NotionSDK.Blocks, :append_children_json_req_position},
           {NotionSDK.Blocks, :append_children_json_req_position}
         ]}
    ]
  end

  def __fields__(:append_children_json_req_position) do
    [
      after_block: {NotionSDK.Blocks, :append_children_json_req_position_after_block},
      type: {:const, "after_block"}
    ]
  end

  def __fields__(:append_children_json_req_position_after_block) do
    [
      id: :string
    ]
  end

  def __fields__(:list_children_200_json_resp) do
    [
      block: {NotionSDK.EmptyObject, :t},
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      results:
        {:array,
         {:union,
          [
            {NotionSDK.AudioBlockObjectResponse, :t},
            {NotionSDK.BookmarkBlockObjectResponse, :t},
            {NotionSDK.BreadcrumbBlockObjectResponse, :t},
            {NotionSDK.BulletedListItemBlockObjectResponse, :t},
            {NotionSDK.CalloutBlockObjectResponse, :t},
            {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
            {NotionSDK.ChildPageBlockObjectResponse, :t},
            {NotionSDK.CodeBlockObjectResponse, :t},
            {NotionSDK.ColumnBlockObjectResponse, :t},
            {NotionSDK.ColumnListBlockObjectResponse, :t},
            {NotionSDK.DividerBlockObjectResponse, :t},
            {NotionSDK.EmbedBlockObjectResponse, :t},
            {NotionSDK.EquationBlockObjectResponse, :t},
            {NotionSDK.FileBlockObjectResponse, :t},
            {NotionSDK.Heading1BlockObjectResponse, :t},
            {NotionSDK.Heading2BlockObjectResponse, :t},
            {NotionSDK.Heading3BlockObjectResponse, :t},
            {NotionSDK.ImageBlockObjectResponse, :t},
            {NotionSDK.LinkPreviewBlockObjectResponse, :t},
            {NotionSDK.LinkToPageBlockObjectResponse, :t},
            {NotionSDK.MeetingNotesBlockObjectResponse, :t},
            {NotionSDK.NumberedListItemBlockObjectResponse, :t},
            {NotionSDK.ParagraphBlockObjectResponse, :t},
            {NotionSDK.PartialBlockObjectResponse, :t},
            {NotionSDK.PdfBlockObjectResponse, :t},
            {NotionSDK.QuoteBlockObjectResponse, :t},
            {NotionSDK.SyncedBlockBlockObjectResponse, :t},
            {NotionSDK.TableBlockObjectResponse, :t},
            {NotionSDK.TableOfContentsBlockObjectResponse, :t},
            {NotionSDK.TableRowBlockObjectResponse, :t},
            {NotionSDK.TemplateBlockObjectResponse, :t},
            {NotionSDK.ToDoBlockObjectResponse, :t},
            {NotionSDK.ToggleBlockObjectResponse, :t},
            {NotionSDK.UnsupportedBlockObjectResponse, :t},
            {NotionSDK.VideoBlockObjectResponse, :t}
          ]}},
      type: {:const, "block"}
    ]
  end

  def __fields__(:update_json_req) do
    [
      audio: {NotionSDK.UpdateMediaContentWithFileAndCaptionRequest, :t},
      in_trash: :boolean,
      type: {:const, "audio"}
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
           {NotionSDK.CustomEmojiPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.FileUploadPageIconRequest, :t}
         ]},
      rich_text: {:array, {NotionSDK.RichTextItemRequest, :t}}
    ]
  end

  def __fields__(:update_json_req_code) do
    [
      caption: {:array, {NotionSDK.RichTextItemRequest, :t}},
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
      rich_text: {:array, {NotionSDK.RichTextItemRequest, :t}}
    ]
  end

  def __fields__(:update_json_req_column) do
    [
      width_ratio: :number
    ]
  end

  def __fields__(:update_json_req_synced_block) do
    [
      synced_from: {:union, [:null, {NotionSDK.BlockId, :t}]}
    ]
  end

  def __fields__(:update_json_req_table) do
    [
      has_column_header: :boolean,
      has_row_header: :boolean
    ]
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
      rich_text: {:array, {NotionSDK.RichTextItemRequest, :t}}
    ]
  end

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
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
        type:
          {:array,
           {:union,
            [
              {NotionSDK.AudioBlockObjectResponse, :t},
              {NotionSDK.BookmarkBlockObjectResponse, :t},
              {NotionSDK.BreadcrumbBlockObjectResponse, :t},
              {NotionSDK.BulletedListItemBlockObjectResponse, :t},
              {NotionSDK.CalloutBlockObjectResponse, :t},
              {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
              {NotionSDK.ChildPageBlockObjectResponse, :t},
              {NotionSDK.CodeBlockObjectResponse, :t},
              {NotionSDK.ColumnBlockObjectResponse, :t},
              {NotionSDK.ColumnListBlockObjectResponse, :t},
              {NotionSDK.DividerBlockObjectResponse, :t},
              {NotionSDK.EmbedBlockObjectResponse, :t},
              {NotionSDK.EquationBlockObjectResponse, :t},
              {NotionSDK.FileBlockObjectResponse, :t},
              {NotionSDK.Heading1BlockObjectResponse, :t},
              {NotionSDK.Heading2BlockObjectResponse, :t},
              {NotionSDK.Heading3BlockObjectResponse, :t},
              {NotionSDK.ImageBlockObjectResponse, :t},
              {NotionSDK.LinkPreviewBlockObjectResponse, :t},
              {NotionSDK.LinkToPageBlockObjectResponse, :t},
              {NotionSDK.MeetingNotesBlockObjectResponse, :t},
              {NotionSDK.NumberedListItemBlockObjectResponse, :t},
              {NotionSDK.ParagraphBlockObjectResponse, :t},
              {NotionSDK.PartialBlockObjectResponse, :t},
              {NotionSDK.PdfBlockObjectResponse, :t},
              {NotionSDK.QuoteBlockObjectResponse, :t},
              {NotionSDK.SyncedBlockBlockObjectResponse, :t},
              {NotionSDK.TableBlockObjectResponse, :t},
              {NotionSDK.TableOfContentsBlockObjectResponse, :t},
              {NotionSDK.TableRowBlockObjectResponse, :t},
              {NotionSDK.TemplateBlockObjectResponse, :t},
              {NotionSDK.ToDoBlockObjectResponse, :t},
              {NotionSDK.ToggleBlockObjectResponse, :t},
              {NotionSDK.UnsupportedBlockObjectResponse, :t},
              {NotionSDK.VideoBlockObjectResponse, :t}
            ]}},
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
        type:
          {:array,
           {:union,
            [
              {NotionSDK.Audio, :t},
              {NotionSDK.Bookmark, :t},
              {NotionSDK.Breadcrumb, :t},
              {NotionSDK.BulletedListItem, :t},
              {NotionSDK.Callout, :t},
              {NotionSDK.Code, :t},
              {NotionSDK.Column, :t},
              {NotionSDK.ColumnList, :t},
              {NotionSDK.Divider, :t},
              {NotionSDK.Embed, :t},
              {NotionSDK.Equation, :t},
              {NotionSDK.File, :t},
              {NotionSDK.Heading1, :t},
              {NotionSDK.Heading2, :t},
              {NotionSDK.Heading3, :t},
              {NotionSDK.Image, :t},
              {NotionSDK.LinkToPage, :t},
              {NotionSDK.NumberedListItem, :t},
              {NotionSDK.Paragraph, :t},
              {NotionSDK.Pdf, :t},
              {NotionSDK.Quote, :t},
              {NotionSDK.SyncedBlock, :t},
              {NotionSDK.Table, :t},
              {NotionSDK.TableOfContents, :t},
              {NotionSDK.TableRow, :t},
              {NotionSDK.Template, :t},
              {NotionSDK.ToDo, :t},
              {NotionSDK.Toggle, :t},
              {NotionSDK.Video, :t}
            ]}},
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
        type:
          {:union,
           [
             {NotionSDK.Blocks, :append_children_json_req_position},
             {NotionSDK.Blocks, :append_children_json_req_position},
             {NotionSDK.Blocks, :append_children_json_req_position}
           ]},
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
        type: {:const, "after_block"},
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
        type:
          {:array,
           {:union,
            [
              {NotionSDK.AudioBlockObjectResponse, :t},
              {NotionSDK.BookmarkBlockObjectResponse, :t},
              {NotionSDK.BreadcrumbBlockObjectResponse, :t},
              {NotionSDK.BulletedListItemBlockObjectResponse, :t},
              {NotionSDK.CalloutBlockObjectResponse, :t},
              {NotionSDK.ChildDatabaseBlockObjectResponse, :t},
              {NotionSDK.ChildPageBlockObjectResponse, :t},
              {NotionSDK.CodeBlockObjectResponse, :t},
              {NotionSDK.ColumnBlockObjectResponse, :t},
              {NotionSDK.ColumnListBlockObjectResponse, :t},
              {NotionSDK.DividerBlockObjectResponse, :t},
              {NotionSDK.EmbedBlockObjectResponse, :t},
              {NotionSDK.EquationBlockObjectResponse, :t},
              {NotionSDK.FileBlockObjectResponse, :t},
              {NotionSDK.Heading1BlockObjectResponse, :t},
              {NotionSDK.Heading2BlockObjectResponse, :t},
              {NotionSDK.Heading3BlockObjectResponse, :t},
              {NotionSDK.ImageBlockObjectResponse, :t},
              {NotionSDK.LinkPreviewBlockObjectResponse, :t},
              {NotionSDK.LinkToPageBlockObjectResponse, :t},
              {NotionSDK.MeetingNotesBlockObjectResponse, :t},
              {NotionSDK.NumberedListItemBlockObjectResponse, :t},
              {NotionSDK.ParagraphBlockObjectResponse, :t},
              {NotionSDK.PartialBlockObjectResponse, :t},
              {NotionSDK.PdfBlockObjectResponse, :t},
              {NotionSDK.QuoteBlockObjectResponse, :t},
              {NotionSDK.SyncedBlockBlockObjectResponse, :t},
              {NotionSDK.TableBlockObjectResponse, :t},
              {NotionSDK.TableOfContentsBlockObjectResponse, :t},
              {NotionSDK.TableRowBlockObjectResponse, :t},
              {NotionSDK.TemplateBlockObjectResponse, :t},
              {NotionSDK.ToDoBlockObjectResponse, :t},
              {NotionSDK.ToggleBlockObjectResponse, :t},
              {NotionSDK.UnsupportedBlockObjectResponse, :t},
              {NotionSDK.VideoBlockObjectResponse, :t}
            ]}},
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
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "audio"},
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
             {NotionSDK.CustomEmojiPageIconRequest, :t},
             {NotionSDK.EmojiPageIconRequest, :t},
             {NotionSDK.ExternalPageIconRequest, :t},
             {NotionSDK.FileUploadPageIconRequest, :t}
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
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
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
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
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
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
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
        examples: [0.5],
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
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
        write_only: false
      }
    ]
  end

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :append_children_200_json_resp) when is_atom(type) do
    RuntimeSchema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :append_children_200_json_resp)

  def decode(data, type) when is_map(data) and is_atom(type) do
    RuntimeSchema.decode_module_type(__MODULE__, type, data)
  end
end
