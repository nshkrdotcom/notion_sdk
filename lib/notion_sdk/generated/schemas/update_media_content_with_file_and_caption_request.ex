defmodule NotionSDK.UpdateMediaContentWithFileAndCaptionRequest do
  @moduledoc """
  Generated Notion Sdk type for update media content with file and caption request.
  """

  @enforce_keys []
  defstruct [:caption, :external, :file_upload]

  @type t :: %__MODULE__{
          caption: [NotionSDK.RichTextItemRequest.t()],
          external: NotionSDK.ExternalFileRequest.t(),
          file_upload: NotionSDK.FileUploadIdRequest.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      caption: {:array, {NotionSDK.RichTextItemRequest, :t}},
      external: {NotionSDK.ExternalFileRequest, :t},
      file_upload: {NotionSDK.FileUploadIdRequest, :t}
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
        name: "external",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.ExternalFileRequest, :t},
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
        name: "file_upload",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.FileUploadIdRequest, :t},
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
    Pristine.Runtime.Schema.decode_module_type(
      NotionSDK.UpdateMediaContentWithFileAndCaptionRequest,
      type,
      data
    )
  end
end
