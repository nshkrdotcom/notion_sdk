defmodule NotionSDK.UpdateMediaContentWithFileAndCaptionRequest do
  @moduledoc """
  UpdateMediaContentWithFileAndCaptionRequest

  ## Fields

    * `caption`: optional
    * `external`: optional
    * `file_upload`: optional

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          caption: [NotionSDK.RichTextItemRequest.t()] | nil,
          external: NotionSDK.ExternalFileRequest.t() | nil,
          file_upload: NotionSDK.FileUploadIdRequest.t() | nil
        }

  defstruct [:caption, :external, :file_upload]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      caption: [{NotionSDK.RichTextItemRequest, :t}],
      external: {NotionSDK.ExternalFileRequest, :t},
      file_upload: {NotionSDK.FileUploadIdRequest, :t}
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
        name: "caption",
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
