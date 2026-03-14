defmodule NotionSDK.LinkToPage do
  @moduledoc """
  Link To Page

  ## Fields

    * `link_to_page`: required
    * `object`: optional
    * `type`: optional

  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %{
          link_to_page: NotionSDK.CommentId.t() | NotionSDK.DatabaseId.t() | NotionSDK.PageId.t(),
          object: String.t() | nil,
          type: String.t() | nil
        }

  defstruct [:link_to_page, :object, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      link_to_page:
        {:union, [{NotionSDK.PageId, :t}, {NotionSDK.DatabaseId, :t}, {NotionSDK.CommentId, :t}]},
      object: {:const, "block"},
      type: {:const, "link_to_page"}
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
        name: "link_to_page",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [{NotionSDK.PageId, :t}, {NotionSDK.DatabaseId, :t}, {NotionSDK.CommentId, :t}]},
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
