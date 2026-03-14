defmodule NotionSDK.DataSources do
  @moduledoc """
  Provides API endpoints related to data sources

  ## Operations

    * Create a data source
    * Retrieve a data source
    * Update a data source
    * Query a data source
    * List templates in a data source
  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  use Pristine.OpenAPI.Operation

  @doc """
  Create a data source

  ## Source Context
  Create a data source
  ### Resources

    * [Create a data source](https://developers.notion.com/reference/create-a-data-source)

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

    * [Create a data source](https://developers.notion.com/reference/create-a-data-source)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.dataSources.create({
    parent: {
      database_id: "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
    },
    title: [{ text: { content: "My Data Source" } }],
    properties: {
      Name: { title: {} },
      Status: {
        select: {
          options: [
            { name: "To Do", color: "red" },
            { name: "Done", color: "green" }
          ]
        }
      }
    }
  })
  ```
  """
  @spec create(client :: NotionSDK.Client.t()) ::
          {:ok,
           NotionSDK.DataSourceObjectResponse.t() | NotionSDK.PartialDataSourceObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec create(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.DataSourceObjectResponse.t() | NotionSDK.PartialDataSourceObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def create(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"icon", :icon},
            {"parent", :parent},
            {"properties", :properties},
            {"title", :title}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.DataSources, :create},
      path_template: "/v1/data_sources",
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"application/json", {NotionSDK.DataSources, :create_json_req}}],
      response: [
        {200,
         {:union,
          [
            {NotionSDK.PartialDataSourceObjectResponse, :t},
            {NotionSDK.DataSourceObjectResponse, :t}
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

  @type list_templates_200_json_resp :: %{
          has_more: boolean,
          next_cursor: String.t() | nil,
          templates: [NotionSDK.DataSources.list_templates_200_json_resp_templates()]
        }

  @type list_templates_200_json_resp_templates :: %{
          id: String.t(),
          is_default: boolean,
          name: String.t()
        }

  @doc """
  List templates in a data source

  ## Source Context
  List data source templates
  ### Resources

    * [List data source templates](https://developers.notion.com/reference/list-data-source-templates)

  ## Options

    * `name`
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

    * [List data source templates](https://developers.notion.com/reference/list-data-source-templates)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.dataSources.listTemplates({
    data_source_id: "d9824bdc-8445-4327-be8b-5b47500af6ce"
  })
  ```
  """
  @spec list_templates(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.DataSources.list_templates_200_json_resp()}
          | {:error, NotionSDK.Error.t()}
  @spec list_templates(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.DataSources.list_templates_200_json_resp()}
          | {:error, NotionSDK.Error.t()}
  def list_templates(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"data_source_id", :data_source_id}],
        query: [{"name", :name}, {"start_cursor", :start_cursor}, {"page_size", :page_size}]
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.DataSources, :list_templates},
      path_template: "/v1/data_sources/{data_source_id}/templates",
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {NotionSDK.DataSources, :list_templates_200_json_resp}},
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

  @type query_200_json_resp :: %{
          has_more: boolean,
          next_cursor: String.t() | nil,
          object: String.t(),
          page_or_data_source: NotionSDK.EmptyObject.t(),
          results: [
            NotionSDK.DataSourceObjectResponse.t()
            | NotionSDK.PageObjectResponse.t()
            | NotionSDK.PartialDataSourceObjectResponse.t()
            | NotionSDK.PartialPageObjectResponse.t()
          ],
          type: String.t()
        }

  @doc """
  Query a data source

  ## Source Context
  Query a data source
  ### Warnings

  Formula and rollup limitations

    * If a formula depends on a page property that is a relation, and that relation has more than 25 references, only 25 will be evaluated as part of the formula.
    * Rollups and formulas that depend on multiple layers of relations may not return correct results.
    * Notion recommends individually [retrieving each page property item](https://developers.notion.com/reference/retrieve-a-page-property) to get the most accurate result.

  ### Notes

  Databases, data sources, and wikis

  [Wiki](https://www.notion.so/help/wikis-and-verified-pages) data sources can contain either pages or databases as children. In all other cases, the children can only be pages.
  For wikis, instead of directly returning any [database](https://developers.notion.com/reference/database) results, this API returns all [data sources](https://developers.notion.com/reference/data-source) that are children of *that* database. Surfacing the data source instead of the direct database child helps make it easier to craft your next API request (for example, retrieving the data source or listing its children.)
  Another tip for wikis is to use the `result_type` filter of `"page"` or `"data_source"` if you're only looking for query results that are one of those two types instead of both.

  Permissions

  Before an integration can query a data source, its parent database must be shared with the integration. Attempting to query a data source in a database that has not been shared will return an HTTP response with a 404 status code.
  To share a database with an integration, click the ••• menu at the top right of a database page, scroll to `Add connections`, and use the search bar to find and select the integration from the dropdown list.

  Integration capabilities

  This endpoint requires an integration to have read content capabilities. Attempting to call this API without read content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  To display the page titles of related pages rather than just the ID:

  1. Add a rollup property to the data source which uses a formula to get the related page's title. This works well if you have access to [update](https://developers.notion.com/reference/update-a-data-source) the data source's schema.
  2. Otherwise, [retrieve the individual related pages](https://developers.notion.com/reference/retrieve-a-page) using each page ID.

  ### Overview

  Gets a list of [pages](https://developers.notion.com/reference/page) contained in the data source, filtered and ordered according to the filter conditions and sort criteria provided in the request. The response may contain fewer than `page_size` of results. If the response includes a `next_cursor` value, refer to the [pagination reference](https://developers.notion.com/reference/intro#pagination) for details about how to use a cursor to iterate through the list.

  ### Filtering

  [**Filters**](https://developers.notion.com/reference/filter-data-source-entries) are similar to the [filters provided in the Notion UI](https://www.notion.so/help/views-filters-and-sorts) where the set of filters and filter groups chained by "And" in the UI is equivalent to having each filter in the array of the compound `"and"` filter. Similar a set of filters chained by "Or" in the UI would be represented as filters in the array of the `"or"` compound filter.
  Filters operate on data source properties and can be combined. If no filter is provided, all the pages in the data source will be returned with pagination.
  <Frame caption="The above filters in the UI can be represented as the following filter object">
  <img src="https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-6.png?fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=27e3bc94089d8d763ae7de032ded2fa3" data-og-width="1340" width="1340" data-og-height="550" height="550" data-path="images/reference/image-6.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-6.png?w=280&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=2dcdbadbb7eaa7bd76053d90d278a3b5 280w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-6.png?w=560&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=94c06afb0597c0918824a50fcc008f06 560w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-6.png?w=840&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=c45c398eed6f94836fc524b30a1413b5 840w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-6.png?w=1100&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=cabfb7bfd5f8e7f7c51d55dfbcdad761 1100w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-6.png?w=1650&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=53a3e9415432646840cc79b3aaf56499 1650w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-6.png?w=2500&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=6dbd0353198b49128ab62c186fe22318 2500w" />
  </Frame>
  ```json Filter object expandable theme={null}
  {
  "and": [
  {
  "property": "Done",
  "checkbox": {
  "equals": true
  }
  },
  {
  "or": [
  {
  "property": "Tags",
  "contains": "A"
  },
  {
  "property": "Tags",
  "contains": "B"
  }
  ]
  }
  ]
  }
  ```
  In addition to chained filters, data sources can be queried with single filters.
  ```json JSON theme={null}
  {
  "property": "Done",
  "checkbox": {
  "equals": true
  }
  }
  ```

  ### Sorting

  [**Sorts**](https://developers.notion.com/reference/sort-data-source-entries) are similar to the [sorts provided in the Notion UI](https://notion.so/notion/Intro-to-databases-fd8cd2d212f74c50954c11086d85997e#0eb303043b1742468e5aff2f3f670505). Sorts operate on database properties or page timestamps and can be combined. The order of the sorts in the request matter, with earlier sorts taking precedence over later ones.
  Notion doesn't guarantee any particular sort order when no sort parameters are provided.

  ### Recommendations for performance

  Use the `filter_properties` query parameter to filter only the properties of the data source schema you need from the response items. For example:
  ```bash  theme={null}
  https://api.notion.com/v1/data_sources/[DATA_SOURCE_ID]/query?filter_properties[]=title
  ```
  Multiple filter properties can be provided by chaining the `filter_properties` query param. For example:
  ```bash  theme={null}
  https://api.notion.com/v1/data_sources/[DATA_SOURCE_ID]/query?filter_properties[]=title&filter_properties[]=status
  ```
  This parameter accepts property IDs or property names. Property IDs can be determined with the [Retrieve a data source](https://developers.notion.com/reference/retrieve-a-data-source) endpoint.
  If you are using the [Notion JavaScript SDK](https://github.com/makenotion/notion-sdk-js), the `filter_properties` endpoint expects an array of strings. For example:
  ```typescript TypeScript theme={null}
  notion.dataSources.query({
  data_source_id: id,
  filter_properties: ["title", "status"]
  })
  ```
  Using `filter_properties` can make a significant improvement to the speed of the API and size of the JSON objects in the results, especially for databases with lots of properties, some of which might be rollups, relations, or formulas. If you need additional properties from each returned page, you can make subsequent calls to the [Retrieve page property item](https://developers.notion.com/changelog/retrieve-page-property-values) or [Retrieve a page](https://developers.notion.com/reference/retrieve-a-page) APIs.
  If you're still running into long query times with this API, other tips include:
  For more information, visit our [help center article on optimizing database load times](https://www.notion.com/help/optimize-database-load-times-and-performance).

    * Using more specific filter conditions to reduce the result set, e.g. a more specific title query or a shorter time window.
    * Dividing large data sources (ones with more than several dozen thousand pages) into multiple; e.g. splitting a "tasks" database into "Tasks" and "Bugs".
    * Pruning data source schemas to remove any complex formulas, rollups, two-way relations, or other properties that are no longer in use.
    * Setting up [integration webhooks](https://developers.notion.com/reference/webhooks) to reduce the need for polling this API by instead automatically notifying your system of incremental workspace events.

  ### Other important details and tips

  ### Errors

  Returns a 404 HTTP response if the data source doesn't exist, or if the integration doesn't have access to the data source.
  Returns a 400 or a 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
  Returns a 503 HTTP response if the data source query is temporarily unavailable due to backend datastore timeouts. The response body includes an `additional_data` object with retry guidance:
  ```json 503 response example theme={null}
  {
  "object": "error",
  "status": 503,
  "code": "service_unavailable",
  "message": "Public API data source query is temporarily unavailable due to backend datastore timeouts. Retry with exponential backoff; if retries continue to fail, reduce page_size or narrow filters/sorts.",
  "additional_data": {
  "endpoint_name": "public_queryDataSource",
  "notion_error_name": "PgPoolWaitConnectionTimeout",
  "retry_guidance": [
  "Use exponential backoff with jitter",
  "Reduce page_size",
  "Narrow query filters/sorts"
  ]
  }
  }
  ```
  <Danger>
  **Note**: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.
  </Danger>

  ### Resources

    * [pages](https://developers.notion.com/reference/page)
    * [pagination reference](https://developers.notion.com/reference/intro#pagination)
    * [Wiki](https://www.notion.so/help/wikis-and-verified-pages)
    * [database](https://developers.notion.com/reference/database)
    * [data sources](https://developers.notion.com/reference/data-source)
    * [**Filters**](https://developers.notion.com/reference/filter-data-source-entries)
    * [filters provided in the Notion UI](https://www.notion.so/help/views-filters-and-sorts)
    * [**Sorts**](https://developers.notion.com/reference/sort-data-source-entries)
    * [sorts provided in the Notion UI](https://notion.so/notion/Intro-to-databases-fd8cd2d212f74c50954c11086d85997e#0eb303043b1742468e5aff2f3f670505)
    * [Retrieve a data source](https://developers.notion.com/reference/retrieve-a-data-source)
    * [Notion JavaScript SDK](https://github.com/makenotion/notion-sdk-js)
    * [Retrieve page property item](https://developers.notion.com/changelog/retrieve-page-property-values)
    * [Retrieve a page](https://developers.notion.com/reference/retrieve-a-page)
    * [integration webhooks](https://developers.notion.com/reference/webhooks)
    * [help center article on optimizing database load times](https://www.notion.com/help/optimize-database-load-times-and-performance)
    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [update](https://developers.notion.com/reference/update-a-data-source)
    * [retrieve the individual related pages](https://developers.notion.com/reference/retrieve-a-page)
    * [retrieving each page property item](https://developers.notion.com/reference/retrieve-a-page-property)
    * [request limits](https://developers.notion.com/reference/request-limits)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Query a data source](https://developers.notion.com/reference/query-a-data-source)

  ## Options

    * `filter_properties`

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

    * [Query a data source](https://developers.notion.com/reference/query-a-data-source)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.dataSources.query({
    data_source_id: "d9824bdc-8445-4327-be8b-5b47500af6ce",
    filter: {
      property: "Status",
      select: { equals: "Done" }
    },
    sorts: [
      {
        property: "Created",
        direction: "descending"
      }
    ]
  })
  ```
  """
  @spec query(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.DataSources.query_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec query(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.DataSources.query_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def query(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"filter", :filter},
            {"in_trash", :in_trash},
            {"page_size", :page_size},
            {"result_type", :result_type},
            {"sorts", :sorts},
            {"start_cursor", :start_cursor}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [{"data_source_id", :data_source_id}],
        query: [{"filter_properties", :filter_properties}]
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.DataSources, :query},
      path_template: "/v1/data_sources/{data_source_id}/query",
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"application/json", {NotionSDK.DataSources, :query_json_req}}],
      response: [
        {200, {NotionSDK.DataSources, :query_200_json_resp}},
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
  Retrieve a data source

  ## Source Context
  Retrieve a data source
  ### Warnings

  The Notion API does not support retrieving linked data sources

  To fetch the information in a [linked data source](https://www.notion.so/help/guides/using-linked-databases), share the original source database with your Notion integration.

  ### Notes

  Data source relations must be shared with your integration

  To retrieve data source properties from [database relations](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation), the related database must be shared with your integration in addition to the database being retrieved. If the related database is not shared, properties based on relations will not be included in the API response.

  ### Finding a data source ID

  Navigate to the database URL in your Notion workspace. The ID is the string of characters in the URL that is between the slash following the workspace name (if applicable) and the question mark. The ID is a 32 characters alphanumeric string.
  <Frame caption="Notion database ID">
  <img src="https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-3.png?fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=051ded818c1263e52bb87f66a3d05ce5" data-og-width="1502" width="1502" data-og-height="128" height="128" data-path="images/reference/image-3.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-3.png?w=280&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=9c0940d5759546d98cf4021dad370923 280w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-3.png?w=560&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=2cae9af78a3a05afb501745ea56ab824 560w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-3.png?w=840&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=26b23946e58081a1fc2555a2fcda4695 840w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-3.png?w=1100&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=d401b28ebf9c711b04f5eaf15079dc41 1100w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-3.png?w=1650&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=41d67937b3a95718678068820b37bc66 1650w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-3.png?w=2500&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=b77afa7fac33cc6147689247c6535c5a 2500w" />
  </Frame>
  Then, use the [Retrieve a database](https://developers.notion.com/reference/retrieve-a-database) API to get a list of `data_sources` for that database. There is often only one data source, but when there are multiple, you may have the ID or name of the one you want to retrieve in mind (or you can retrieve each of them). Use that data source ID with this endpoint to get its `properties`.
  To get a data source ID from the Notion app directly, the settings menu for a database includes a "Copy data source ID" button under "Manage data sources":
  <Frame caption="Screenshot of the 'Manage data sources' menu for a database in Notion, with 'Copy data source ID' button.">
  <img src="https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-4.png?fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=292ed34c84b1b7161b282444678c3bc6" data-og-width="570" width="570" data-og-height="458" height="458" data-path="images/reference/image-4.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-4.png?w=280&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=5b9c76b48507780d83e621211f008f78 280w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-4.png?w=560&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=177ae36df6c163decf77ade220b57b2e 560w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-4.png?w=840&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=0e0ac98a4d5a722aab667dd83a59d86e 840w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-4.png?w=1100&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=45d964c2c0893b7c1da0585e125cc606 1100w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-4.png?w=1650&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=f320150188cf17e69e4ea4ad2e5118c9 1650w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-4.png?w=2500&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=02948f93889722aa8adfce042bdd8b54 2500w" />
  </Frame>
  Refer to the [Build your first integration guide](https://developers.notion.com/guides/get-started/create-a-notion-integration#step-3-save-the-database-id) for more details.

  ### Additional resources

    * [How to share a database with your integration](https://developers.notion.com/guides/get-started/create-a-notion-integration#give-your-integration-page-permissions)
    * [Working with databases guide](https://developers.notion.com/guides/data-apis/working-with-databases)

  ### Errors

  ErrorsEach Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

  ### Resources

    * [Retrieve a database](https://developers.notion.com/reference/retrieve-a-database)
    * [Build your first integration guide](https://developers.notion.com/guides/get-started/create-a-notion-integration#step-3-save-the-database-id)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [How to share a database with your integration](https://developers.notion.com/guides/get-started/create-a-notion-integration#give-your-integration-page-permissions)
    * [Working with databases guide](https://developers.notion.com/guides/data-apis/working-with-databases)
    * [database relations](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation)
    * [linked data source](https://www.notion.so/help/guides/using-linked-databases)
    * [Retrieve a data source](https://developers.notion.com/reference/retrieve-a-data-source)

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

    * [Retrieve a data source](https://developers.notion.com/reference/retrieve-a-data-source)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.dataSources.retrieve({
    data_source_id: "d9824bdc-8445-4327-be8b-5b47500af6ce"
  })
  ```
  """
  @spec retrieve(client :: NotionSDK.Client.t()) ::
          {:ok,
           NotionSDK.DataSourceObjectResponse.t() | NotionSDK.PartialDataSourceObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec retrieve(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.DataSourceObjectResponse.t() | NotionSDK.PartialDataSourceObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def retrieve(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"data_source_id", :data_source_id}],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.DataSources, :retrieve},
      path_template: "/v1/data_sources/{data_source_id}",
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
            {NotionSDK.PartialDataSourceObjectResponse, :t},
            {NotionSDK.DataSourceObjectResponse, :t}
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
  Update a data source

  ## Source Context
  Update a data source
  ### Warnings

  The following data source properties cannot be updated via the API:

    * `formula`
    * `status`
    * [Synced content](https://www.notion.so/help/guides/synced-databases-bridge-different-tools)
    * `place`

  ### Notes

  Data source relations must be shared with your integration

  To update a data source [relation](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation) property, the related database must also be shared with your integration.

  ### How data sources property type changes work

  All properties in pages are stored as rich text. Notion will convert that rich text based on the types defined in a data source's schema. When a type is changed using the API, the data will continue to be available, it is just presented differently.
  For example, a multi select property value is represented as a comma-separated list of strings (eg. "1, 2, 3") and a people property value is represented as a comma-separated list of IDs. These are compatible and the type can be converted.
  Note: Not all type changes work. In some cases data will no longer be returned, such as people type → file type.

  ### Interacting with data source rows

  This endpoint cannot be used to update data source rows.
  To update the properties of a data source row — rather than a column — use the [Update page](https://developers.notion.com/reference/patch-page) endpoint. To add a new row to a database, use the [Create a page](https://developers.notion.com/reference/post-page) endpoint.

  ### Recommended data source schema size limit

  Developers are encouraged to keep their data source schema size to a maximum of **50KB**. To stay within this schema size limit, the number of properties (or columns) added to a data source should be managed.
  Data source schema updates that are too large will be blocked by the REST API to help developers keep their data source queries performant. When a schema update is blocked, the error response includes a `validation_error` code with a message identifying the largest property by name, ID, and byte size to help you reduce your schema size.

  ### Errors

  Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

  ### Resources

    * [Update page](https://developers.notion.com/reference/patch-page)
    * [Create a page](https://developers.notion.com/reference/post-page)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Synced content](https://www.notion.so/help/guides/synced-databases-bridge-different-tools)
    * [relation](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation)
    * [Update a data source](https://developers.notion.com/reference/update-a-data-source)

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

    * [Update a data source](https://developers.notion.com/reference/update-a-data-source)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.dataSources.update({
    data_source_id: "d9824bdc-8445-4327-be8b-5b47500af6ce",
    title: [{ text: { content: "Updated Data Source Name" } }]
  })
  ```
  """
  @spec update(client :: NotionSDK.Client.t()) ::
          {:ok,
           NotionSDK.DataSourceObjectResponse.t() | NotionSDK.PartialDataSourceObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec update(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.DataSourceObjectResponse.t() | NotionSDK.PartialDataSourceObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def update(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"icon", :icon},
            {"in_trash", :in_trash},
            {"parent", :parent},
            {"properties", :properties},
            {"title", :title}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [{"data_source_id", :data_source_id}],
        query: []
      })

    NotionSDK.Client.execute_generated_request(client, %{
      args: params,
      call: {NotionSDK.DataSources, :update},
      path_template: "/v1/data_sources/{data_source_id}",
      method: :patch,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"application/json", {NotionSDK.DataSources, :update_json_req}}],
      response: [
        {200,
         {:union,
          [
            {NotionSDK.PartialDataSourceObjectResponse, :t},
            {NotionSDK.DataSourceObjectResponse, :t}
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
  def __fields__(type \\ :create_json_req)

  def __fields__(:create_json_req) do
    [
      icon:
        {:union,
         [
           :null,
           {NotionSDK.FileUploadPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.CustomEmojiPageIconRequest, :t}
         ]},
      parent: {NotionSDK.ParentOfDataSourceRequest, :t},
      properties: :map,
      title: [{NotionSDK.RichTextItemRequest, :t}]
    ]
  end

  def __fields__(:list_templates_200_json_resp) do
    [
      has_more: :boolean,
      next_cursor: {:union, [:null, string: "uuid"]},
      templates: [{NotionSDK.DataSources, :list_templates_200_json_resp_templates}]
    ]
  end

  def __fields__(:list_templates_200_json_resp_templates) do
    [id: {:string, "uuid"}, is_default: :boolean, name: :string]
  end

  def __fields__(:query_200_json_resp) do
    [
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      page_or_data_source: {NotionSDK.EmptyObject, :t},
      results: [
        union: [
          {NotionSDK.PageObjectResponse, :t},
          {NotionSDK.PartialPageObjectResponse, :t},
          {NotionSDK.PartialDataSourceObjectResponse, :t},
          {NotionSDK.DataSourceObjectResponse, :t}
        ]
      ],
      type: {:const, "page_or_data_source"}
    ]
  end

  def __fields__(:query_json_req) do
    [
      filter:
        {:union,
         [
           {NotionSDK.DataSources, :query_json_req_filter},
           {NotionSDK.Title, :t},
           {NotionSDK.RichText, :t},
           {NotionSDK.Number, :t},
           {NotionSDK.Checkbox, :t},
           {NotionSDK.Select, :t},
           {NotionSDK.MultiSelect, :t},
           {NotionSDK.Status, :t},
           {NotionSDK.Date, :t},
           {NotionSDK.People, :t},
           {NotionSDK.Files, :t},
           {NotionSDK.Url, :t},
           {NotionSDK.Email, :t},
           {NotionSDK.PhoneNumber, :t},
           {NotionSDK.Relation, :t},
           {NotionSDK.CreatedBy, :t},
           {NotionSDK.CreatedTime, :t},
           {NotionSDK.LastEditedBy, :t},
           {NotionSDK.LastEditedTime, :t},
           {NotionSDK.Formula, :t},
           {NotionSDK.UniqueId, :t},
           {NotionSDK.Rollup, :t},
           {NotionSDK.Verification, :t},
           {NotionSDK.TimestampCreatedTimeFilter, :t},
           {NotionSDK.TimestampLastEditedTimeFilter, :t}
         ]},
      in_trash: :boolean,
      page_size: :number,
      result_type: {:enum, ["page", "data_source"]},
      sorts: [{NotionSDK.DataSources, :query_json_req_sorts}],
      start_cursor: {:string, "uuid"}
    ]
  end

  def __fields__(:query_json_req_filter) do
    [
      and: [
        union: [
          {NotionSDK.Title, :t},
          {NotionSDK.RichText, :t},
          {NotionSDK.Number, :t},
          {NotionSDK.Checkbox, :t},
          {NotionSDK.Select, :t},
          {NotionSDK.MultiSelect, :t},
          {NotionSDK.Status, :t},
          {NotionSDK.Date, :t},
          {NotionSDK.People, :t},
          {NotionSDK.Files, :t},
          {NotionSDK.Url, :t},
          {NotionSDK.Email, :t},
          {NotionSDK.PhoneNumber, :t},
          {NotionSDK.Relation, :t},
          {NotionSDK.CreatedBy, :t},
          {NotionSDK.CreatedTime, :t},
          {NotionSDK.LastEditedBy, :t},
          {NotionSDK.LastEditedTime, :t},
          {NotionSDK.Formula, :t},
          {NotionSDK.UniqueId, :t},
          {NotionSDK.Rollup, :t},
          {NotionSDK.Verification, :t},
          {NotionSDK.TimestampCreatedTimeFilter, :t},
          {NotionSDK.TimestampLastEditedTimeFilter, :t},
          :map
        ]
      ],
      or: [
        union: [
          {NotionSDK.Title, :t},
          {NotionSDK.RichText, :t},
          {NotionSDK.Number, :t},
          {NotionSDK.Checkbox, :t},
          {NotionSDK.Select, :t},
          {NotionSDK.MultiSelect, :t},
          {NotionSDK.Status, :t},
          {NotionSDK.Date, :t},
          {NotionSDK.People, :t},
          {NotionSDK.Files, :t},
          {NotionSDK.Url, :t},
          {NotionSDK.Email, :t},
          {NotionSDK.PhoneNumber, :t},
          {NotionSDK.Relation, :t},
          {NotionSDK.CreatedBy, :t},
          {NotionSDK.CreatedTime, :t},
          {NotionSDK.LastEditedBy, :t},
          {NotionSDK.LastEditedTime, :t},
          {NotionSDK.Formula, :t},
          {NotionSDK.UniqueId, :t},
          {NotionSDK.Rollup, :t},
          {NotionSDK.Verification, :t},
          {NotionSDK.TimestampCreatedTimeFilter, :t},
          {NotionSDK.TimestampLastEditedTimeFilter, :t},
          :map
        ]
      ]
    ]
  end

  def __fields__(:query_json_req_sorts) do
    [
      direction: {:enum, ["ascending", "descending"]},
      property: :string,
      timestamp: {:enum, ["created_time", "last_edited_time"]}
    ]
  end

  def __fields__(:update_json_req) do
    [
      icon:
        {:union,
         [
           :null,
           {NotionSDK.FileUploadPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.CustomEmojiPageIconRequest, :t}
         ]},
      in_trash: :boolean,
      parent: {NotionSDK.ParentOfDataSourceRequest, :t},
      properties: :map,
      title: [{NotionSDK.RichTextItemRequest, :t}]
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
        description: "Page icon.",
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
        name: "parent",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ParentOfDataSourceRequest, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Property schema of data source.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "properties",
        nullable: false,
        read_only: false,
        required: true,
        type: :map,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Title of data source as it appears in Notion.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "title",
        nullable: false,
        read_only: false,
        required: false,
        type: [{NotionSDK.RichTextItemRequest, :t}],
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:list_templates_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "Whether there are more templates available beyond this page.",
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
        description:
          "Cursor to use for the next page of results. Null if there are no more results.",
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
        description: "Array of templates available in this data source.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "templates",
        nullable: false,
        read_only: false,
        required: true,
        type: [{NotionSDK.DataSources, :list_templates_200_json_resp_templates}],
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:list_templates_200_json_resp_templates) do
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
        type: {:string, "uuid"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Whether this template is the default template for the data source.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_default",
        nullable: false,
        read_only: false,
        required: true,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Name of the template.",
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

  def __openapi_fields__(:query_200_json_resp) do
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
        name: "page_or_data_source",
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
        name: "results",
        nullable: false,
        read_only: false,
        required: true,
        type: [
          union: [
            {NotionSDK.PageObjectResponse, :t},
            {NotionSDK.PartialPageObjectResponse, :t},
            {NotionSDK.PartialDataSourceObjectResponse, :t},
            {NotionSDK.DataSourceObjectResponse, :t}
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
        type: {:const, "page_or_data_source"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:query_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "filter",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             {NotionSDK.DataSources, :query_json_req_filter},
             {NotionSDK.Title, :t},
             {NotionSDK.RichText, :t},
             {NotionSDK.Number, :t},
             {NotionSDK.Checkbox, :t},
             {NotionSDK.Select, :t},
             {NotionSDK.MultiSelect, :t},
             {NotionSDK.Status, :t},
             {NotionSDK.Date, :t},
             {NotionSDK.People, :t},
             {NotionSDK.Files, :t},
             {NotionSDK.Url, :t},
             {NotionSDK.Email, :t},
             {NotionSDK.PhoneNumber, :t},
             {NotionSDK.Relation, :t},
             {NotionSDK.CreatedBy, :t},
             {NotionSDK.CreatedTime, :t},
             {NotionSDK.LastEditedBy, :t},
             {NotionSDK.LastEditedTime, :t},
             {NotionSDK.Formula, :t},
             {NotionSDK.UniqueId, :t},
             {NotionSDK.Rollup, :t},
             {NotionSDK.Verification, :t},
             {NotionSDK.TimestampCreatedTimeFilter, :t},
             {NotionSDK.TimestampLastEditedTimeFilter, :t}
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "page_size",
        nullable: false,
        read_only: false,
        required: false,
        type: :number,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Optionally filter the results to only include pages or data sources. Regular, non-wiki databases only support page children. The default behavior is no result type filtering, in other words, returning both pages and data sources for wikis.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "result_type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:enum, ["page", "data_source"]},
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
        name: "sorts",
        nullable: false,
        read_only: false,
        required: false,
        type: [{NotionSDK.DataSources, :query_json_req_sorts}],
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
        name: "start_cursor",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "uuid"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:query_json_req_filter) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "and",
        nullable: false,
        read_only: false,
        required: true,
        type: [
          union: [
            {NotionSDK.Title, :t},
            {NotionSDK.RichText, :t},
            {NotionSDK.Number, :t},
            {NotionSDK.Checkbox, :t},
            {NotionSDK.Select, :t},
            {NotionSDK.MultiSelect, :t},
            {NotionSDK.Status, :t},
            {NotionSDK.Date, :t},
            {NotionSDK.People, :t},
            {NotionSDK.Files, :t},
            {NotionSDK.Url, :t},
            {NotionSDK.Email, :t},
            {NotionSDK.PhoneNumber, :t},
            {NotionSDK.Relation, :t},
            {NotionSDK.CreatedBy, :t},
            {NotionSDK.CreatedTime, :t},
            {NotionSDK.LastEditedBy, :t},
            {NotionSDK.LastEditedTime, :t},
            {NotionSDK.Formula, :t},
            {NotionSDK.UniqueId, :t},
            {NotionSDK.Rollup, :t},
            {NotionSDK.Verification, :t},
            {NotionSDK.TimestampCreatedTimeFilter, :t},
            {NotionSDK.TimestampLastEditedTimeFilter, :t},
            :map
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
        name: "or",
        nullable: false,
        read_only: false,
        required: true,
        type: [
          union: [
            {NotionSDK.Title, :t},
            {NotionSDK.RichText, :t},
            {NotionSDK.Number, :t},
            {NotionSDK.Checkbox, :t},
            {NotionSDK.Select, :t},
            {NotionSDK.MultiSelect, :t},
            {NotionSDK.Status, :t},
            {NotionSDK.Date, :t},
            {NotionSDK.People, :t},
            {NotionSDK.Files, :t},
            {NotionSDK.Url, :t},
            {NotionSDK.Email, :t},
            {NotionSDK.PhoneNumber, :t},
            {NotionSDK.Relation, :t},
            {NotionSDK.CreatedBy, :t},
            {NotionSDK.CreatedTime, :t},
            {NotionSDK.LastEditedBy, :t},
            {NotionSDK.LastEditedTime, :t},
            {NotionSDK.Formula, :t},
            {NotionSDK.UniqueId, :t},
            {NotionSDK.Rollup, :t},
            {NotionSDK.Verification, :t},
            {NotionSDK.TimestampCreatedTimeFilter, :t},
            {NotionSDK.TimestampLastEditedTimeFilter, :t},
            :map
          ]
        ],
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:query_json_req_sorts) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "direction",
        nullable: false,
        read_only: false,
        required: true,
        type: {:enum, ["ascending", "descending"]},
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
        name: "property",
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
        name: "timestamp",
        nullable: false,
        read_only: false,
        required: true,
        type: {:enum, ["created_time", "last_edited_time"]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "Page icon.",
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
        description:
          "Whether the database should be moved to or from the trash. If not provided, the trash status will not be updated.",
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
        name: "parent",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.ParentOfDataSourceRequest, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "The property schema of the data source. The keys are property names or IDs, and the values are property configuration objects. Properties set to null will be removed.",
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
        description: "Title of data source as it appears in Notion.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "title",
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

  def __schema__(type \\ :create_json_req)

  def __schema__(:create_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:create_json_req))
  end

  def __schema__(:list_templates_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:list_templates_200_json_resp))
  end

  def __schema__(:list_templates_200_json_resp_templates) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:list_templates_200_json_resp_templates))
  end

  def __schema__(:query_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:query_200_json_resp))
  end

  def __schema__(:query_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:query_json_req))
  end

  def __schema__(:query_json_req_filter) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:query_json_req_filter))
  end

  def __schema__(:query_json_req_sorts) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:query_json_req_sorts))
  end

  def __schema__(:update_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req))
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
