defmodule NotionSDK.SyncedBlock do
  @moduledoc """
  Provides struct and types for SyncedBlock

  ## Types

    * Synced Block
    * SyncedBlock.t_synced_block
  """
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %{
          object: String.t() | nil,
          synced_block:
            NotionSDK.SyncedBlock.t_synced_block() | NotionSDK.SyncedBlockSyncedBlock.t(),
          type: String.t() | nil
        }

  @type t_synced_block :: %{
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
            | nil,
          synced_from: NotionSDK.BlockId.t() | nil
        }

  defstruct [:object, :synced_block, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      object: {:const, "block"},
      synced_block:
        {:union,
         [{NotionSDK.SyncedBlockSyncedBlock, :t}, {NotionSDK.SyncedBlock, :t_synced_block}]},
      type: {:const, "synced_block"}
    ]
  end

  def __fields__(:t_synced_block) do
    [
      children: [
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
      ],
      synced_from: {:union, [:null, {NotionSDK.BlockId, :t}]}
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
        name: "synced_block",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [{NotionSDK.SyncedBlockSyncedBlock, :t}, {NotionSDK.SyncedBlock, :t_synced_block}]},
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
        type: {:const, "synced_block"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:t_synced_block) do
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
        type: [
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
        ],
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
        name: "synced_from",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, {NotionSDK.BlockId, :t}]},
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

  def __schema__(:t_synced_block) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:t_synced_block))
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
