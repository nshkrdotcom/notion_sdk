defmodule NotionSDK.PageMarkdownResponse do
  @moduledoc """
  PageMarkdownResponse

  ## Fields

    * `id`: required
    * `markdown`: The page content rendered as enhanced Markdown.
    * `object`: The type of object, always 'page_markdown'.
    * `truncated`: Whether the content was truncated due to exceeding the record count limit.
    * `unknown_block_ids`: Block IDs that could not be loaded (appeared as <unknown> tags in the markdown). Pass these IDs back to this endpoint to fetch their content separately.

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          id: String.t(),
          markdown: String.t(),
          object: String.t(),
          truncated: boolean,
          unknown_block_ids: [String.t()]
        }

  defstruct [:id, :markdown, :object, :truncated, :unknown_block_ids]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: {:string, "uuid"},
      markdown: :string,
      object: {:const, "page_markdown"},
      truncated: :boolean,
      unknown_block_ids: [string: "uuid"]
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
        type: [string: "uuid"],
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
