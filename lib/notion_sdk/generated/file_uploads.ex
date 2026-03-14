defmodule NotionSDK.FileUploads do
  @moduledoc """
  Provides API endpoints related to file uploads

  ## Operations

    * get `/v1/file_uploads`
    * post `/v1/file_uploads`
    * get `/v1/file_uploads/{file_upload_id}`
    * post `/v1/file_uploads/{file_upload_id}/complete`
    * post `/v1/file_uploads/{file_upload_id}/send`
  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  use Pristine.OpenAPI.Operation

  @doc """
  post `/v1/file_uploads/{file_upload_id}/complete`

  ## Source Context
  Complete a file upload
  ### Resources

    * [Complete a file upload](https://developers.notion.com/reference/complete-a-file-upload)

  ## Security

    * `bearerAuth`

  ## Resources

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
  @spec complete(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.FileUploadObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec complete(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.FileUploadObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def complete(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"file_upload_id", :file_upload_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.FileUploads, :complete},
      path_template: "/v1/file_uploads/{file_upload_id}/complete",
      url: render_path("/v1/file_uploads/{file_upload_id}/complete", partition.path_params),
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {NotionSDK.FileUploadObjectResponse, :t}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ],
      resource: "file_upload_control",
      retry: "notion.write",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @doc """
  post `/v1/file_uploads`

  ## Source Context
  Create a file upload
  Use this API to initiate the process of [uploading a file](https://developers.notion.com/guides/data-apis/working-with-files-and-media) to your Notion workspace.

  ### Resources

    * [uploading a file](https://developers.notion.com/guides/data-apis/working-with-files-and-media)
    * [Create a file upload](https://developers.notion.com/reference/create-a-file-upload)

  ## Request Body
  **Content Types**: `application/json`

  ## Security

    * `bearerAuth`

  ## Resources

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
  @spec create(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.FileUploadObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec create(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.FileUploadObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def create(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
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
        form_data: %{mode: :none},
        path: [],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.FileUploads, :create},
      path_template: "/v1/file_uploads",
      url: render_path("/v1/file_uploads", partition.path_params),
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"application/json", {NotionSDK.FileUploads, :create_json_req}}],
      response: [
        {200, {NotionSDK.FileUploadObjectResponse, :t}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ],
      resource: "file_upload_control",
      retry: "notion.write",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @type list_200_json_resp :: %{
          file_upload: NotionSDK.EmptyObject.t(),
          has_more: boolean,
          next_cursor: String.t() | nil,
          object: String.t(),
          results: [NotionSDK.FileUploadObjectResponse.t()],
          type: String.t()
        }

  @doc """
  get `/v1/file_uploads`

  ## Source Context
  List file uploads
  Use this API to retrieve [file uploads](https://developers.notion.com/reference/file-upload) for the current bot integration, sorted by most recent first.

  ### Resources

    * [file uploads](https://developers.notion.com/reference/file-upload)
    * [List file uploads](https://developers.notion.com/reference/list-file-uploads)

  ## Options

    * `status`
    * `start_cursor`
    * `page_size`

  ## Security

    * `bearerAuth`

  ## Resources

    * [List file uploads](https://developers.notion.com/reference/list-file-uploads)

  ## Code Samples

  TypeScript SDK
  ```javascript
  import { Client } from "@notionhq/client"

  const notion = new Client({ auth: process.env.NOTION_API_KEY })

  const response = await notion.fileUploads.list({
    start_cursor: undefined,
    page_size: 50
  })
  ```
  """
  @spec list(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.FileUploads.list_200_json_resp()} | {:error, NotionSDK.Error.t()}
  @spec list(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.FileUploads.list_200_json_resp()} | {:error, NotionSDK.Error.t()}
  def list(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [],
        query: [{"status", :status}, {"start_cursor", :start_cursor}, {"page_size", :page_size}]
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.FileUploads, :list},
      path_template: "/v1/file_uploads",
      url: render_path("/v1/file_uploads", partition.path_params),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {NotionSDK.FileUploads, :list_200_json_resp}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ],
      resource: "file_upload_control",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @doc """
  get `/v1/file_uploads/{file_upload_id}`

  ## Source Context
  Retrieve a file upload
  Use this API to get the details of a [File Upload](https://developers.notion.com/reference/file-upload) object.

  ### Resources

    * [File Upload](https://developers.notion.com/reference/file-upload)
    * [Retrieve a file upload](https://developers.notion.com/reference/retrieve-a-file-upload)

  ## Security

    * `bearerAuth`

  ## Resources

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
  @spec retrieve(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.FileUploadObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec retrieve(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.FileUploadObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def retrieve(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{mode: :none},
        path: [{"file_upload_id", :file_upload_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.FileUploads, :retrieve},
      path_template: "/v1/file_uploads/{file_upload_id}",
      url: render_path("/v1/file_uploads/{file_upload_id}", partition.path_params),
      method: :get,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      response: [
        {200, {NotionSDK.FileUploadObjectResponse, :t}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ],
      resource: "file_upload_control",
      retry: "notion.read",
      circuit_breaker: "core_api",
      rate_limit: "notion.integration"
    })
  end

  @doc """
  post `/v1/file_uploads/{file_upload_id}/send`

  ## Source Context
  Send a file upload
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

  ## Request Body
  **Content Types**: `multipart/form-data`

  ## Security

    * `bearerAuth`

  ## Resources

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
  @spec send(client :: NotionSDK.Client.t()) ::
          {:ok, NotionSDK.FileUploadObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  @spec send(client :: NotionSDK.Client.t(), params :: map()) ::
          {:ok, NotionSDK.FileUploadObjectResponse.t()} | {:error, NotionSDK.Error.t()}
  def send(client, params \\ %{}) when is_map(params) do
    partition =
      partition(params, %{
        auth: {"auth", :auth},
        body: %{mode: :none},
        form_data: %{keys: [{"file", :file}, {"part_number", :part_number}], mode: :keys},
        path: [{"file_upload_id", :file_upload_id}],
        query: []
      })

    NotionSDK.Client.request(client, %{
      args: params,
      call: {NotionSDK.FileUploads, :send},
      path_template: "/v1/file_uploads/{file_upload_id}/send",
      url: render_path("/v1/file_uploads/{file_upload_id}/send", partition.path_params),
      method: :post,
      path_params: partition.path_params,
      query: partition.query,
      body: partition.body,
      form_data: partition.form_data,
      auth: partition.auth,
      security: [%{"bearerAuth" => []}],
      request: [{"multipart/form-data", {NotionSDK.FileUploads, :send__req}}],
      response: [
        {200, {NotionSDK.FileUploadObjectResponse, :t}},
        {400, {NotionSDK.ErrorApi400, :t}},
        {401, {NotionSDK.ErrorApi401, :t}},
        {403, {NotionSDK.ErrorApi403, :t}},
        {404, {NotionSDK.ErrorApi404, :t}},
        {409, {NotionSDK.ErrorApi409, :t}},
        {429, {NotionSDK.ErrorApi429, :t}},
        {500, {NotionSDK.ErrorApi500, :t}},
        {503, {NotionSDK.ErrorApi503, :t}}
      ],
      resource: "file_upload_send",
      retry: "notion.file_upload_send",
      circuit_breaker: "file_upload_send",
      rate_limit: "notion.integration"
    })
  end

  @doc false
  @spec __fields__(atom) :: keyword
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
      results: [{NotionSDK.FileUploadObjectResponse, :t}],
      type: {:const, "file_upload"}
    ]
  end

  def __fields__(:send__req) do
    [file: :map, part_number: :string]
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
        extensions: nil,
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
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
        extensions: nil,
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
        type: {:union, [:null, string: "uuid"]},
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
        type: [{NotionSDK.FileUploadObjectResponse, :t}],
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
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

  (
    @doc false
    @spec __schema__(atom) :: Sinter.Schema.t()
  )

  def __schema__(type \\ :create_json_req)

  def __schema__(:create_json_req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:create_json_req))
  end

  def __schema__(:list_200_json_resp) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:list_200_json_resp))
  end

  def __schema__(:send__req) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:send__req))
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
