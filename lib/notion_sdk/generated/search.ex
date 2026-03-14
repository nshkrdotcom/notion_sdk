defmodule NotionSDK.Search do
  @moduledoc """
  Provides API endpoint related to search

  ## Operations

    * Search by title
  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  use Pristine.OpenAPI.Operation
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type search_200_json_resp :: %{
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
  Search by title

  ## Source Context
  Search by title
  Searches all parent or child pages and data_sources that have been shared with an integration.

  ### Warnings

  To search a specific data\_source — not all sources shared with the integration — use the [Query a data\_source](https://developers.notion.com/reference/query-a-data-source) endpoint instead.

  ### Notes

  The Search endpoint supports pagination. To learn more about working with [paginated](https://developers.notion.com/reference/intro#pagination) responses, see the pagination section of the Notion API Introduction.

  ### Errors

  Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.

  ### Resources

    * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
    * [paginated](https://developers.notion.com/reference/intro#pagination)
    * [Query a data\_source](https://developers.notion.com/reference/query-a-data-source)
    * [Search by title](https://developers.notion.com/reference/post-search)

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

    * [Search by title](https://developers.notion.com/reference/post-search)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.search({
    query: "meeting notes",
    filter: {
      property: "object",
      value: "page"
    },
    sort: {
      direction: "descending",
      timestamp: "last_edited_time"
    }
  })
  ```
  """
  @spec search(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.Search.search_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec search(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.Search.search_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def search(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{
          keys: [
            {"filter", :filter},
            {"page_size", :page_size},
            {"query", :query},
            {"sort", :sort},
            {"start_cursor", :start_cursor}
          ],
          mode: :keys
        },
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.Search, :search},
      path_template: "/v1/search",
      url: render_path("/v1/search", partition.path_params),
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"application/json", {NotionSDK.Search, :search_json_req}}],
      response: [
        {200, {NotionSDK.Search, :search_200_json_resp}},
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
  def __fields__(type \\ :search_200_json_resp)

  def __fields__(:search_200_json_resp) do
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

  def __fields__(:search_json_req) do
    [
      filter: {NotionSDK.Search, :search_json_req_filter},
      page_size: :number,
      query: :string,
      sort: {NotionSDK.Search, :search_json_req_sort},
      start_cursor: {:string, "uuid"}
    ]
  end

  def __fields__(:search_json_req_filter) do
    [property: {:const, "object"}, value: {:enum, ["page", "data_source"]}]
  end

  def __fields__(:search_json_req_sort) do
    [direction: {:enum, ["ascending", "descending"]}, timestamp: {:const, "last_edited_time"}]
  end

  (
    @doc false
    @spec __openapi_fields__(atom) :: [map()]
  )

  def __openapi_fields__(type \\ :search_200_json_resp)

  def __openapi_fields__(:search_200_json_resp) do
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

  def __openapi_fields__(:search_json_req) do
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
        type: {NotionSDK.Search, :search_json_req_filter},
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "query",
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
        name: "sort",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.Search, :search_json_req_sort},
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

  def __openapi_fields__(:search_json_req_filter) do
    [
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
        type: {:const, "object"},
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
        name: "value",
        nullable: false,
        read_only: false,
        required: true,
        type: {:enum, ["page", "data_source"]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:search_json_req_sort) do
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
        name: "timestamp",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "last_edited_time"},
        write_only: false
      }
    ]
  end

  (
    @doc false
    @spec __schema__(atom) :: Sinter.Schema.t()
  )

  def __schema__(type \\ :search_200_json_resp)

  def __schema__(:search_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:search_200_json_resp))
  end

  def __schema__(:search_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:search_json_req))
  end

  def __schema__(:search_json_req_filter) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:search_json_req_filter))
  end

  def __schema__(:search_json_req_sort) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:search_json_req_sort))
  end

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :search_200_json_resp)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
