defmodule NotionSDK.CreatedBy do
  @moduledoc """
  Generated Notion Sdk type for created by.
  """

  @enforce_keys [:created_by, :property]
  defstruct [:created_by, :property, :type]

  @type t :: %__MODULE__{
          created_by: NotionSDK.t() | NotionSDK.t() | NotionSDK.t() | NotionSDK.t(),
          property: String.t(),
          type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      created_by:
        {:union, [{NotionSDK, :map}, {NotionSDK, :map}, {NotionSDK, :map}, {NotionSDK, :map}]},
      property: :string,
      type: {:const, "created_by"}
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
        name: "created_by",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union, [{NotionSDK, :map}, {NotionSDK, :map}, {NotionSDK, :map}, {NotionSDK, :map}]},
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
        name: "property",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
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
        type: {:const, "created_by"},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.CreatedBy, type, data)
  end
end
