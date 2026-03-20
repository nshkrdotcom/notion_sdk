defmodule NotionSDK.PartialDataSourceObjectResponse do
  @moduledoc """
  Generated Notion Sdk type for partial data source object response.
  """

  @enforce_keys [:id, :object, :properties]
  defstruct [:id, :object, :properties]

  @type t :: %__MODULE__{
          id: String.t(),
          object: String.t(),
          properties: map()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: {:string, "uuid"},
      object: {:const, "data_source"},
      properties: :map
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
    Pristine.Runtime.Schema.decode_module_type(
      NotionSDK.PartialDataSourceObjectResponse,
      type,
      data
    )
  end
end
