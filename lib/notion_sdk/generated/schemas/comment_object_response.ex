defmodule NotionSDK.CommentObjectResponse do
  @moduledoc """
  Generated Notion Sdk type module `NotionSDK.CommentObjectResponse`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [
    :created_by,
    :created_time,
    :discussion_id,
    :display_name,
    :id,
    :last_edited_time,
    :object,
    :parent,
    :rich_text
  ]
  defstruct [
    :attachments,
    :created_by,
    :created_time,
    :discussion_id,
    :display_name,
    :id,
    :last_edited_time,
    :object,
    :parent,
    :rich_text
  ]

  @type t :: %__MODULE__{
          attachments: [NotionSDK.CommentObjectResponseAttachments.t()],
          created_by: NotionSDK.PartialUserObjectResponse.t(),
          created_time: DateTime.t(),
          discussion_id: String.t(),
          display_name: NotionSDK.CommentObjectResponseDisplayName.t(),
          id: String.t(),
          last_edited_time: DateTime.t(),
          object: String.t(),
          parent:
            NotionSDK.BlockIdCommentParentResponse.t() | NotionSDK.PageIdCommentParentResponse.t(),
          rich_text: [NotionSDK.RichTextItemResponse.t()]
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      attachments: {:array, {NotionSDK.CommentObjectResponseAttachments, :t}},
      created_by: {NotionSDK.PartialUserObjectResponse, :t},
      created_time: {:string, "date-time"},
      discussion_id: {:string, "uuid"},
      display_name: {NotionSDK.CommentObjectResponseDisplayName, :t},
      id: {:string, "uuid"},
      last_edited_time: {:string, "date-time"},
      object: {:const, "comment"},
      parent:
        {:union,
         [
           {NotionSDK.BlockIdCommentParentResponse, :t},
           {NotionSDK.PageIdCommentParentResponse, :t}
         ]},
      rich_text: {:array, {NotionSDK.RichTextItemResponse, :t}}
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
        description: "Any file attachments associated with the comment.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "attachments",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.CommentObjectResponseAttachments, :t}},
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
        description: "The time when the comment was created.",
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
        name: "discussion_id",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "uuid"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The display name of the comment.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "display_name",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.CommentObjectResponseDisplayName, :t},
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
        description: "The time when the comment was last edited.",
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
        description: "The comment object type name.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "comment"},
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
             {NotionSDK.BlockIdCommentParentResponse, :t},
             {NotionSDK.PageIdCommentParentResponse, :t}
           ]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The rich text content of the comment.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "rich_text",
        nullable: false,
        read_only: false,
        required: true,
        type: {:array, {NotionSDK.RichTextItemResponse, :t}},
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
