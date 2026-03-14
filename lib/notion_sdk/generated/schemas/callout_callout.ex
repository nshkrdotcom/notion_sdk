defmodule NotionSDK.CalloutCallout do
  @moduledoc """
  CalloutCallout

  ## Fields

    * `children`: optional
    * `color`: One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`, `default_background`, `gray_background`, `brown_background`, `orange_background`, `yellow_background`, `green_background`, `blue_background`, `purple_background`, `pink_background`, `red_background`
    * `icon`: optional
    * `rich_text`: required

  """
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          children:
            [
              NotionSDK.Audio.t()
              | NotionSDK.Bookmark.t()
              | NotionSDK.Breadcrumb.t()
              | NotionSDK.BulletedListItem.t()
              | NotionSDK.Callout.t()
              | NotionSDK.Code.t()
              | NotionSDK.Divider.t()
              | NotionSDK.Embed.t()
              | NotionSDK.Equation.t()
              | NotionSDK.File.t()
              | NotionSDK.Heading1.t()
              | NotionSDK.Heading2.t()
              | NotionSDK.Heading3.t()
              | NotionSDK.Image.t()
              | NotionSDK.LinkToPage.t()
              | NotionSDK.NumberedListItem.t()
              | NotionSDK.Paragraph.t()
              | NotionSDK.Pdf.t()
              | NotionSDK.Quote.t()
              | NotionSDK.SyncedBlock.t()
              | NotionSDK.Table.t()
              | NotionSDK.TableOfContents.t()
              | NotionSDK.TableRow.t()
              | NotionSDK.Template.t()
              | NotionSDK.ToDo.t()
              | NotionSDK.Toggle.t()
              | NotionSDK.Video.t()
            ]
            | [
                NotionSDK.Audio.t()
                | NotionSDK.Bookmark.t()
                | NotionSDK.Breadcrumb.t()
                | NotionSDK.BulletedListItem.t()
                | NotionSDK.Callout.t()
                | NotionSDK.Code.t()
                | NotionSDK.Divider.t()
                | NotionSDK.Embed.t()
                | NotionSDK.Equation.t()
                | NotionSDK.File.t()
                | NotionSDK.Heading1.t()
                | NotionSDK.Heading2.t()
                | NotionSDK.Heading3.t()
                | NotionSDK.Image.t()
                | NotionSDK.LinkToPage.t()
                | NotionSDK.NumberedListItem.t()
                | NotionSDK.Paragraph.t()
                | NotionSDK.Pdf.t()
                | NotionSDK.Quote.t()
                | NotionSDK.SyncedBlock.t()
                | NotionSDK.TableOfContents.t()
                | NotionSDK.TableRow.t()
                | NotionSDK.Template.t()
                | NotionSDK.ToDo.t()
                | NotionSDK.Toggle.t()
                | NotionSDK.Video.t()
              ]
            | nil,
          color: String.t() | nil,
          icon:
            NotionSDK.CustomEmojiPageIconRequest.t()
            | NotionSDK.EmojiPageIconRequest.t()
            | NotionSDK.ExternalPageIconRequest.t()
            | NotionSDK.FileUploadPageIconRequest.t()
            | nil,
          rich_text: [NotionSDK.RichTextItemRequest.t()]
        }

  defstruct [:children, :color, :icon, :rich_text]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      children:
        {:union,
         [
           [
             union: [
               {NotionSDK.Embed, :t},
               {NotionSDK.Bookmark, :t},
               {NotionSDK.Image, :t},
               {NotionSDK.Video, :t},
               {NotionSDK.Pdf, :t},
               {NotionSDK.File, :t},
               {NotionSDK.Audio, :t},
               {NotionSDK.Code, :t},
               {NotionSDK.Equation, :t},
               {NotionSDK.Divider, :t},
               {NotionSDK.Breadcrumb, :t},
               {NotionSDK.TableOfContents, :t},
               {NotionSDK.LinkToPage, :t},
               {NotionSDK.TableRow, :t},
               {NotionSDK.Heading1, :t},
               {NotionSDK.Heading2, :t},
               {NotionSDK.Heading3, :t},
               {NotionSDK.Paragraph, :t},
               {NotionSDK.BulletedListItem, :t},
               {NotionSDK.NumberedListItem, :t},
               {NotionSDK.Quote, :t},
               {NotionSDK.ToDo, :t},
               {NotionSDK.Toggle, :t},
               {NotionSDK.Template, :t},
               {NotionSDK.Callout, :t},
               {NotionSDK.SyncedBlock, :t}
             ]
           ],
           [
             union: [
               {NotionSDK.Embed, :t},
               {NotionSDK.Bookmark, :t},
               {NotionSDK.Image, :t},
               {NotionSDK.Video, :t},
               {NotionSDK.Pdf, :t},
               {NotionSDK.File, :t},
               {NotionSDK.Audio, :t},
               {NotionSDK.Code, :t},
               {NotionSDK.Equation, :t},
               {NotionSDK.Divider, :t},
               {NotionSDK.Breadcrumb, :t},
               {NotionSDK.TableOfContents, :t},
               {NotionSDK.LinkToPage, :t},
               {NotionSDK.TableRow, :t},
               {NotionSDK.Heading1, :t},
               {NotionSDK.Heading2, :t},
               {NotionSDK.Heading3, :t},
               {NotionSDK.Paragraph, :t},
               {NotionSDK.BulletedListItem, :t},
               {NotionSDK.NumberedListItem, :t},
               {NotionSDK.Quote, :t},
               {NotionSDK.Table, :t},
               {NotionSDK.ToDo, :t},
               {NotionSDK.Toggle, :t},
               {NotionSDK.Template, :t},
               {NotionSDK.Callout, :t},
               {NotionSDK.SyncedBlock, :t}
             ]
           ]
         ]},
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
      icon:
        {:union,
         [
           {NotionSDK.FileUploadPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.CustomEmojiPageIconRequest, :t}
         ]},
      rich_text: [{NotionSDK.RichTextItemRequest, :t}]
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
        name: "children",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             [
               union: [
                 {NotionSDK.Embed, :t},
                 {NotionSDK.Bookmark, :t},
                 {NotionSDK.Image, :t},
                 {NotionSDK.Video, :t},
                 {NotionSDK.Pdf, :t},
                 {NotionSDK.File, :t},
                 {NotionSDK.Audio, :t},
                 {NotionSDK.Code, :t},
                 {NotionSDK.Equation, :t},
                 {NotionSDK.Divider, :t},
                 {NotionSDK.Breadcrumb, :t},
                 {NotionSDK.TableOfContents, :t},
                 {NotionSDK.LinkToPage, :t},
                 {NotionSDK.TableRow, :t},
                 {NotionSDK.Heading1, :t},
                 {NotionSDK.Heading2, :t},
                 {NotionSDK.Heading3, :t},
                 {NotionSDK.Paragraph, :t},
                 {NotionSDK.BulletedListItem, :t},
                 {NotionSDK.NumberedListItem, :t},
                 {NotionSDK.Quote, :t},
                 {NotionSDK.ToDo, :t},
                 {NotionSDK.Toggle, :t},
                 {NotionSDK.Template, :t},
                 {NotionSDK.Callout, :t},
                 {NotionSDK.SyncedBlock, :t}
               ]
             ],
             [
               union: [
                 {NotionSDK.Embed, :t},
                 {NotionSDK.Bookmark, :t},
                 {NotionSDK.Image, :t},
                 {NotionSDK.Video, :t},
                 {NotionSDK.Pdf, :t},
                 {NotionSDK.File, :t},
                 {NotionSDK.Audio, :t},
                 {NotionSDK.Code, :t},
                 {NotionSDK.Equation, :t},
                 {NotionSDK.Divider, :t},
                 {NotionSDK.Breadcrumb, :t},
                 {NotionSDK.TableOfContents, :t},
                 {NotionSDK.LinkToPage, :t},
                 {NotionSDK.TableRow, :t},
                 {NotionSDK.Heading1, :t},
                 {NotionSDK.Heading2, :t},
                 {NotionSDK.Heading3, :t},
                 {NotionSDK.Paragraph, :t},
                 {NotionSDK.BulletedListItem, :t},
                 {NotionSDK.NumberedListItem, :t},
                 {NotionSDK.Quote, :t},
                 {NotionSDK.Table, :t},
                 {NotionSDK.ToDo, :t},
                 {NotionSDK.Toggle, :t},
                 {NotionSDK.Template, :t},
                 {NotionSDK.Callout, :t},
                 {NotionSDK.SyncedBlock, :t}
               ]
             ]
           ]},
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
        name: "icon",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             {NotionSDK.FileUploadPageIconRequest, :t},
             {NotionSDK.EmojiPageIconRequest, :t},
             {NotionSDK.ExternalPageIconRequest, :t},
             {NotionSDK.CustomEmojiPageIconRequest, :t}
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
        type: [{NotionSDK.RichTextItemRequest, :t}],
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
