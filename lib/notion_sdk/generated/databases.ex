defmodule NotionSDK.Databases do
  @moduledoc """
  Provides API endpoints related to databases

  ## Operations

    * Create a database
    * Retrieve a database
    * Update a database
  """
  use Pristine.OpenAPI.Operation
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @doc """
  Create a database

  ## Source Context
  Create a database
  ### Warnings

  Limitations

  Creating new `status` database properties is currently not supported.

  ### Notes

  Integration capabilities

  This endpoint requires an integration to have insert content capabilities. Attempting to call this API without insert content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).

  ### Errors

  Returns a 404 if the specified parent page does not exist, or if the integration does not have access to the parent page.
  Returns a 400 if the request is incorrectly formatted, or a 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).
  *Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*

  ### Resources

    * [capabilities guide](https://developers.notion.com/reference/capabilities)
    * [request limits](https://developers.notion.com/reference/request-limits)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Create a database](https://developers.notion.com/reference/create-a-database)

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

    * [Create a database](https://developers.notion.com/reference/create-a-database)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.databases.create({
    parent: {
      type: "page_id",
      page_id: "b55c9c91-384d-452b-81db-d1ef79372b75"
    },
    title: [{ text: { content: "My Database" } }]
  })
  ```
  """
  @spec create(client :: NotionSDK.Client.t()) ::
          {:ok,
           NotionSDK.DatabaseObjectResponse.t() | NotionSDK.PartialDatabaseObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec create(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.DatabaseObjectResponse.t() | NotionSDK.PartialDatabaseObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def create(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"cover", :cover},
            {"description", :description},
            {"icon", :icon},
            {"initial_data_source", :initial_data_source},
            {"is_inline", :is_inline},
            {"parent", :parent},
            {"title", :title}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Databases, :create},
      path_template: "/v1/databases",
      url: render_path("/v1/databases", partition.path_params),
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
      request: [{"application/json", {NotionSDK.Databases, :create_json_req}}],
      response: [
        {200,
         {:union,
          [{NotionSDK.PartialDatabaseObjectResponse, :t}, {NotionSDK.DatabaseObjectResponse, :t}]}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ]
    })
  end

  @doc """
  Retrieve a database

  ## Source Context
  Retrieve a database
  Retrieves a [database object](https://developers.notion.com/reference/database) — information that describes the structure and columns of a database — for a provided database ID. The response adheres to any limits to an integration’s capabilities.

  ### Warnings

  Deprecated as of version 2025-09-03

  This page describes the API for versions up to and including `2022-06-28`. In the new `2025-09-03` version, the concepts of databases and data sources were split up, as described in [Upgrading to 2025-09-03](https://developers.notion.com/guides/get-started/upgrade-guide-2025-09-03).
  Refer to the new APIs instead:

    * [Retrieve a database](https://developers.notion.com/reference/database-retrieve)
    * [Retrieve a data source](https://developers.notion.com/reference/retrieve-a-data-source)

  The Notion API does not support retrieving linked databases.

  To fetch the information in a [linked database](https://www.notion.so/help/guides/using-linked-databases), share the original source database with your Notion integration.

  ### Notes

  Database relations must be shared with your integration

  To retrieve database properties from [database relations](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation), the related database must be shared with your integration in addition to the database being retrieved. If the related database is not shared, properties based on relations will not be included in the API response.

  ### Overview

  To fetch database rows rather than columns, use the [Query a database](https://developers.notion.com/reference/post-database-query) endpoint.

  To find a database ID, navigate to the database URL in your Notion workspace. The ID is the string of characters in the URL that is between the slash following the workspace name (if applicable) and the question mark. The ID is a 32 characters alphanumeric string.

  <Frame caption="Notion database ID">
  <img src="https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=00a19b68b92cd013cdc0f8867427eb44" alt="1340" data-og-width="1340" width="1340" data-og-height="550" height="550" data-path="images/reference/image-1.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=280&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=619d6c3987ad5749bf23af7818319fa2 280w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=560&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=169ae1bb1ec28afc5a2a76da22509aa7 560w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=840&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=721d8511030842a08474ddd98a6b384f 840w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=1100&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=7916e5aadb53f7b659e522154193debe 1100w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=1650&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=3efcdcb414a369a7835d2745d192abaf 1650w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=2500&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=dd872b0b759a00afe4d3cd4243877c8b 2500w" />
  </Frame>

  Refer to the [Build your first integration guide](https://developers.notion.com/guides/get-started/create-a-notion-integration#step-3-save-the-database-id) for more details.

  ### Additional resources

    * [How to share a database with your integration](https://developers.notion.com/guides/get-started/create-a-notion-integration#give-your-integration-page-permissions)
    * [Working with databases guide](https://developers.notion.com/guides/data-apis/working-with-databases)

  ### Errors

  ErrorsEach Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

  ### Resources

    * [Upgrading to 2025-09-03](https://developers.notion.com/guides/get-started/upgrade-guide-2025-09-03)
    * [Retrieve a database](https://developers.notion.com/reference/database-retrieve)
    * [Retrieve a data source](https://developers.notion.com/reference/retrieve-a-data-source)
    * [database object](https://developers.notion.com/reference/database)
    * [Query a database](https://developers.notion.com/reference/post-database-query)
    * [Build your first integration guide](https://developers.notion.com/guides/get-started/create-a-notion-integration#step-3-save-the-database-id)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [How to share a database with your integration](https://developers.notion.com/guides/get-started/create-a-notion-integration#give-your-integration-page-permissions)
    * [Working with databases guide](https://developers.notion.com/guides/data-apis/working-with-databases)
    * [database relations](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation)
    * [linked database](https://www.notion.so/help/guides/using-linked-databases)
    * [Retrieve a database](https://developers.notion.com/reference/retrieve-a-database)

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

    * [Retrieve a database](https://developers.notion.com/reference/retrieve-a-database)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.databases.retrieve({
    database_id: "d9824bdc-8445-4327-be8b-5b47500af6ce"
  })
  ```
  """
  @spec retrieve(client :: NotionSDK.Client.t()) ::
          {:ok,
           NotionSDK.DatabaseObjectResponse.t() | NotionSDK.PartialDatabaseObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec retrieve(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.DatabaseObjectResponse.t() | NotionSDK.PartialDatabaseObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def retrieve(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"database_id", :database_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Databases, :retrieve},
      path_template: "/v1/databases/{database_id}",
      url: render_path("/v1/databases/{database_id}", partition.path_params),
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
          [{NotionSDK.PartialDatabaseObjectResponse, :t}, {NotionSDK.DatabaseObjectResponse, :t}]}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ]
    })
  end

  @doc """
  Update a database

  ## Source Context
  Update a database
  ### Warnings

  The following database properties cannot be updated via the API:

    * `formula`
    * `select`
    * `status`
    * [Synced content](https://www.notion.so/help/guides/synced-databases-bridge-different-tools)
    * A `multi_select` database property’s options values. An option can be removed, but not updated.

  ### Notes

  Database relations must be shared with your integration

  To update a database [relation](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation) property, the related database must also be shared with your integration.

  ### How database property type changes work

  All properties in pages are stored as rich text. Notion will convert that rich text based on the types defined in a database's schema. When a type is changed using the API, the data will continue to be available, it is just presented differently.
  For example, a multi select property value is represented as a comma-separated list of strings (eg. "1, 2, 3") and a people property value is represented as a comma-separated list of IDs. These are compatible and the type can be converted.
  Note: Not all type changes work. In some cases data will no longer be returned, such as people type → file type.

  ### Interacting with database rows

  This endpoint cannot be used to update database rows.
  To update the properties of a database row — rather than a column — use the [Update page](https://developers.notion.com/reference/patch-page) endpoint. To add a new row to a database, use the [Create a page](https://developers.notion.com/reference/post-page) endpoint.

  ### Recommended database schema size limit

  Developers are encouraged to keep their database schema size to a maximum of **50KB**. To stay within this schema size limit, the number of properties (or columns) added to a database should be managed.
  Database schema updates that are too large will be blocked by the REST API to help developers keep their database queries performant. When a schema update is blocked, the error response includes a `validation_error` code with a message identifying the largest property by name, ID, and byte size to help you reduce your schema size.

  ### Errors

  Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

  ### Resources

    * [Update page](https://developers.notion.com/reference/patch-page)
    * [Create a page](https://developers.notion.com/reference/post-page)
    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [Synced content](https://www.notion.so/help/guides/synced-databases-bridge-different-tools)
    * [relation](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation)
    * [Update a database](https://developers.notion.com/reference/update-a-database)

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

    * [Update a database](https://developers.notion.com/reference/update-a-database)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.databases.update({
    database_id: "d9824bdc-8445-4327-be8b-5b47500af6ce",
    title: [{ text: { content: "Updated Database Title" } }]
  })
  ```
  """
  @spec update(client :: NotionSDK.Client.t()) ::
          {:ok,
           NotionSDK.DatabaseObjectResponse.t() | NotionSDK.PartialDatabaseObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  @spec update(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok,
           NotionSDK.DatabaseObjectResponse.t() | NotionSDK.PartialDatabaseObjectResponse.t()}
          | {:error, NotionSDK.Error.t()}
  def update(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"cover", :cover},
            {"description", :description},
            {"icon", :icon},
            {"in_trash", :in_trash},
            {"is_inline", :is_inline},
            {"is_locked", :is_locked},
            {"parent", :parent},
            {"title", :title}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [{"database_id", :database_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Databases, :update},
      path_template: "/v1/databases/{database_id}",
      url: render_path("/v1/databases/{database_id}", partition.path_params),
      method: :patch,
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
      request: [{"application/json", {NotionSDK.Databases, :update_json_req}}],
      response: [
        {200,
         {:union,
          [{NotionSDK.PartialDatabaseObjectResponse, :t}, {NotionSDK.DatabaseObjectResponse, :t}]}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ]
    })
  end

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :create_json_req)

  def __fields__(:create_json_req) do
    [
      cover:
        {:union,
         [{NotionSDK.FileUploadPageCoverRequest, :t}, {NotionSDK.ExternalPageCoverRequest, :t}]},
      description: [{NotionSDK.RichTextItemRequest, :t}],
      icon:
        {:union,
         [
           {NotionSDK.FileUploadPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.CustomEmojiPageIconRequest, :t}
         ]},
      initial_data_source: {NotionSDK.InitialDataSourceRequest, :t},
      is_inline: :boolean,
      parent: {NotionSDK.Databases, :create_json_req_parent},
      title: [{NotionSDK.RichTextItemRequest, :t}]
    ]
  end

  def __fields__(:create_json_req_parent) do
    [type: {:enum, ["page_id", "workspace"]}]
  end

  def __fields__(:update_json_req) do
    [
      cover:
        {:union,
         [{NotionSDK.FileUploadPageCoverRequest, :t}, {NotionSDK.ExternalPageCoverRequest, :t}]},
      description: [{NotionSDK.RichTextItemRequest, :t}],
      icon:
        {:union,
         [
           {NotionSDK.FileUploadPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.CustomEmojiPageIconRequest, :t}
         ]},
      in_trash: :boolean,
      is_inline: :boolean,
      is_locked: :boolean,
      parent: {NotionSDK.Databases, :update_json_req_parent},
      title: [{NotionSDK.RichTextItemRequest, :t}]
    ]
  end

  def __fields__(:update_json_req_parent) do
    [type: {:enum, ["page_id", "workspace"]}]
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
           [{NotionSDK.FileUploadPageCoverRequest, :t}, {NotionSDK.ExternalPageCoverRequest, :t}]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The description of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "description",
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
        name: "initial_data_source",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.InitialDataSourceRequest, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Whether the database should be displayed inline in the parent page. Defaults to false.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_inline",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The parent page or workspace where the database will be created.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "parent",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Databases, :create_json_req_parent},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The title of the database.",
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

  def __openapi_fields__(:create_json_req_parent) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "The type of parent.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:enum, ["page_id", "workspace"]},
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
           [{NotionSDK.FileUploadPageCoverRequest, :t}, {NotionSDK.ExternalPageCoverRequest, :t}]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "The updated description of the database, if any. If not provided, the description will not be updated.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "description",
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
        description:
          "Whether the database should be displayed inline in the parent page. If not provided, the inline status will not be updated.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_inline",
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
          "Whether the database should be locked from editing in the Notion app UI. If not provided, the locked state will not be updated.",
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
        description:
          "The parent page or workspace to move the database to. If not provided, the database will not be moved.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "parent",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.Databases, :update_json_req_parent},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "The updated title of the database, if any. If not provided, the title will not be updated.",
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

  def __openapi_fields__(:update_json_req_parent) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "The type of parent.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:enum, ["page_id", "workspace"]},
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

  def __schema__(:create_json_req_parent) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:create_json_req_parent))
  end

  def __schema__(:update_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req))
  end

  def __schema__(:update_json_req_parent) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:update_json_req_parent))
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
