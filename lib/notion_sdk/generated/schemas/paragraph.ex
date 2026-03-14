defmodule NotionSDK.Paragraph do
  @moduledoc """
  Paragraph

  ## Fields

    * `object`: optional
    * `paragraph`: required
    * `type`: optional

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          object: String.t() | nil,
          paragraph:
            NotionSDK.ContentWithRichTextAndColorRequest.t()
            | NotionSDK.ContentWithSingleLevelOfChildrenRequest.t()
            | NotionSDK.ParagraphParagraph.t(),
          type: String.t() | nil
        }

  defstruct [:object, :paragraph, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      object: {:const, "block"},
      paragraph:
        {:union,
         [
           {NotionSDK.ParagraphParagraph, :t},
           {NotionSDK.ContentWithRichTextAndColorRequest, :t},
           union: [
             {NotionSDK.ContentWithRichTextAndColorRequest, :t},
             {NotionSDK.ContentWithSingleLevelOfChildrenRequest, :t},
             union: [
               {NotionSDK.ContentWithSingleLevelOfChildrenRequest, :t},
               {NotionSDK.ParagraphParagraph, :t}
             ]
           ]
         ]},
      type: {:const, "paragraph"}
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
        extensions: nil,
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
        extensions: nil,
        external_docs: nil,
        name: "paragraph",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.ParagraphParagraph, :t},
             {NotionSDK.ContentWithRichTextAndColorRequest, :t},
             union: [
               {NotionSDK.ContentWithRichTextAndColorRequest, :t},
               {NotionSDK.ContentWithSingleLevelOfChildrenRequest, :t},
               union: [
                 {NotionSDK.ContentWithSingleLevelOfChildrenRequest, :t},
                 {NotionSDK.ParagraphParagraph, :t}
               ]
             ]
           ]},
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
        required: false,
        type: {:const, "paragraph"},
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
