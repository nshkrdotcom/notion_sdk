defmodule NotionSDK.Pages do
  @moduledoc """
  Generated Notion Sdk operations for pages.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @create_partition_spec %{
    path: [],
    auth: {"auth", :auth},
    body: %{
      keys: [
        {"children", :children},
        {"content", :content},
        {"cover", :cover},
        {"icon", :icon},
        {"markdown", :markdown},
        {"parent", :parent},
        {"position", :position},
        {"properties", :properties},
        {"template", :template}
      ],
      mode: :keys
    },
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Create a page
       ## Source Context
       Use this API to create a new [page](https://developers.notion.com/reference/page) as a child of an existing page or [data source](https://developers.notion.com/reference/data-source).

       ### Warnings

       Some page `properties` are not supported via the API

       A request body that includes `rollup`, `created_by`, `created_time`, `last_edited_by`, or `last_edited_time` values in the properties object returns an error. These Notion-generated values cannot be created or updated via the API. If the `parent` contains any of these properties, then the new page’s corresponding values are automatically created.

       ### Notes

       Newlines in markdown content

       When using the `markdown` body parameter, newlines must be encoded as `\n` in the JSON string — for example, `"# Heading\n\nParagraph"`. The interactive API explorer on this page does not support multiline input, so use cURL, an SDK, or any HTTP client that sends properly encoded JSON. When using cURL, wrap the `--data` body in **single quotes** (`'...'`) so that `\n` is preserved for the JSON parser.

       Requirements

       Your integration must have [Insert Content capabilities](https://developers.notion.com/reference/capabilities#content-capabilities) on the target parent page or database in order to call this endpoint. To update your integrations capabilities, navigate to the [My integrations](https://www.notion.so/profile/integrations) dashboard, select your integration, go to the **Capabilities** tab, and update your settings as needed.
       Attempting a query without update content capabilities returns an HTTP response with a 403 status code.

       ### Use cases

       ### Choosing a parent

       In most cases, provide a `page_id` or `data_source` under the `parent` parameter to create a page under an existing [page](https://developers.notion.com/reference/page), or [data source](https://developers.notion.com/reference/data-source), respectively.
       There is a 3rd option, available only for bots of [public integrations](https://developers.notion.com/guides/get-started/getting-started#internal-vs-public-integrations): creating a private page at the workspace level. To do this, omit the `parent` parameter, or provide `parent[workspace]=true`. This can be useful for quickly creating pages that can then be organized manually in the Notion app later, helping you get to your life's work faster.
       For internal integrations, a page or data source parent is currently required in the API, because there is no one specific Notion user associated with them that could be used as the "owner" of the new private page.

       ### Setting up page properties

       If the new page is a child of an existing page,`title` is the only valid property in the `properties` body parameter.
       If the new page is a child of an existing [data source](https://developers.notion.com/reference/data-source), the keys of the `properties` object body param must match the parent [data source's properties](https://developers.notion.com/reference/property-object).

       ### Setting up page content

       This endpoint can be used to create a new page with or without content using the `children` option. To add content to a page after creating it, use the [Append block children](https://developers.notion.com/reference/patch-block-children) endpoint.
       **Templates**: As an alternative to building up page content manually, the `template` body parameter can be used to specify an existing data source template to be used to populate the content and properties of the new page.
       When omitted, the default is `template[type]=none`, which means no template is applied. The other options for `template[type]` are:
       When using `default` or `template_id`, you can optionally provide `template[timezone]` — an [IANA timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) string (e.g. `America/New_York`) — to control the timezone used when resolving template variables like `@now` and `@today`. If omitted, the authorizing user's timezone is used for public integrations, or UTC for internal integrations. An invalid timezone returns a `validation_error`.
       When applying a template, the `children` parameter is **not** allowed. The page is returned as blank initially in the API response, and then Notion's systems apply the template asynchronously after the API request finishes. For more information, see our full guide on [creating pages from templates](https://developers.notion.com/guides/data-apis/creating-pages-from-templates).

       * `default`: Apply the data source's default template.
       * This is only allowed for pages created under a data source that has a default template configured in the Notion app.
       * `template_id`: Provide a specific `template_id` to use as the blueprint for your page.
       * The API bot must have access to the template page, and it must be within the same workspace.
       * Although any valid page ID can be used as the `template[template_id]`, we recommend only using pages that are configured as actual [database templates](https://www.notion.com/help/database-templates) under the same data source as the parent of your new page to make sure that page properties can get merged in correctly.

       ### General behavior

       Returns a new [page object](https://developers.notion.com/reference/page).

       ### Errors

       Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

       ### Resources

       * [page](https://developers.notion.com/reference/page)
       * [data source](https://developers.notion.com/reference/data-source)
       * [public integrations](https://developers.notion.com/guides/get-started/getting-started#internal-vs-public-integrations)
       * [data source's properties](https://developers.notion.com/reference/property-object)
       * [Append block children](https://developers.notion.com/reference/patch-block-children)
       * [database templates](https://www.notion.com/help/database-templates)
       * [IANA timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
       * [creating pages from templates](https://developers.notion.com/guides/data-apis/creating-pages-from-templates)
       * [page object](https://developers.notion.com/reference/page)
       * [Insert Content capabilities](https://developers.notion.com/reference/capabilities#content-capabilities)
       * [My integrations](https://www.notion.so/profile/integrations)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [Create a page](https://developers.notion.com/reference/post-page)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.pages.create({
       parent: {
         data_source_id: "d9824bdc-8445-4327-be8b-5b47500af6ce"
       },
       properties: {
         Name: {
           title: [{ text: { content: "New Page Title" } }]
         }
       }
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec create(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def create(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_create_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_create_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @create_partition_spec)

    Pristine.Operation.new(%{
      id: "pages/create",
      method: :post,
      path_template: "/v1/pages",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.Pages, :create_json_req},
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.PageObjectResponse, :t}, {NotionSDK.PartialPageObjectResponse, :t}]},
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
        telemetry_event: [:notion_sdk, :pages, :create],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @move_partition_spec %{
    path: [{"page_id", :page_id}],
    auth: {"auth", :auth},
    body: %{keys: [{"parent", :parent}], mode: :keys},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Move a page
       ## Source Context
       Use this API to move an existing Notion page to a new parent.

       ### Warnings

       Page parent must be a regular Notion page

       The `parent[page_id]` parameter must be a page and cannot be any other type of [block](https://developers.notion.com/reference/block).
       One limited exception: for databases that only have a single [data source](https://developers.notion.com/reference/data-source) , the `database_id` *can* be provided under `page_id`, but this is not recommended, since your integration will start encountering HTTP 400 errors if a second data source is added to the database.

       ### Authentication

       Requires [bearer token authentication](https://developers.notion.com/reference/authentication) with appropriate [page edit permissions](https://developers.notion.com/reference/capabilities#content-capabilities).

       ### Path parameters

       **`page_id`** (required)

       * **Type**: `string` (UUIDv4)
       * **Description**: The ID of the page to move
       * This must be a regular Notion page, and not a database. Moving databases or other block types in the API is not currently supported.
       * **Format**: UUIDs can be provided with or without dashes
       * **Example**: `195de9221179449fab8075a27c979105` or `195de922-1179-449f-ab80-75a27c979105`

       ### Body parameters

       **`parent`** (required)
       The `parent` object can be one of two types:

       * **Type**: `object`
       * **Description**: The new parent location for the page.
       * The bot must have edit access to the new parent.

       ### Page parent

       Move the page under another page:
       ```json JSON theme={null}
       {
       "parent": {
       "type": "page_id",
       "page_id": "<parent-page-id>"
       }
       }
       ```

       * **`type`**: Always `"page_id"`
       * **`page_id`**: UUID of the parent page (with or without dashes)

       ### Database parent

       Move the page into a database:
       ```json JSON theme={null}
       {
       "parent": {
       "type": "data_source_id",
       "data_source_id": "<database-data-source-id>"
       }
       }
       ```
       **Note**: You must use `data_source_id` rather than `database_id`. Use the [Retrieve a database](https://developers.notion.com/reference/retrieve-a-database) endpoint to get the child data source ID(s) from the database.

       * **`type`**: Always `"data_source_id"`
       * **`data_source_id`**: UUID of the database's data source (with or without dashes)

       ### Example requests

       ### Move page under another page

       ```bash cURL theme={null}
       curl -X POST https://api.notion.com/v1/pages/195de9221179449fab8075a27c979105/move \
       -H "Authorization: Bearer secret_xxx" \
       -H "Notion-Version: 2025-09-03" \
       -H "Content-Type: application/json" \
       -d '{
       "parent": {
       "type": "page_id",
       "page_id": "f336d0bc-b841-465b-8045-024475c079dd"
       }
       }'
       ```

       ### Move page into a database

       ```bash cURL theme={null}
       curl -X POST https://api.notion.com/v1/pages/195de9221179449fab8075a27c979105/move \
       -H "Authorization: Bearer secret_xxx" \
       -H "Notion-Version: 2025-09-03" \
       -H "Content-Type: application/json" \
       -d '{
       "parent": {
       "type": "data_source_id",
       "data_source_id": "1c7b35e6-e67f-8096-bf3f-000ba938459e"
       }
       }'
       ```

       ### Resources

       * [bearer token authentication](https://developers.notion.com/reference/authentication)
       * [page edit permissions](https://developers.notion.com/reference/capabilities#content-capabilities)
       * [block](https://developers.notion.com/reference/block)
       * [data source](https://developers.notion.com/reference/data-source)
       * [Retrieve a database](https://developers.notion.com/reference/retrieve-a-database)
       * [Move a page](https://developers.notion.com/reference/move-page)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.pages.move({
       page_id: "b55c9c91-384d-452b-81db-d1ef79372b75",
       parent: {
         page_id: "3c357473-a281-49a4-88c0-10d2b245a589"
       }
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec move(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def move(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_move_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_move_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @move_partition_spec)

    Pristine.Operation.new(%{
      id: "pages/move",
      method: :post,
      path_template: "/v1/pages/{page_id}/move",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.Pages, :move_json_req},
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.PageObjectResponse, :t}, {NotionSDK.PartialPageObjectResponse, :t}]},
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
        telemetry_event: [:notion_sdk, :pages, :move],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @retrieve_partition_spec %{
    path: [{"page_id", :page_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [{"filter_properties", :filter_properties}],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Retrieve a page
       ## Source Context
       Retrieves a [Page object](https://developers.notion.com/reference/page) using the ID specified.

       ### Warnings

       This endpoint will not accurately return properties that exceed 25 references

       Do **not** use this endpoint if a page property includes more than 25 references to receive the full list of references. Instead, use the [Retrieve a page property endpoint](https://developers.notion.com/reference/retrieve-a-page-property) for the specific property to get its complete reference list.

       ### Notes

       Integration capabilities

       This endpoint requires an integration to have read content capabilities. Attempting to call this API without read content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

       ### Overview

       Responses contains page **properties**, not page content. To fetch page content, use the [Retrieve block children](https://developers.notion.com/reference/get-block-children) endpoint.

       Page properties are limited to up to **25 references** per page property. To retrieve data related to properties that have more than 25 references, use the [Retrieve a page property](https://developers.notion.com/reference/retrieve-a-page-property#rollup-properties) endpoint. (See [Limits](https://developers.notion.com/reference/retrieve-a-page#limits) below for additional information.)

       ### Parent objects: Pages vs. databases

       If a page’s [Parent object](https://developers.notion.com/reference/parent-object) is a database, then the property values will conform to the [database property schema](https://developers.notion.com/reference/property-object).
       If a page object is not part of a database, then the only property value available for that page is its `title`.

       ### Limits

       The endpoint returns a maximum of 25 page or person references per [page property](https://developers.notion.com/reference/property-value-object). If a page property includes more than 25 references, then the 26th reference and beyond might be returned as `Untitled`, `Anonymous`, or not be returned at all.
       This limit affects the following properties:

       * [`people`](https://developers.notion.com/reference/property-value-object#people-property-values): response object can’t be guaranteed to return more than 25 people.
       * [`relation`](https://developers.notion.com/reference/property-value-object#relation-property-values): the `has_more` value of the `relation` in the response object is `true` if a `relation` contains more than 25 related pages. Otherwise, `has_more` is false.
       * [`rich_text`](https://developers.notion.com/reference/property-value-object#rich-text-property-values): response object includes a maximum of 25 populated inline page or person mentions.
       * [`title`](https://developers.notion.com/reference/property-value-object#title-property-values): response object includes a maximum of 25 inline page or person mentions.

       ### Errors

       Returns a 404 HTTP response if the page doesn't exist, or if the integration doesn't have access to the page.
       Returns a 400 or 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
       *Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*

       ### Resources

       * [Retrieve a page property endpoint](https://developers.notion.com/reference/retrieve-a-page-property)
       * [Page object](https://developers.notion.com/reference/page)
       * [Retrieve block children](https://developers.notion.com/reference/get-block-children)
       * [Retrieve a page property](https://developers.notion.com/reference/retrieve-a-page-property#rollup-properties)
       * [Limits](https://developers.notion.com/reference/retrieve-a-page#limits)
       * [Parent object](https://developers.notion.com/reference/parent-object)
       * [database property schema](https://developers.notion.com/reference/property-object)
       * [page property](https://developers.notion.com/reference/property-value-object)
       * [people](https://developers.notion.com/reference/property-value-object#people-property-values)
       * [relation](https://developers.notion.com/reference/property-value-object#relation-property-values)
       * [rich_text](https://developers.notion.com/reference/property-value-object#rich-text-property-values)
       * [title](https://developers.notion.com/reference/property-value-object#title-property-values)
       * [capabilities guide](https://developers.notion.com/reference/capabilities)
       * [request limits](https://developers.notion.com/reference/request-limits)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [Retrieve a page](https://developers.notion.com/reference/retrieve-a-page)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.pages.retrieve({
       page_id: "b55c9c91-384d-452b-81db-d1ef79372b75"
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
      id: "pages/retrieve",
      method: :get,
      path_template: "/v1/pages/{page_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.PageObjectResponse, :t}, {NotionSDK.PartialPageObjectResponse, :t}]},
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
        telemetry_event: [:notion_sdk, :pages, :retrieve],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @retrieve_markdown_partition_spec %{
    path: [{"page_id", :page_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [{"include_transcript", :include_transcript}],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Retrieve a page as markdown
       ## Source Context
       Retrieve the content of a page rendered as enhanced markdown.

       ### Notes

       Requirements

       Your integration must have [read content capabilities](https://developers.notion.com/reference/capabilities#content-capabilities) on the target page in order to call this endpoint. To update your integration's capabilities, navigate to the [My integrations](https://www.notion.so/profile/integrations) dashboard, select your integration, go to the **Capabilities** tab, and update your settings as needed.
       Attempting to call this endpoint without read content capabilities returns an HTTP response with a 403 status code.

       The `unknown_block_ids` array does not distinguish between truncated and inaccessible blocks. Handle `object_not_found` errors gracefully when re-fetching unknown block IDs.

       ### Overview

       For unsupported block types, use the [block-based API](https://developers.notion.com/reference/retrieve-a-block) to retrieve the full structured data.

       ### Use cases

       Use this endpoint to retrieve the full content of a Notion page as [enhanced markdown](https://developers.notion.com/guides/data-apis/enhanced-markdown), instead of working with the [block-based API](https://developers.notion.com/reference/get-block-children). This is especially useful for agentic systems and developer tools that work natively with markdown.
       The endpoint also accepts non-navigable block IDs returned in `unknown_block_ids` from a previous truncated response. Pass these IDs to fetch additional subtrees of a large page.

       ### General behavior

       Returns a `page_markdown` object containing the page content as an enhanced markdown string.

       ### Unknown blocks

       Some blocks may appear as `<unknown url="..." alt="..."/>` tags in the markdown output. This happens when:
       When truncation or permissions cause unknown blocks, the `truncated` field is set to `true` and the `unknown_block_ids` array contains the affected block IDs.
       You can attempt to fetch unloaded blocks by passing their IDs back to this same endpoint as the `page_id` path parameter. Blocks that are unknown due to permissions will return a 404 error since the integration does not have access.

       * **Truncation**: The page exceeds the record limit (approximately 20,000 blocks) and some blocks could not be loaded.
       * **Permissions**: The page contains child pages or other content that is not shared with the integration.
       * **Unsupported block types**: Certain block types (such as bookmarks, embeds, and link previews) are [not yet supported](https://developers.notion.com/guides/data-apis/working-with-markdown-content#unsupported-block-types) in the markdown format.

       ### Errors

       Returns a 404 HTTP response if the page doesn't exist, or if the integration doesn't have access to the page.
       Returns a 400 or 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
       *Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*

       ### Resources

       * [enhanced markdown](https://developers.notion.com/guides/data-apis/enhanced-markdown)
       * [block-based API](https://developers.notion.com/reference/get-block-children)
       * [read content capabilities](https://developers.notion.com/reference/capabilities#content-capabilities)
       * [My integrations](https://www.notion.so/profile/integrations)
       * [not yet supported](https://developers.notion.com/guides/data-apis/working-with-markdown-content#unsupported-block-types)
       * [block-based API](https://developers.notion.com/reference/retrieve-a-block)
       * [request limits](https://developers.notion.com/reference/request-limits)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [Retrieve a page as markdown](https://developers.notion.com/reference/retrieve-page-markdown)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.pages.retrieveMarkdown({
       page_id: "b55c9c91-384d-452b-81db-d1ef79372b75"
       })

       console.log(response.markdown)
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec retrieve_markdown(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def retrieve_markdown(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_retrieve_markdown_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_retrieve_markdown_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @retrieve_markdown_partition_spec)

    Pristine.Operation.new(%{
      id: "pages/retrieve_markdown",
      method: :get,
      path_template: "/v1/pages/{page_id}/markdown",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.PageMarkdownResponse, :t},
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
        telemetry_event: [:notion_sdk, :pages, :retrieve_markdown],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @retrieve_property_partition_spec %{
    path: [{"page_id", :page_id}, {"property_id", :property_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [{"start_cursor", :start_cursor}, {"page_size", :page_size}],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Retrieve a page property item
       ## Source Context
       ### Notes

       Integration capabilities

       This endpoint requires an integration to have read content capabilities. Attempting to call this API without read content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

       ### Property Item Objects

       For more detailed information refer to the [Property item object documentation](https://developers.notion.com/reference/property-item-object)

       ### Simple Properties

       Each individual `property_item` properties will have a `type` and under the the key with the value for `type`, an object that identifies the property value, documented under [Property value objects](https://developers.notion.com/reference/page#property-value-object).

       ### Paginated Properties

       Property types that return a paginated list of property item objects are:
       Look for the `next_url` value in the response object for these property items to view paginated results. Refer to [paginated page properties](https://developers.notion.com/reference/page-property-values#paginated-page-properties) for a full description of the response object for these properties.
       Refer to the [pagination reference](https://developers.notion.com/reference/intro#pagination) for details on how to iterate through a results list.

       * `title`
       * `rich_text`
       * `relation`
       * `people`

       ### Rollup Properties

       <Check>
       Learn more about rollup properties on the [Page properties page](https://developers.notion.com/reference/page-property-values#rollup) or in Notion’s [Help Center](https://www.notion.so/help/relations-and-rollups).
       </Check>
       For regular "Show original" rollups, the endpoint returns a flattened list of all the property items in the rollup.
       For rollups with an aggregation, the API returns a [rollup property value](https://developers.notion.com/reference/page#rollup-property-values) under the `rollup` key and the list of relations.
       In order to avoid timeouts, if the rollup has a with a large number of aggregations or properties the endpoint returns a `next_cursor` value that is used to determinate the aggregation value *so far* for the subset of relations that have been paginated through.
       Once `has_more` is `false`, then the final rollup value is returned. Refer to the [Pagination documentation](https://developers.notion.com/reference/pagination) for more information on pagination in the Notion API.
       Computing the values of following aggregations are *not* supported. Instead the endpoint returns a list of `property_item` objects for the rollup:

       * `show_unique` (Show unique values)
       * `unique` (Count unique values)
       * `median`(Median)

       ### Errors

       Returns a 404 HTTP response if the page or property doesn't exist, or if the integration doesn't have access to the page.
       Returns a 400 or 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
       *Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*

       ### Resources

       * [Property item object documentation](https://developers.notion.com/reference/property-item-object)
       * [Property value objects](https://developers.notion.com/reference/page#property-value-object)
       * [paginated page properties](https://developers.notion.com/reference/page-property-values#paginated-page-properties)
       * [pagination reference](https://developers.notion.com/reference/intro#pagination)
       * [Page properties page](https://developers.notion.com/reference/page-property-values#rollup)
       * [Help Center](https://www.notion.so/help/relations-and-rollups)
       * [rollup property value](https://developers.notion.com/reference/page#rollup-property-values)
       * [Pagination documentation](https://developers.notion.com/reference/pagination)
       * [capabilities guide](https://developers.notion.com/reference/capabilities)
       * [request limits](https://developers.notion.com/reference/request-limits)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [Retrieve a page property item](https://developers.notion.com/reference/retrieve-a-page-property)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.pages.properties.retrieve({
       page_id: "b55c9c91-384d-452b-81db-d1ef79372b75",
       property_id: "aBcD"
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec retrieve_property(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def retrieve_property(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_retrieve_property_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_retrieve_property_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @retrieve_property_partition_spec)

    Pristine.Operation.new(%{
      id: "pages/retrieve_property",
      method: :get,
      path_template: "/v1/pages/{page_id}/properties/{property_id}",
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
             {NotionSDK.ButtonPropertyItemObjectResponse, :t},
             {NotionSDK.CheckboxPropertyItemObjectResponse, :t},
             {NotionSDK.CreatedByPropertyItemObjectResponse, :t},
             {NotionSDK.CreatedTimePropertyItemObjectResponse, :t},
             {NotionSDK.DatePropertyItemObjectResponse, :t},
             {NotionSDK.EmailPropertyItemObjectResponse, :t},
             {NotionSDK.FilesPropertyItemObjectResponse, :t},
             {NotionSDK.FormulaPropertyItemObjectResponse, :t},
             {NotionSDK.LastEditedByPropertyItemObjectResponse, :t},
             {NotionSDK.LastEditedTimePropertyItemObjectResponse, :t},
             {NotionSDK.MultiSelectPropertyItemObjectResponse, :t},
             {NotionSDK.NumberPropertyItemObjectResponse, :t},
             {NotionSDK.PeoplePropertyItemObjectResponse, :t},
             {NotionSDK.PhoneNumberPropertyItemObjectResponse, :t},
             {NotionSDK.PlacePropertyItemObjectResponse, :t},
             {NotionSDK.PropertyItemPropertyItemListResponse, :t},
             {NotionSDK.RelationPropertyItemObjectResponse, :t},
             {NotionSDK.RichTextPropertyItemObjectResponse, :t},
             {NotionSDK.RollupPropertyItemObjectResponse, :t},
             {NotionSDK.SelectPropertyItemObjectResponse, :t},
             {NotionSDK.StatusPropertyItemObjectResponse, :t},
             {NotionSDK.TitlePropertyItemObjectResponse, :t},
             {NotionSDK.UniqueIdPropertyItemObjectResponse, :t},
             {NotionSDK.UrlPropertyItemObjectResponse, :t},
             {NotionSDK.VerificationPropertyItemObjectResponse, :t}
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
        telemetry_event: [:notion_sdk, :pages, :retrieve_property],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @update_partition_spec %{
    path: [{"page_id", :page_id}],
    auth: {"auth", :auth},
    body: %{
      keys: [
        {"cover", :cover},
        {"erase_content", :erase_content},
        {"icon", :icon},
        {"in_trash", :in_trash},
        {"is_locked", :is_locked},
        {"properties", :properties},
        {"template", :template}
      ],
      mode: :keys
    },
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Update page
       ## Source Context
       Use this API to modify attributes of a Notion page, such as its properties, icon, or cover.

       ### Warnings

       Limitations

       * Updating [rollup property values](https://developers.notion.com/reference/property-value-object#rollup-property-values) is not supported.
       * A page’s `parent` cannot be changed.

       ### Notes

       Requirements

       Your integration must have [update content capabilities](https://developers.notion.com/reference/capabilities#content-capabilities) on the target page in order to call this endpoint. To update your integrations capabilities, navigate to the [My integrations](https://www.notion.so/profile/integrations) dashboard, select your integration, go to the **Capabilities** tab, and update your settings as needed.
       Attempting a query without update content capabilities returns an HTTP response with a 403 status code.

       ### Use cases

       ### Updating properties

       To change the `properties` of a page in a data source, use the `properties` body parameter. This parameter can only be used if the page's parent is a [data source](https://developers.notion.com/reference/data-source), aside from updating the `title` of a page outside of a data source.
       The page’s `properties` schema must match the parent [data source's properties](https://developers.notion.com/reference/property-object).

       ### Setting the icon, cover, or "in trash" status

       This endpoint can be used to update any page `icon` or `cover`, and can be used to [trash](https://developers.notion.com/reference/trash-page) or restore any page.

       ### Locking and unlocking a page

       Use the `is_locked` boolean parameter to lock or unlock the page from being further edited in the Notion app UI. Note that this setting doesn't affect the ability to update the page using the API.

       ### Applying a page template

       Use the `template` body parameter object to apply a [template](https://developers.notion.com/guides/data-apis/creating-pages-from-templates) to an existing page. This can either be the parent data source's default template (`type=default`), or a specific template (`type=template_id`).
       You can optionally provide `template[timezone]` — an [IANA timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) string (e.g. `America/New_York`) — to control the timezone used when resolving template variables like `@now` and `@today`. If omitted, the authorizing user's timezone is used for public integrations, or UTC for internal integrations.
       After the API request finishes, Notion's systems merge the content and properties from your chosen template into the current page.
       For more information, visit our related guide: [Creating pages from templates](https://developers.notion.com/guides/data-apis/creating-pages-from-templates).

       ### Erasing content from a page

       Use the `erase_content` flag to delete all block children of the current page. **Use caution** with this parameter, since this is a destructive action that **cannot** be reversed using the API.
       The main use case is for applying a `template` in scenarios where it makes sense to clear all of the existing page content and replace it with the template page's content, instead of appending the template content to what's already on the page.

       ### Adding content to a page

       To add content, use the [append block children](https://developers.notion.com/reference/patch-block-children) API instead. The `page_id` can be passed as the `block_id` when adding block children to the page.

       ### General behavior

       Returns the updated [page object](https://developers.notion.com/reference/page).

       ### Errors

       ErrorsEach Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

       ### Resources

       * [data source](https://developers.notion.com/reference/data-source)
       * [data source's properties](https://developers.notion.com/reference/property-object)
       * [trash](https://developers.notion.com/reference/trash-page)
       * [template](https://developers.notion.com/guides/data-apis/creating-pages-from-templates)
       * [IANA timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
       * [Creating pages from templates](https://developers.notion.com/guides/data-apis/creating-pages-from-templates)
       * [append block children](https://developers.notion.com/reference/patch-block-children)
       * [page object](https://developers.notion.com/reference/page)
       * [update content capabilities](https://developers.notion.com/reference/capabilities#content-capabilities)
       * [My integrations](https://www.notion.so/profile/integrations)
       * [rollup property values](https://developers.notion.com/reference/property-value-object#rollup-property-values)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [Update page](https://developers.notion.com/reference/patch-page)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.pages.update({
       page_id: "b55c9c91-384d-452b-81db-d1ef79372b75",
       properties: {
         Name: {
           title: [{ text: { content: "Updated Title" } }]
         }
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
      id: "pages/update",
      method: :patch,
      path_template: "/v1/pages/{page_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.Pages, :update_json_req},
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.PageObjectResponse, :t}, {NotionSDK.PartialPageObjectResponse, :t}]},
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
        telemetry_event: [:notion_sdk, :pages, :update],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @update_markdown_partition_spec %{
    path: [{"page_id", :page_id}],
    auth: {"auth", :auth},
    body: %{mode: :remaining},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Update a page's content as markdown
       ## Source Context
       Insert or replace content in a page using enhanced markdown.

       ### Warnings

       Protecting child pages and databases

       By default, this endpoint refuses to delete child pages or databases. If an operation would remove them, a `validation_error` is returned listing the affected items. Set `allow_deleting_content` to `true` in the `replace_content_range` body to permit deletion.

       ### Notes

       Requirements

       Your integration must have [update content capabilities](https://developers.notion.com/reference/capabilities#content-capabilities) on the target page in order to call this endpoint. To update your integration's capabilities, navigate to the [My integrations](https://www.notion.so/profile/integrations) dashboard, select your integration, go to the **Capabilities** tab, and update your settings as needed.
       Attempting to call this endpoint without update content capabilities returns an HTTP response with a 403 status code.

       Newlines in content

       The `content` field expects standard markdown with actual newline characters. In JSON, `\n` is the escape sequence for a newline — for example, `"## Heading\n\nParagraph"` creates a heading followed by a paragraph.
       When using cURL, wrap the `--data` body in **single quotes** (`'...'`) so that `\n` is passed through to the JSON parser. Avoid `$'...'` quoting, which converts `\n` into a literal newline and produces invalid JSON.
       Note that the interactive API explorer on this page does not support multiline input. To test with newlines, use cURL, an SDK, or any HTTP client that sends properly encoded JSON.

       ### Use cases

       ### Inserting content

       Use the `insert_content` command to add new markdown content to a page. Provide an `after` selection to insert at a specific point, or omit it to append to the end of the page.
       The `after` parameter uses an **ellipsis-based selection** format: `"start text...end text"`. This matches a range from the first occurrence of the start text to the end text.

       ### Replacing content

       Use the `replace_content_range` command to replace a matched range of existing content with new markdown. The `content_range` parameter uses the same ellipsis-based selection format as `after`.

       ### General behavior

       Returns a `page_markdown` object containing the full page content as enhanced markdown after the update, including `truncated` and `unknown_block_ids` fields for large pages.

       ### Errors

       | Error code         | Condition                                                                                       |
       | ------------------ | ----------------------------------------------------------------------------------------------- |
       | `validation_error` | The `content_range` or `after` selection does not match any content in the page.                |
       | `validation_error` | The operation would delete child pages or databases and `allow_deleting_content` is not `true`. |
       | `validation_error` | The provided ID is a database or non-page block.                                                |
       | `validation_error` | The target page is a synced page. Synced pages cannot be updated.                               |
       | `object_not_found` | The page does not exist or the integration does not have access to it.                          |
       *Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*

       ### Resources

       * [update content capabilities](https://developers.notion.com/reference/capabilities#content-capabilities)
       * [My integrations](https://www.notion.so/profile/integrations)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [Update a page's content as markdown](https://developers.notion.com/reference/update-page-markdown)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.pages.updateMarkdown({
       page_id: "b55c9c91-384d-452b-81db-d1ef79372b75",
       type: "insert_content",
       insert_content: {
         content: "## New Section\n\nInserted content here.",
         after: "# Heading...end of section"
       }
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec update_markdown(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def update_markdown(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_update_markdown_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  defp build_update_markdown_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @update_markdown_partition_spec)

    Pristine.Operation.new(%{
      id: "pages/update_markdown",
      method: :patch,
      path_template: "/v1/pages/{page_id}/markdown",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema:
        {:union,
         [
           {NotionSDK.Pages, :update_markdown_json_req},
           {NotionSDK.Pages, :update_markdown_json_req}
         ]},
      response_schemas: %{
        200 => {NotionSDK.PageMarkdownResponse, :t},
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
        telemetry_event: [:notion_sdk, :pages, :update_markdown],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :create_json_req)

  def __fields__(:create_json_req) do
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
      content:
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
      cover:
        {:union,
         [
           :null,
           {NotionSDK.ExternalPageCoverRequest, :t},
           {NotionSDK.FileUploadPageCoverRequest, :t}
         ]},
      icon:
        {:union,
         [
           :null,
           {NotionSDK.CustomEmojiPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.FileUploadPageIconRequest, :t}
         ]},
      markdown: :string,
      parent:
        {:union,
         [
           {NotionSDK.DataSourceId, :t},
           {NotionSDK.DatabaseId, :t},
           {NotionSDK.PageId, :t},
           {NotionSDK.Workspace, :t}
         ]},
      position:
        {:union,
         [
           {NotionSDK.Pages, :create_json_req_position},
           {NotionSDK.Pages, :create_json_req_position},
           {NotionSDK.Pages, :create_json_req_position}
         ]},
      properties: :map,
      template:
        {:union,
         [
           {NotionSDK.Pages, :create_json_req_template},
           {NotionSDK.Pages, :create_json_req_template},
           {NotionSDK.Pages, :create_json_req_template}
         ]}
    ]
  end

  def __fields__(:create_json_req_position) do
    [
      after_block: {NotionSDK.Pages, :create_json_req_position_after_block},
      type: {:const, "after_block"}
    ]
  end

  def __fields__(:create_json_req_position_after_block) do
    [
      id: :string
    ]
  end

  def __fields__(:create_json_req_template) do
    [
      template_id: :string,
      timezone: :string,
      type: {:const, "template_id"}
    ]
  end

  def __fields__(:move_json_req) do
    [
      parent:
        {:union,
         [{NotionSDK.Pages, :move_json_req_parent}, {NotionSDK.Pages, :move_json_req_parent}]}
    ]
  end

  def __fields__(:move_json_req_parent) do
    [
      data_source_id: :string,
      type: {:const, "data_source_id"}
    ]
  end

  def __fields__(:update_json_req) do
    [
      cover:
        {:union,
         [
           :null,
           {NotionSDK.ExternalPageCoverRequest, :t},
           {NotionSDK.FileUploadPageCoverRequest, :t}
         ]},
      erase_content: :boolean,
      icon:
        {:union,
         [
           :null,
           {NotionSDK.CustomEmojiPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.FileUploadPageIconRequest, :t}
         ]},
      in_trash: :boolean,
      is_locked: :boolean,
      properties: :map,
      template:
        {:union,
         [
           {NotionSDK.Pages, :update_json_req_template},
           {NotionSDK.Pages, :update_json_req_template}
         ]}
    ]
  end

  def __fields__(:update_json_req_template) do
    [
      template_id: :string,
      timezone: :string,
      type: {:const, "template_id"}
    ]
  end

  def __fields__(:update_markdown_json_req) do
    [
      insert_content: {NotionSDK.Pages, :update_markdown_json_req_insert_content},
      type: {:const, "insert_content"}
    ]
  end

  def __fields__(:update_markdown_json_req_insert_content) do
    [
      after: :string,
      content: :string
    ]
  end

  def __fields__(:update_markdown_json_req_replace_content_range) do
    [
      allow_deleting_content: :boolean,
      content: :string,
      content_range: :string
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "children",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "content",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "cover",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             :null,
             {NotionSDK.ExternalPageCoverRequest, :t},
             {NotionSDK.FileUploadPageCoverRequest, :t}
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
             :null,
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
        description:
          "Page content as Notion-flavored Markdown. Mutually exclusive with content/children.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "markdown",
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
        name: "parent",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             {NotionSDK.DataSourceId, :t},
             {NotionSDK.DatabaseId, :t},
             {NotionSDK.PageId, :t},
             {NotionSDK.Workspace, :t}
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
        name: "position",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             {NotionSDK.Pages, :create_json_req_position},
             {NotionSDK.Pages, :create_json_req_position},
             {NotionSDK.Pages, :create_json_req_position}
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
        name: "properties",
        nullable: false,
        read_only: false,
        required: false,
        type: :map,
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
        required: false,
        type:
          {:union,
           [
             {NotionSDK.Pages, :create_json_req_template},
             {NotionSDK.Pages, :create_json_req_template},
             {NotionSDK.Pages, :create_json_req_template}
           ]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:create_json_req_position) do
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
        type: {NotionSDK.Pages, :create_json_req_position_after_block},
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

  def __openapi_fields__(:create_json_req_position_after_block) do
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

  def __openapi_fields__(:create_json_req_template) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "template_id",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "IANA timezone to use when resolving template variables like @now and @today (e.g. 'America/New_York'). Defaults to the authorizing user's timezone for public integrations, or UTC for internal integrations.",
        example: nil,
        examples: ["America/New_York", "Europe/London", "Asia/Tokyo"],
        extensions: %{},
        external_docs: nil,
        name: "timezone",
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
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "template_id"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:move_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "The new parent of the page.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "parent",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [{NotionSDK.Pages, :move_json_req_parent}, {NotionSDK.Pages, :move_json_req_parent}]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:move_json_req_parent) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "data_source_id",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `data_source_id`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "data_source_id"},
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
        name: "cover",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             :null,
             {NotionSDK.ExternalPageCoverRequest, :t},
             {NotionSDK.FileUploadPageCoverRequest, :t}
           ]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Whether to erase all existing content from the page. When used with a template, the template content replaces the existing content. When used without a template, simply clears the page content.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "erase_content",
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
        name: "icon",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             :null,
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
        description:
          "Whether the page should be locked from editing in the Notion app UI. If not provided, the locked state will not be updated.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_locked",
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
        name: "properties",
        nullable: false,
        read_only: false,
        required: false,
        type: :map,
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
        required: false,
        type:
          {:union,
           [
             {NotionSDK.Pages, :update_json_req_template},
             {NotionSDK.Pages, :update_json_req_template}
           ]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_template) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "template_id",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "IANA timezone to use when resolving template variables like @now and @today (e.g. 'America/New_York'). Defaults to the authorizing user's timezone for public integrations, or UTC for internal integrations.",
        example: nil,
        examples: ["America/New_York", "Europe/London", "Asia/Tokyo"],
        extensions: %{},
        external_docs: nil,
        name: "timezone",
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
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "template_id"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_markdown_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "Insert new content into the page.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "insert_content",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Pages, :update_markdown_json_req_insert_content},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `insert_content`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "insert_content"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_markdown_json_req_insert_content) do
    [
      %{
        default: nil,
        deprecated: false,
        description:
          "Selection of existing content to insert after, using the ellipsis format (\"start text...end text\"). Omit to append at the end of the page.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "after",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The enhanced markdown content to insert into the page.",
        example: nil,
        examples: ["## New Section\n\nInserted content here."],
        extensions: %{},
        external_docs: nil,
        name: "content",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_markdown_json_req_replace_content_range) do
    [
      %{
        default: nil,
        deprecated: false,
        description:
          "Set to true to allow the operation to delete child pages or databases. Defaults to false.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "allow_deleting_content",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The new enhanced markdown content to replace the matched range.",
        example: nil,
        examples: ["## Updated Section\n\nNew content replaces the old."],
        extensions: %{},
        external_docs: nil,
        name: "content",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Selection of existing content to replace, using the ellipsis format (\"start text...end text\").",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "content_range",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
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
