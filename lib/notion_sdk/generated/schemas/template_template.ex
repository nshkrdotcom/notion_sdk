defmodule NotionSDK.TemplateTemplate do
  @moduledoc """
  Generated Notion Sdk type for template template.
  """

  @enforce_keys [:rich_text]
  defstruct [:children, :rich_text]

  @type t :: %__MODULE__{
          children: [
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
          ],
          rich_text: [NotionSDK.RichTextItemRequest.t()]
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
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
    Pristine.Runtime.Schema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :t)

  def decode(data, type) when is_map(data) and is_atom(type) do
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.TemplateTemplate, type, data)
  end
end
