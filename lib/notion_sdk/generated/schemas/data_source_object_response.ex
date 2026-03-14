defmodule NotionSDK.DataSourceObjectResponse do
  @moduledoc """
  DataSourceObjectResponse

  ## Fields

    * `cover`: The cover of the data source.
    * `created_by`: required
    * `created_time`: The time when the data source was created.
    * `database_parent`: required
    * `description`: The description of the data source.
    * `icon`: The icon of the data source.
    * `id`: required
    * `in_trash`: Whether the data source is in the trash.
    * `is_inline`: Whether the data source is inline.
    * `last_edited_by`: required
    * `last_edited_time`: The time when the data source was last edited.
    * `object`: The data source object type name.
    * `parent`: The parent of the data source. This is typically a database (`database_id`), but for externally synced data sources, can be another data source (`data_source_id`).
    * `properties`: The properties schema of the data source.
    * `public_url`: The public URL of the data source if it is publicly accessible.
    * `title`: The title of the data source.
    * `url`: The URL of the data source.

  """
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          cover:
            NotionSDK.ExternalPageCoverResponse.t() | NotionSDK.FilePageCoverResponse.t() | nil,
          created_by: NotionSDK.PartialUserObjectResponse.t(),
          created_time: DateTime.t(),
          database_parent:
            NotionSDK.BlockIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.DatabaseParentResponse.t()
            | NotionSDK.PageIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.WorkspaceParentForBlockBasedObjectResponse.t(),
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
          last_edited_by: NotionSDK.PartialUserObjectResponse.t(),
          last_edited_time: DateTime.t(),
          object: String.t(),
          parent: NotionSDK.DataSourceParentResponse.t() | NotionSDK.DatabaseParentResponse.t(),
          properties: map,
          public_url: String.t() | nil,
          title: [NotionSDK.RichTextItemResponse.t()],
          url: String.t()
        }

  defstruct [
    :cover,
    :created_by,
    :created_time,
    :database_parent,
    :description,
    :icon,
    :id,
    :in_trash,
    :is_inline,
    :last_edited_by,
    :last_edited_time,
    :object,
    :parent,
    :properties,
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
      created_by: {NotionSDK.PartialUserObjectResponse, :t},
      created_time: {:string, "date-time"},
      database_parent:
        {:union,
         [
           {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
           {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t},
           {NotionSDK.DatabaseParentResponse, :t},
           {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t}
         ]},
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
      last_edited_by: {NotionSDK.PartialUserObjectResponse, :t},
      last_edited_time: {:string, "date-time"},
      object: {:const, "data_source"},
      parent:
        {:union,
         [{NotionSDK.DatabaseParentResponse, :t}, {NotionSDK.DataSourceParentResponse, :t}]},
      properties: :map,
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
        description: "The cover of the data source.",
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "created_by",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.PartialUserObjectResponse, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The time when the data source was created.",
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "database_parent",
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
        description: "The description of the data source.",
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
        description: "The icon of the data source.",
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
        description: "Whether the data source is in the trash.",
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
        description: "Whether the data source is inline.",
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "last_edited_by",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.PartialUserObjectResponse, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The time when the data source was last edited.",
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
        description: "The data source object type name.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "data_source"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "The parent of the data source. This is typically a database (`database_id`), but for externally synced data sources, can be another data source (`data_source_id`).",
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
           [{NotionSDK.DatabaseParentResponse, :t}, {NotionSDK.DataSourceParentResponse, :t}]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The properties schema of the data source.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "properties",
        nullable: false,
        read_only: false,
        required: true,
        type: :map,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The public URL of the data source if it is publicly accessible.",
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
        description: "The title of the data source.",
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
        description: "The URL of the data source.",
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
