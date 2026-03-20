defmodule NotionSDK.PageMarkdownResponse do
  @moduledoc """
  Generated Notion Sdk type for page markdown response.
  """

  @enforce_keys [:id, :markdown, :object, :truncated, :unknown_block_ids]
  defstruct [:id, :markdown, :object, :truncated, :unknown_block_ids]

  @type t :: %__MODULE__{
          id: String.t(),
          markdown: String.t(),
          object: String.t(),
          truncated: boolean(),
          unknown_block_ids: [String.t()]
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: {:string, "uuid"},
      markdown: :string,
      object: {:const, "page_markdown"},
      truncated: :boolean,
      unknown_block_ids: {:array, {:string, "uuid"}}
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
        description: "The page content rendered as enhanced Markdown.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "markdown",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The type of object, always 'page_markdown'.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "page_markdown"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Whether the content was truncated due to exceeding the record count limit.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "truncated",
        nullable: false,
        read_only: false,
        required: true,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Block IDs that could not be loaded (appeared as <unknown> tags in the markdown). Pass these IDs back to this endpoint to fetch their content separately.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "unknown_block_ids",
        nullable: false,
        read_only: false,
        required: true,
        type: {:array, {:string, "uuid"}},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.PageMarkdownResponse, type, data)
  end
end
