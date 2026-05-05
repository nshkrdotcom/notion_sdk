defmodule NotionSDK.FileUploads do
  @moduledoc """
  Generated Notion Sdk operations module `NotionSDK.FileUploads`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  alias Pristine.SDK.OpenAPI.Client, as: OpenAPIClient

  @complete_partition_spec %{
    path: [{"file_upload_id", :file_upload_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Complete a file upload
       ## Source Context
       ### Resources

       * [Complete a file upload](https://developers.notion.com/reference/complete-a-file-upload)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.fileUploads.complete({
       file_upload_id: "a02fc1d3-db8b-45c5-a222-27595b15aea7"
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec complete(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def complete(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_complete_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  defp build_complete_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @complete_partition_spec)

    %{
      id: "file_uploads/complete",
      args: params,
      call: {__MODULE__, :complete},
      opts: opts,
      method: :post,
      path_template: "/v1/file_uploads/{file_upload_id}/complete",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.FileUploadObjectResponse, :t},
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
      resource: "file_upload_control",
      retry: "notion.write",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :file_uploads, :complete],
      timeout: nil,
      pagination: nil
    }
  end

  @create_partition_spec %{
    path: [],
    auth: {"auth", :auth},
    body: %{
      keys: [
        {"content_type", :content_type},
        {"external_url", :external_url},
        {"filename", :filename},
        {"mode", :mode},
        {"number_of_parts", :number_of_parts}
      ],
      mode: :keys
    },
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Create a file upload
       ## Source Context
       Use this API to initiate the process of [uploading a file](https://developers.notion.com/guides/data-apis/working-with-files-and-media) to your Notion workspace.

       ### Resources

       * [uploading a file](https://developers.notion.com/guides/data-apis/working-with-files-and-media)
       * [Create a file upload](https://developers.notion.com/reference/create-a-file-upload)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.fileUploads.create({
       mode: "single_part",
       filename: "document.pdf",
       content_type: "application/pdf"
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
      id: "file_uploads/create",
      args: params,
      call: {__MODULE__, :create},
      opts: opts,
      method: :post,
      path_template: "/v1/file_uploads",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.FileUploads, :create_json_req},
      response_schemas: %{
        200 => {NotionSDK.FileUploadObjectResponse, :t},
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
      resource: "file_upload_control",
      retry: "notion.write",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :file_uploads, :create],
      timeout: nil,
      pagination: nil
    }
  end

  @list_partition_spec %{
    path: [],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [
      {"status", :status},
      {"start_cursor", :start_cursor},
      {"page_size", :page_size}
    ],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc "List file uploads\n## Source Context\nUse this API to retrieve [file uploads](https://developers.notion.com/reference/file-upload) for the current bot integration, sorted by most recent first.\n\n### Resources\n\n  * [file uploads](https://developers.notion.com/reference/file-upload)\n  * [List file uploads](https://developers.notion.com/reference/list-file-uploads)\n## Code Samples\n\nTypeScript SDK\n```javascript\nimport { Client } from \"@notionhq/client\"\n\nconst notion = new Client({ auth: process.env.NOTION_API_KEY })\n\nconst response = await notion.fileUploads.list({\n  start_cursor: undefined,\n  page_size: 50\n})\n```\n"
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
      id: "file_uploads/list",
      args: params,
      call: {__MODULE__, :list},
      opts: opts,
      method: :get,
      path_template: "/v1/file_uploads",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.FileUploads, :list_200_json_resp},
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
      resource: "file_upload_control",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :file_uploads, :list],
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
    path: [{"file_upload_id", :file_upload_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Retrieve a file upload
       ## Source Context
       Use this API to get the details of a [File Upload](https://developers.notion.com/reference/file-upload) object.

       ### Resources

       * [File Upload](https://developers.notion.com/reference/file-upload)
       * [Retrieve a file upload](https://developers.notion.com/reference/retrieve-a-file-upload)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       const response = await notion.fileUploads.retrieve({
       file_upload_id: "a02fc1d3-db8b-45c5-a222-27595b15aea7"
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
      id: "file_uploads/retrieve",
      args: params,
      call: {__MODULE__, :retrieve},
      opts: opts,
      method: :get,
      path_template: "/v1/file_uploads/{file_upload_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 => {NotionSDK.FileUploadObjectResponse, :t},
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
      resource: "file_upload_control",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :file_uploads, :retrieve],
      timeout: nil,
      pagination: nil
    }
  end

  @send_partition_spec %{
    path: [{"file_upload_id", :file_upload_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{
      keys: [{"file", :file}, {"part_number", :part_number}],
      mode: :keys
    }
  }

  @doc ~S"""
       Send a file upload
       ## Source Context
       When `mode=multi_part`, each part must include a form field `part_number` to indicate which part is being sent. Parts may be sent concurrently up to standard Notion API [rate limits](https://developers.notion.com/reference/request-limits), and may be sent out of order as long as all parts (1, ..., `part_number`) are successfully sent before calling the [complete file upload API](https://developers.notion.com/reference/complete-a-file-upload).

       ### Notes

       The use of multipart form data is unique to this endpoint. Other Notion APIs, including [Create a file upload](https://developers.notion.com/reference/create-a-file-upload) and [Complete a file upload](https://developers.notion.com/reference/complete-a-file-upload), use JSON parameters.
       Include a `boundary` with the `Content-Type` header of your request as per [RFC 2388](https://datatracker.ietf.org/doc/html/rfc2388). Most request libraries (e.g. `fetch`, `ky`) automatically handle this as long as you provide a form data object but don't overwrite the `Content-Type` explicitly.
       For more tips and examples, view the [file upload guide](https://developers.notion.com/guides/data-apis/uploading-small-files#step-2-upload-file-contents).

       ### Overview

       The maximum allowed length of a file name is 900 bytes, including any file extension included in the file name or inferred based on the `content_type`. However, we recommend using shorter names for performance and easier file management and lookup using the [List file uploads](https://developers.notion.com/reference/list-file-uploads) API.

       ### Resources

       * [Create a file upload](https://developers.notion.com/reference/create-a-file-upload)
       * [Complete a file upload](https://developers.notion.com/reference/complete-a-file-upload)
       * [RFC 2388](https://datatracker.ietf.org/doc/html/rfc2388)
       * [file upload guide](https://developers.notion.com/guides/data-apis/uploading-small-files#step-2-upload-file-contents)
       * [rate limits](https://developers.notion.com/reference/request-limits)
       * [complete file upload API](https://developers.notion.com/reference/complete-a-file-upload)
       * [List file uploads](https://developers.notion.com/reference/list-file-uploads)
       * [Send a file upload](https://developers.notion.com/reference/send-a-file-upload)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client({ auth: process.env.NOTION_API_KEY })

       import { readFile } from "fs/promises"
       import { basename } from "path"

       const filePath = "./document.pdf"

       const response = await notion.fileUploads.send({
       file_upload_id: "a02fc1d3-db8b-45c5-a222-27595b15aea7",
       file: {
         filename: basename(filePath),
         data: new Blob([await readFile(filePath)], {
           type: "application/pdf"
         })
       }
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec send(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def send(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_send_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  defp build_send_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @send_partition_spec)

    %{
      id: "file_uploads/send",
      args: params,
      call: {__MODULE__, :send},
      opts: opts,
      method: :post,
      path_template: "/v1/file_uploads/{file_upload_id}/send",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.FileUploads, :send__req},
      response_schemas: %{
        200 => {NotionSDK.FileUploadObjectResponse, :t},
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
      resource: "file_upload_send",
      retry: "notion.file_upload_send",
      circuit_breaker: "file_upload_send",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :file_uploads, :send],
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
      content_type: :string,
      external_url: :string,
      filename: :string,
      mode: {:enum, ["single_part", "multi_part", "external_url"]},
      number_of_parts: :integer
    ]
  end

  def __fields__(:list_200_json_resp) do
    [
      file_upload: {NotionSDK.EmptyObject, :t},
      has_more: :boolean,
      next_cursor: {:union, [:null, string: "uuid"]},
      object: {:const, "list"},
      results: {:array, {NotionSDK.FileUploadObjectResponse, :t}},
      type: {:const, "file_upload"}
    ]
  end

  def __fields__(:send__req) do
    [
      file: :map,
      part_number: :string
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
        description:
          "MIME type of the file to be created. Recommended when sending the file in multiple parts. Must match the content type of the file that's sent, and the extension of the `filename` parameter if any.",
        example: nil,
        examples: ["application/pdf"],
        extensions: %{},
        external_docs: nil,
        name: "content_type",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "When `mode` is `external_url`, provide the HTTPS URL of a publicly accessible file to import into your workspace.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "external_url",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Name of the file to be created. Required when `mode` is `multi_part`. Otherwise optional, and used to override the filename. Must include an extension, or have one inferred from the `content_type` parameter.",
        example: nil,
        examples: ["business_summary.pdf"],
        extensions: %{},
        external_docs: nil,
        name: "filename",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "How the file is being sent. Use `multi_part` for files larger than 20MB. Use `external_url` for files that are temporarily hosted publicly elsewhere. Default is `single_part`.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "mode",
        nullable: false,
        read_only: false,
        required: false,
        type: {:enum, ["single_part", "multi_part", "external_url"]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "When `mode` is `multi_part`, the number of parts you are uploading. This must match the number of parts as well as the final `part_number` you send.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "number_of_parts",
        nullable: false,
        read_only: false,
        required: false,
        type: :integer,
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
        name: "file_upload",
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
        type: {:array, {NotionSDK.FileUploadObjectResponse, :t}},
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
        required: true,
        type: {:const, "file_upload"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:send__req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "The raw binary file contents to upload.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "file",
        nullable: false,
        read_only: false,
        required: true,
        type: :map,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "When uploading files greater than 20MB in parts, this is the current part number. Must be an integer between 1 and 1,000.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "part_number",
        nullable: false,
        read_only: false,
        required: false,
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
