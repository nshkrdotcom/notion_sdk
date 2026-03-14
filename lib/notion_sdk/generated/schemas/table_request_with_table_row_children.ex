defmodule NotionSDK.TableRequestWithTableRowChildren do
  @moduledoc """
  TableRequestWithTableRowChildren

  ## Fields

    * `children`: required
    * `has_column_header`: optional
    * `has_row_header`: optional
    * `table_width`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          children: [NotionSDK.TableRowRequest.t()],
          has_column_header: boolean | nil,
          has_row_header: boolean | nil,
          table_width: integer
        }

  defstruct [:children, :has_column_header, :has_row_header, :table_width]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      children: [{NotionSDK.TableRowRequest, :t}],
      has_column_header: :boolean,
      has_row_header: :boolean,
      table_width: :integer
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
        name: "children",
        nullable: false,
        read_only: false,
        required: true,
        type: [{NotionSDK.TableRowRequest, :t}],
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
        name: "has_column_header",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "has_row_header",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "table_width",
        nullable: false,
        read_only: false,
        required: true,
        type: :integer,
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
