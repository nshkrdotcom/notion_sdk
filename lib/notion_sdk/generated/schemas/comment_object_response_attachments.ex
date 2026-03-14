defmodule NotionSDK.CommentObjectResponseAttachments do
  @moduledoc """
  CommentObjectResponseAttachments

  ## Fields

    * `category`: One of: `audio`, `image`, `pdf`, `productivity`, `video`
    * `file`: required

  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{category: String.t(), file: NotionSDK.InternalFileResponse.t()}

  defstruct [:category, :file]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      category: {:enum, ["audio", "image", "pdf", "productivity", "video"]},
      file: {NotionSDK.InternalFileResponse, :t}
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
        description: "One of: `audio`, `image`, `pdf`, `productivity`, `video`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "category",
        nullable: false,
        read_only: false,
        required: true,
        type: {:enum, ["audio", "image", "pdf", "productivity", "video"]},
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
        name: "file",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.InternalFileResponse, :t},
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
