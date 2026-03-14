defmodule NotionSDK.FileUploadObjectResponse do
  @moduledoc """
  FileUploadObjectResponse

  ## Fields

    * `complete_url`: optional
    * `content_length`: required
    * `content_type`: required
    * `created_by`: required
    * `created_time`: required
    * `expiry_time`: required
    * `file_import_result`: optional
    * `filename`: required
    * `id`: required
    * `in_trash`: required
    * `last_edited_time`: required
    * `number_of_parts`: optional
    * `object`: Always `file_upload`
    * `status`: One of: `pending`, `uploaded`, `expired`, `failed`
    * `upload_url`: optional

  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          complete_url: String.t() | nil,
          content_length: integer | nil,
          content_type: String.t() | nil,
          created_by: NotionSDK.FileUploadObjectResponseCreatedBy.t(),
          created_time: DateTime.t(),
          expiry_time: DateTime.t() | nil,
          file_import_result: NotionSDK.FileUploadObjectResponseFileImportResult.t() | nil,
          filename: String.t() | nil,
          id: String.t(),
          in_trash: boolean,
          last_edited_time: DateTime.t(),
          number_of_parts: NotionSDK.FileUploadObjectResponseNumberOfParts.t() | nil,
          object: String.t(),
          status: String.t(),
          upload_url: String.t() | nil
        }

  defstruct [
    :complete_url,
    :content_length,
    :content_type,
    :created_by,
    :created_time,
    :expiry_time,
    :file_import_result,
    :filename,
    :id,
    :in_trash,
    :last_edited_time,
    :number_of_parts,
    :object,
    :status,
    :upload_url
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      complete_url: :string,
      content_length: {:union, [:integer, :null]},
      content_type: {:union, [:null, :string]},
      created_by: {NotionSDK.FileUploadObjectResponseCreatedBy, :t},
      created_time: {:string, "date-time"},
      expiry_time: {:union, [:null, string: "date-time"]},
      file_import_result: {NotionSDK.FileUploadObjectResponseFileImportResult, :t},
      filename: {:union, [:null, :string]},
      id: {:string, "uuid"},
      in_trash: :boolean,
      last_edited_time: {:string, "date-time"},
      number_of_parts: {NotionSDK.FileUploadObjectResponseNumberOfParts, :t},
      object: {:const, "file_upload"},
      status: {:enum, ["pending", "uploaded", "expired", "failed"]},
      upload_url: :string
    ]
  end

  (
    @doc false
    @spec __openapi_fields__(atom) :: [map()]
  )

  def __openapi_fields__(type \\ :t)

  def __openapi_fields__(:t) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "complete_url",
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
        name: "content_length",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:integer, :null]},
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
        name: "content_type",
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
        name: "created_by",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.FileUploadObjectResponseCreatedBy, :t},
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
        name: "created_time",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "date-time"},
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
        name: "expiry_time",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, string: "date-time"]},
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
        name: "file_import_result",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.FileUploadObjectResponseFileImportResult, :t},
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
        name: "filename",
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "in_trash",
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
        name: "last_edited_time",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "date-time"},
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
        name: "number_of_parts",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.FileUploadObjectResponseNumberOfParts, :t},
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
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "file_upload"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "One of: `pending`, `uploaded`, `expired`, `failed`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "status",
        nullable: false,
        read_only: false,
        required: true,
        type: {:enum, ["pending", "uploaded", "expired", "failed"]},
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
        name: "upload_url",
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

  def __schema__(type \\ :t)

  def __schema__(:t) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:t))
  end

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :t)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
