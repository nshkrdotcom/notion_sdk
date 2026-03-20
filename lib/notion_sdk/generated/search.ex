defmodule NotionSDK.Search do
  @moduledoc """
  Generated Notion Sdk operations for search.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @search_partition_spec %{
    path: [],
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
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Search by title
       ## Source Context
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
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec search(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def search(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)
    operation = build_search_operation(params)
    operation = NotionSDK.Client.runtime_operation(client, operation, execute_opts)

    Pristine.execute(runtime_client, operation, execute_opts)
  end

  @spec stream_search(term(), map(), keyword()) :: Enumerable.t()
  def stream_search(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    execute_opts = NotionSDK.Client.runtime_execute_opts(client, opts)

    Stream.resource(
      fn -> build_search_operation(params) end,
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

  defp build_search_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @search_partition_spec)

    Pristine.Operation.new(%{
      id: "search/search",
      method: :post,
      path_template: "/v1/search",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.Search, :search_json_req},
      response_schemas: %{
        200 => {NotionSDK.Search, :search_200_json_resp},
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
        telemetry_event: [:notion_sdk, :search, :search],
        timeout_ms: nil
      },
      pagination: %{
        default_limit: nil,
        items_path: ["results"],
        request_mapping: %{cursor_location: :body, cursor_param: "start_cursor"},
        response_mapping: %{cursor_path: ["next_cursor"]},
        strategy: :cursor
      }
    })
  end

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :search_200_json_resp)

  def __fields__(:search_200_json_resp) do
    [
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      page_or_data_source: {NotionSDK.EmptyObject, :t},
      results:
        {:array,
         {:union,
          [
            {NotionSDK.DataSourceObjectResponse, :t},
            {NotionSDK.PageObjectResponse, :t},
            {NotionSDK.PartialDataSourceObjectResponse, :t},
            {NotionSDK.PartialPageObjectResponse, :t}
          ]}},
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
    [
      property: {:const, "object"},
      value: {:enum, ["page", "data_source"]}
    ]
  end

  def __fields__(:search_json_req_sort) do
    [
      direction: {:enum, ["ascending", "descending"]},
      timestamp: {:const, "last_edited_time"}
    ]
  end

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
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
        type:
          {:array,
           {:union,
            [
              {NotionSDK.DataSourceObjectResponse, :t},
              {NotionSDK.PageObjectResponse, :t},
              {NotionSDK.PartialDataSourceObjectResponse, :t},
              {NotionSDK.PartialPageObjectResponse, :t}
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

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :search_200_json_resp) when is_atom(type) do
    RuntimeSchema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :search_200_json_resp)

  def decode(data, type) when is_map(data) and is_atom(type) do
    RuntimeSchema.decode_module_type(__MODULE__, type, data)
  end
end
