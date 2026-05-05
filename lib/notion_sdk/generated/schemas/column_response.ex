defmodule NotionSDK.ColumnResponse do
  @moduledoc """
  Generated Notion Sdk type module `NotionSDK.ColumnResponse`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys []
  defstruct [:width_ratio]

  @type t :: %__MODULE__{
          width_ratio: number()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      width_ratio: :number
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
        description:
          "Ratio between 0 and 1 of the width of this column relative to all columns in the list. If not provided, uses an equal width.",
        example: nil,
        examples: [0.5],
        extensions: %{},
        external_docs: nil,
        name: "width_ratio",
        nullable: false,
        read_only: false,
        required: false,
        type: :number,
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
