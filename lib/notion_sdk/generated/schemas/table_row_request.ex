defmodule NotionSDK.TableRowRequest do
  @moduledoc """
  Table Row

  ## Fields

    * `object`: optional
    * `table_row`: required
    * `type`: optional

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          object: String.t() | nil,
          table_row: NotionSDK.ContentWithTableRowRequest.t(),
          type: String.t() | nil
        }

  defstruct [:object, :table_row, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      object: {:const, "block"},
      table_row: {NotionSDK.ContentWithTableRowRequest, :t},
      type: {:const, "table_row"}
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
        name: "table_row",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ContentWithTableRowRequest, :t},
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
        type: {:const, "table_row"},
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
