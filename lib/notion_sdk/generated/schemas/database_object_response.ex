defmodule NotionSDK.DatabaseObjectResponse do
  @moduledoc """
  Generated Notion Sdk type for database object response.
  """

  @enforce_keys [
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

  @type t :: %__MODULE__{
          cover:
            nil | NotionSDK.ExternalPageCoverResponse.t() | NotionSDK.FilePageCoverResponse.t(),
          created_time: DateTime.t(),
          data_sources: [NotionSDK.DataSourceReferenceResponse.t()],
          description: [NotionSDK.RichTextItemResponse.t()],
          icon:
            nil
            | NotionSDK.CustomEmojiPageIconResponse.t()
            | NotionSDK.EmojiPageIconResponse.t()
            | NotionSDK.ExternalPageIconResponse.t()
            | NotionSDK.FilePageIconResponse.t(),
          id: String.t(),
          in_trash: boolean(),
          is_inline: boolean(),
          is_locked: boolean(),
          last_edited_time: DateTime.t(),
          object: String.t(),
          parent:
            NotionSDK.BlockIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.DatabaseParentResponse.t()
            | NotionSDK.PageIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.WorkspaceParentForBlockBasedObjectResponse.t(),
          public_url: nil | String.t(),
          title: [NotionSDK.RichTextItemResponse.t()],
          url: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      cover:
        {:union,
         [:null, {NotionSDK.ExternalPageCoverResponse, :t}, {NotionSDK.FilePageCoverResponse, :t}]},
      created_time: {:string, "date-time"},
      data_sources: {:array, {NotionSDK.DataSourceReferenceResponse, :t}},
      description: {:array, {NotionSDK.RichTextItemResponse, :t}},
      icon:
        {:union,
         [
           :null,
           {NotionSDK.CustomEmojiPageIconResponse, :t},
           {NotionSDK.EmojiPageIconResponse, :t},
           {NotionSDK.ExternalPageIconResponse, :t},
           {NotionSDK.FilePageIconResponse, :t}
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
           {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t},
           {NotionSDK.DatabaseParentResponse, :t},
           {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
           {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t}
         ]},
      public_url: {:union, [:null, :string]},
      title: {:array, {NotionSDK.RichTextItemResponse, :t}},
      url: :string
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
             {NotionSDK.ExternalPageCoverResponse, :t},
             {NotionSDK.FilePageCoverResponse, :t}
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
        type: {:array, {NotionSDK.DataSourceReferenceResponse, :t}},
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
        type: {:array, {NotionSDK.RichTextItemResponse, :t}},
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
             {NotionSDK.CustomEmojiPageIconResponse, :t},
             {NotionSDK.EmojiPageIconResponse, :t},
             {NotionSDK.ExternalPageIconResponse, :t},
             {NotionSDK.FilePageIconResponse, :t}
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
             {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t},
             {NotionSDK.DatabaseParentResponse, :t},
             {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
             {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t}
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
        type: {:array, {NotionSDK.RichTextItemResponse, :t}},
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

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :t) when is_atom(type) do
    Pristine.Runtime.Schema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :t)

  def decode(data, type) when is_map(data) and is_atom(type) do
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.DatabaseObjectResponse, type, data)
  end
end
