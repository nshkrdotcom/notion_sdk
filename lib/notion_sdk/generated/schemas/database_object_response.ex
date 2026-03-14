defmodule NotionSDK.DatabaseObjectResponse do
  @moduledoc """
  DatabaseObjectResponse

  ## Fields

    * `cover`: The cover of the database.
    * `created_time`: The time when the database was created.
    * `data_sources`: The data sources of the database.
    * `description`: The description of the database.
    * `icon`: The icon of the database.
    * `id`: required
    * `in_trash`: Whether the database is in the trash.
    * `is_inline`: Whether the database is inline.
    * `is_locked`: Whether the database is locked from editing in the Notion app UI.
    * `last_edited_time`: The time when the database was last edited.
    * `object`: The database object type name.
    * `parent`: required
    * `public_url`: The public URL of the database if it is publicly accessible.
    * `title`: The title of the database.
    * `url`: The URL of the database.

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          cover:
            NotionSDK.ExternalPageCoverResponse.t() | NotionSDK.FilePageCoverResponse.t() | nil,
          created_time: DateTime.t(),
          data_sources: [NotionSDK.DataSourceReferenceResponse.t()],
          description: [NotionSDK.RichTextItemResponse.t()],
          icon:
            NotionSDK.CustomEmojiPageIconResponse.t()
            | NotionSDK.EmojiPageIconResponse.t()
            | NotionSDK.ExternalPageIconResponse.t()
            | NotionSDK.FilePageIconResponse.t()
            | nil,
          id: String.t(),
          in_trash: boolean,
          is_inline: boolean,
          is_locked: boolean,
          last_edited_time: DateTime.t(),
          object: String.t(),
          parent:
            NotionSDK.BlockIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.DatabaseParentResponse.t()
            | NotionSDK.PageIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.WorkspaceParentForBlockBasedObjectResponse.t(),
          public_url: String.t() | nil,
          title: [NotionSDK.RichTextItemResponse.t()],
          url: String.t()
        }

  defstruct [
    :cover,
    :created_time,
    :data_sources,
    :description,
    :icon,
    :id,
    :in_trash,
    :is_inline,
    :is_locked,
    :last_edited_time,
    :object,
    :parent,
    :public_url,
    :title,
    :url
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      cover:
        {:union,
         [:null, {NotionSDK.FilePageCoverResponse, :t}, {NotionSDK.ExternalPageCoverResponse, :t}]},
      created_time: {:string, "date-time"},
      data_sources: [{NotionSDK.DataSourceReferenceResponse, :t}],
      description: [{NotionSDK.RichTextItemResponse, :t}],
      icon:
        {:union,
         [
           :null,
           {NotionSDK.EmojiPageIconResponse, :t},
           {NotionSDK.FilePageIconResponse, :t},
           {NotionSDK.ExternalPageIconResponse, :t},
           {NotionSDK.CustomEmojiPageIconResponse, :t}
         ]},
      id: {:string, "uuid"},
      in_trash: :boolean,
      is_inline: :boolean,
      is_locked: :boolean,
      last_edited_time: {:string, "date-time"},
      object: {:const, "database"},
      parent:
        {:union,
         [
           {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
           {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t},
           {NotionSDK.DatabaseParentResponse, :t},
           {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t}
         ]},
      public_url: {:union, [:null, :string]},
      title: [{NotionSDK.RichTextItemResponse, :t}],
      url: :string
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
        description: "The cover of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "cover",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             :null,
             {NotionSDK.FilePageCoverResponse, :t},
             {NotionSDK.ExternalPageCoverResponse, :t}
           ]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The time when the database was created.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "created_time",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "date-time"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The data sources of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "data_sources",
        nullable: false,
        read_only: false,
        required: true,
        type: [{NotionSDK.DataSourceReferenceResponse, :t}],
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The description of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "description",
        nullable: false,
        read_only: false,
        required: true,
        type: [{NotionSDK.RichTextItemResponse, :t}],
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The icon of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "icon",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             :null,
             {NotionSDK.EmojiPageIconResponse, :t},
             {NotionSDK.FilePageIconResponse, :t},
             {NotionSDK.ExternalPageIconResponse, :t},
             {NotionSDK.CustomEmojiPageIconResponse, :t}
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
        name: "id",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "uuid"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Whether the database is in the trash.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "in_trash",
        nullable: false,
        read_only: false,
        required: true,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Whether the database is inline.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_inline",
        nullable: false,
        read_only: false,
        required: true,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Whether the database is locked from editing in the Notion app UI.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_locked",
        nullable: false,
        read_only: false,
        required: true,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The time when the database was last edited.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "last_edited_time",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "date-time"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The database object type name.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "database"},
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
        name: "parent",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
             {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t},
             {NotionSDK.DatabaseParentResponse, :t},
             {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t}
           ]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The public URL of the database if it is publicly accessible.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "public_url",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The title of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "title",
        nullable: false,
        read_only: false,
        required: true,
        type: [{NotionSDK.RichTextItemResponse, :t}],
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The URL of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "url",
        nullable: false,
        read_only: false,
        required: true,
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
