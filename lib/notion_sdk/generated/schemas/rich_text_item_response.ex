defmodule NotionSDK.RichTextItemResponse do
  @moduledoc """
  RichTextItemResponse

  ## Fields

    * `annotations`: optional
    * `href`: A URL that the rich text object links to or mentions.
    * `plain_text`: The plain text content of the rich text object, without any styling.

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          annotations: NotionSDK.AnnotationResponse.t() | nil,
          href: String.t() | nil,
          plain_text: String.t() | nil
        }

  defstruct [:annotations, :href, :plain_text]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      annotations: {NotionSDK.AnnotationResponse, :t},
      href: {:union, [:null, :string]},
      plain_text: :string
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
        name: "annotations",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.AnnotationResponse, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "A URL that the rich text object links to or mentions.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "href",
        nullable: false,
        read_only: false,
        required: false,
        type: {:union, [:null, :string]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The plain text content of the rich text object, without any styling.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "plain_text",
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
