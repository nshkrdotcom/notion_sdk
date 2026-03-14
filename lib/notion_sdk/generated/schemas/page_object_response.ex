defmodule NotionSDK.PageObjectResponse do
  @moduledoc """
  PageObjectResponse

  ## Fields

    * `cover`: Page cover image.
    * `created_by`: required
    * `created_time`: Date and time when this page was created.
    * `icon`: Page icon.
    * `id`: required
    * `in_trash`: Whether the page is in trash.
    * `is_locked`: Whether the page is locked from editing in the Notion app UI.
    * `last_edited_by`: required
    * `last_edited_time`: Date and time when this page was last edited.
    * `object`: The page object type name.
    * `parent`: required
    * `properties`: Property values of this page.
    * `public_url`: The public URL of the Notion page, if it has been published to the web.
    * `url`: The URL of the Notion page.

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          cover:
            NotionSDK.ExternalPageCoverResponse.t() | NotionSDK.FilePageCoverResponse.t() | nil,
          created_by: NotionSDK.PartialUserObjectResponse.t(),
          created_time: DateTime.t(),
          icon:
            NotionSDK.CustomEmojiPageIconResponse.t()
            | NotionSDK.EmojiPageIconResponse.t()
            | NotionSDK.ExternalPageIconResponse.t()
            | NotionSDK.FilePageIconResponse.t()
            | nil,
          id: String.t(),
          in_trash: boolean,
          is_locked: boolean,
          last_edited_by: NotionSDK.PartialUserObjectResponse.t(),
          last_edited_time: DateTime.t(),
          object: String.t(),
          parent:
            NotionSDK.BlockIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.DataSourceParentResponse.t()
            | NotionSDK.DatabaseParentResponse.t()
            | NotionSDK.PageIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.WorkspaceParentForBlockBasedObjectResponse.t(),
          properties: map,
          public_url: String.t() | nil,
          url: String.t()
        }

  defstruct [
    :cover,
    :created_by,
    :created_time,
    :icon,
    :id,
    :in_trash,
    :is_locked,
    :last_edited_by,
    :last_edited_time,
    :object,
    :parent,
    :properties,
    :public_url,
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
      is_locked: :boolean,
      last_edited_by: {NotionSDK.PartialUserObjectResponse, :t},
      last_edited_time: {:string, "date-time"},
      object: {:const, "page"},
      parent:
        {:union,
         [
           {NotionSDK.DatabaseParentResponse, :t},
           {NotionSDK.DataSourceParentResponse, :t},
           {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
           {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t},
           {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t}
         ]},
      properties: :map,
      public_url: {:union, [:null, :string]},
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
        description: "Page cover image.",
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
        description: "Date and time when this page was created.",
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
        description: "Page icon.",
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
        description: "Whether the page is in trash.",
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
        description: "Whether the page is locked from editing in the Notion app UI.",
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
        description: "Date and time when this page was last edited.",
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
        description: "The page object type name.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "page"},
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
             {NotionSDK.DatabaseParentResponse, :t},
             {NotionSDK.DataSourceParentResponse, :t},
             {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
             {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t},
             {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t}
           ]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Property values of this page.",
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
        description: "The public URL of the Notion page, if it has been published to the web.",
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
        description: "The URL of the Notion page.",
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
