defmodule NotionSDK.BulletedListItem do
  @moduledoc """
  BulletedListItem

  ## Fields

    * `bulleted_list_item`: required
    * `object`: optional
    * `type`: optional

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          bulleted_list_item:
            NotionSDK.BulletedListItemBulletedListItem.t()
            | NotionSDK.ContentWithRichTextAndColorRequest.t()
            | NotionSDK.ContentWithSingleLevelOfChildrenRequest.t(),
          object: String.t() | nil,
          type: String.t() | nil
        }

  defstruct [:bulleted_list_item, :object, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      bulleted_list_item:
        {:union,
         [
           {NotionSDK.BulletedListItemBulletedListItem, :t},
           {NotionSDK.ContentWithRichTextAndColorRequest, :t},
           union: [
             {NotionSDK.ContentWithRichTextAndColorRequest, :t},
             {NotionSDK.ContentWithSingleLevelOfChildrenRequest, :t},
             union: [
               {NotionSDK.BulletedListItemBulletedListItem, :t},
               {NotionSDK.ContentWithSingleLevelOfChildrenRequest, :t}
             ]
           ]
         ]},
      object: {:const, "block"},
      type: {:const, "bulleted_list_item"}
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
        name: "bulleted_list_item",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.BulletedListItemBulletedListItem, :t},
             {NotionSDK.ContentWithRichTextAndColorRequest, :t},
             union: [
               {NotionSDK.ContentWithRichTextAndColorRequest, :t},
               {NotionSDK.ContentWithSingleLevelOfChildrenRequest, :t},
               union: [
                 {NotionSDK.BulletedListItemBulletedListItem, :t},
                 {NotionSDK.ContentWithSingleLevelOfChildrenRequest, :t}
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
        type: {:const, "bulleted_list_item"},
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
