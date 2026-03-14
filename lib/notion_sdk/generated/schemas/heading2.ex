defmodule NotionSDK.Heading2 do
  @moduledoc """
  Heading2

  ## Fields

    * `heading_2`: required
    * `object`: optional
    * `type`: optional

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          heading_2:
            NotionSDK.HeaderContentWithRichTextAndColorRequest.t()
            | NotionSDK.HeaderContentWithSingleLevelOfChildrenRequest.t()
            | NotionSDK.Heading2Heading2.t(),
          object: String.t() | nil,
          type: String.t() | nil
        }

  defstruct [:heading_2, :object, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      heading_2:
        {:union,
         [
           {NotionSDK.Heading2Heading2, :t},
           {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
           union: [
             {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
             {NotionSDK.HeaderContentWithSingleLevelOfChildrenRequest, :t},
             union: [
               {NotionSDK.Heading2Heading2, :t},
               {NotionSDK.HeaderContentWithSingleLevelOfChildrenRequest, :t}
             ]
           ]
         ]},
      object: {:const, "block"},
      type: {:const, "heading_2"}
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
        name: "heading_2",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.Heading2Heading2, :t},
             {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
             union: [
               {NotionSDK.HeaderContentWithRichTextAndColorRequest, :t},
               {NotionSDK.HeaderContentWithSingleLevelOfChildrenRequest, :t},
               union: [
                 {NotionSDK.Heading2Heading2, :t},
                 {NotionSDK.HeaderContentWithSingleLevelOfChildrenRequest, :t}
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
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "heading_2"},
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
