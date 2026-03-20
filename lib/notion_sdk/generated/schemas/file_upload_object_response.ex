defmodule NotionSDK.FileUploadObjectResponse do
  @moduledoc """
  Generated Notion Sdk type for file upload object response.
  """

  @enforce_keys [
    :content_length,
    :content_type,
    :created_by,
    :created_time,
    :expiry_time,
    :filename,
    :id,
    :in_trash,
    :last_edited_time,
    :object,
    :status
  ]
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

  @type t :: %__MODULE__{
          complete_url: String.t(),
          content_length: integer() | nil,
          content_type: nil | String.t(),
          created_by: NotionSDK.FileUploadObjectResponseCreatedBy.t(),
          created_time: DateTime.t(),
          expiry_time: nil | DateTime.t(),
          file_import_result: NotionSDK.FileUploadObjectResponseFileImportResult.t(),
          filename: nil | String.t(),
          id: String.t(),
          in_trash: boolean(),
          last_edited_time: DateTime.t(),
          number_of_parts: NotionSDK.FileUploadObjectResponseNumberOfParts.t(),
          object: String.t(),
          status: String.t(),
          upload_url: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
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

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
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

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :t) when is_atom(type) do
    Pristine.Runtime.Schema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :t)

  def decode(data, type) when is_map(data) and is_atom(type) do
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.FileUploadObjectResponse, type, data)
  end
end
