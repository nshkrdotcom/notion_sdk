defmodule NotionSDK.LinkToPage do
  @moduledoc """
  Generated Notion Sdk type for link to page.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [:link_to_page]
  defstruct [:link_to_page, :object, :type]

  @type t :: %__MODULE__{
          link_to_page: NotionSDK.CommentId.t() | NotionSDK.DatabaseId.t() | NotionSDK.PageId.t(),
          object: String.t(),
          type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      link_to_page:
        {:union, [{NotionSDK.CommentId, :t}, {NotionSDK.DatabaseId, :t}, {NotionSDK.PageId, :t}]},
      object: {:const, "block"},
      type: {:const, "link_to_page"}
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
        name: "link_to_page",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [{NotionSDK.CommentId, :t}, {NotionSDK.DatabaseId, :t}, {NotionSDK.PageId, :t}]},
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
        required: false,
        type: {:const, "block"},
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
        required: false,
        type: {:const, "link_to_page"},
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
