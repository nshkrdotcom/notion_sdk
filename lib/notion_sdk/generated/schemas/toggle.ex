defmodule NotionSDK.Toggle do
  @moduledoc """
  Generated Notion Sdk type for toggle.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [:toggle]
  defstruct [:object, :toggle, :type]

  @type t :: %__MODULE__{
          object: String.t(),
          toggle: NotionSDK.ContentWithRichTextAndColorRequest.t(),
          type: String.t()
        }

  @type t_toggle :: map()
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      object: {:const, "block"},
      toggle: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
      type: {:const, "toggle"}
    ]
  end

  def __fields__(:t_toggle) do
    [
      children:
        {:array,
         {:union,
          [
            {NotionSDK.Audio, :t},
            {NotionSDK.Bookmark, :t},
            {NotionSDK.Breadcrumb, :t},
            {NotionSDK.BulletedListItem, :t},
            {NotionSDK.Callout, :t},
            {NotionSDK.Code, :t},
            {NotionSDK.Divider, :t},
            {NotionSDK.Embed, :t},
            {NotionSDK.Equation, :t},
            {NotionSDK.File, :t},
            {NotionSDK.Heading1, :t},
            {NotionSDK.Heading2, :t},
            {NotionSDK.Heading3, :t},
            {NotionSDK.Image, :t},
            {NotionSDK.LinkToPage, :t},
            {NotionSDK.NumberedListItem, :t},
            {NotionSDK.Paragraph, :t},
            {NotionSDK.Pdf, :t},
            {NotionSDK.Quote, :t},
            {NotionSDK.SyncedBlock, :t},
            {NotionSDK.Table, :t},
            {NotionSDK.TableOfContents, :t},
            {NotionSDK.TableRow, :t},
            {NotionSDK.Template, :t},
            {NotionSDK.ToDo, :t},
            {NotionSDK.Toggle, :t},
            {NotionSDK.Video, :t}
          ]}},
      color:
        {:enum,
         [
           "default",
           "gray",
           "brown",
           "orange",
           "yellow",
           "green",
           "blue",
           "purple",
           "pink",
           "red",
           "default_background",
           "gray_background",
           "brown_background",
           "orange_background",
           "yellow_background",
           "green_background",
           "blue_background",
           "purple_background",
           "pink_background",
           "red_background"
         ]},
      rich_text: {:array, {NotionSDK.RichTextItemRequest, :t}}
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
        name: "toggle",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithRichTextAndColorRequest, :t},
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
        type: {:const, "toggle"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:t_toggle) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "children",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:array,
           {:union,
            [
              {NotionSDK.Audio, :t},
              {NotionSDK.Bookmark, :t},
              {NotionSDK.Breadcrumb, :t},
              {NotionSDK.BulletedListItem, :t},
              {NotionSDK.Callout, :t},
              {NotionSDK.Code, :t},
              {NotionSDK.Divider, :t},
              {NotionSDK.Embed, :t},
              {NotionSDK.Equation, :t},
              {NotionSDK.File, :t},
              {NotionSDK.Heading1, :t},
              {NotionSDK.Heading2, :t},
              {NotionSDK.Heading3, :t},
              {NotionSDK.Image, :t},
              {NotionSDK.LinkToPage, :t},
              {NotionSDK.NumberedListItem, :t},
              {NotionSDK.Paragraph, :t},
              {NotionSDK.Pdf, :t},
              {NotionSDK.Quote, :t},
              {NotionSDK.SyncedBlock, :t},
              {NotionSDK.Table, :t},
              {NotionSDK.TableOfContents, :t},
              {NotionSDK.TableRow, :t},
              {NotionSDK.Template, :t},
              {NotionSDK.ToDo, :t},
              {NotionSDK.Toggle, :t},
              {NotionSDK.Video, :t}
            ]}},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`, `default_background`, `gray_background`, `brown_background`, `orange_background`, `yellow_background`, `green_background`, `blue_background`, `purple_background`, `pink_background`, `red_background`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "color",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:enum,
           [
             "default",
             "gray",
             "brown",
             "orange",
             "yellow",
             "green",
             "blue",
             "purple",
             "pink",
             "red",
             "default_background",
             "gray_background",
             "brown_background",
             "orange_background",
             "yellow_background",
             "green_background",
             "blue_background",
             "purple_background",
             "pink_background",
             "red_background"
           ]},
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
        name: "rich_text",
        nullable: false,
        read_only: false,
        required: true,
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
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
