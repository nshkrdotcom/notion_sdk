defmodule NotionSDK.BulletedListItemBlockObjectResponse do
  @moduledoc """
  Generated Notion Sdk type module `NotionSDK.BulletedListItemBlockObjectResponse`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [
    :bulleted_list_item,
    :created_by,
    :created_time,
    :has_children,
    :id,
    :in_trash,
    :last_edited_by,
    :last_edited_time,
    :object,
    :parent,
    :type
  ]
  defstruct [
    :bulleted_list_item,
    :created_by,
    :created_time,
    :has_children,
    :id,
    :in_trash,
    :last_edited_by,
    :last_edited_time,
    :object,
    :parent,
    :type
  ]

  @type t :: %__MODULE__{
          bulleted_list_item: NotionSDK.ContentWithRichTextAndColorResponse.t(),
          created_by: NotionSDK.PartialUserObjectResponse.t(),
          created_time: DateTime.t(),
          has_children: boolean(),
          id: String.t(),
          in_trash: boolean(),
          last_edited_by: NotionSDK.PartialUserObjectResponse.t(),
          last_edited_time: DateTime.t(),
          object: String.t(),
          parent:
            NotionSDK.BlockIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.DataSourceParentResponse.t()
            | NotionSDK.DatabaseParentResponse.t()
            | NotionSDK.PageIdParentForBlockBasedObjectResponse.t()
            | NotionSDK.WorkspaceParentForBlockBasedObjectResponse.t(),
          type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      bulleted_list_item: {NotionSDK.ContentWithRichTextAndColorResponse, :t},
      created_by: {NotionSDK.PartialUserObjectResponse, :t},
      created_time: {:string, "date-time"},
      has_children: :boolean,
      id: {:string, "uuid"},
      in_trash: :boolean,
      last_edited_by: {NotionSDK.PartialUserObjectResponse, :t},
      last_edited_time: {:string, "date-time"},
      object: {:const, "block"},
      parent:
        {:union,
         [
           {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t},
           {NotionSDK.DataSourceParentResponse, :t},
           {NotionSDK.DatabaseParentResponse, :t},
           {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
           {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t}
         ]},
      type: {:const, "bulleted_list_item"}
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
        name: "bulleted_list_item",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithRichTextAndColorResponse, :t},
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
        description: nil,
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
        name: "has_children",
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
        description: nil,
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
        description: nil,
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
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
        name: "parent",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.BlockIdParentForBlockBasedObjectResponse, :t},
             {NotionSDK.DataSourceParentResponse, :t},
             {NotionSDK.DatabaseParentResponse, :t},
             {NotionSDK.PageIdParentForBlockBasedObjectResponse, :t},
             {NotionSDK.WorkspaceParentForBlockBasedObjectResponse, :t}
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
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "bulleted_list_item"},
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
