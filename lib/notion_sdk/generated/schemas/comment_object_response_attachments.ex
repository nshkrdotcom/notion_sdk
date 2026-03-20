defmodule NotionSDK.CommentObjectResponseAttachments do
  @moduledoc """
  Generated Notion Sdk type for comment object response attachments.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [:category, :file]
  defstruct [:category, :file]

  @type t :: %__MODULE__{
          category: String.t(),
          file: NotionSDK.InternalFileResponse.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      category: {:enum, ["audio", "image", "pdf", "productivity", "video"]},
      file: {NotionSDK.InternalFileResponse, :t}
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

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :t) when is_atom(type) do
    RuntimeSchema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :t)

  def decode(data, type) when is_map(data) and is_atom(type) do
    RuntimeSchema.decode_module_type(__MODULE__, type, data)
  end
end
