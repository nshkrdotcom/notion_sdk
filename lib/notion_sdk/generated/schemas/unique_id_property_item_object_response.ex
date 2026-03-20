defmodule NotionSDK.UniqueIdPropertyItemObjectResponse do
  @moduledoc """
  Generated Notion Sdk type for unique id property item object response.
  """

  @enforce_keys [:id, :object, :type, :unique_id]
  defstruct [:id, :object, :type, :unique_id]

  @type t :: %__MODULE__{
          id: String.t(),
          object: String.t(),
          type: String.t(),
          unique_id: NotionSDK.UniqueIdPropertyItemObjectResponseUniqueId.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: :string,
      object: {:const, "property_item"},
      type: {:const, "unique_id"},
      unique_id: {NotionSDK.UniqueIdPropertyItemObjectResponseUniqueId, :t}
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
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "property_item"},
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
        type: {:const, "unique_id"},
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
        name: "unique_id",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.UniqueIdPropertyItemObjectResponseUniqueId, :t},
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
      NotionSDK.UniqueIdPropertyItemObjectResponse,
      type,
      data
    )
  end
end
