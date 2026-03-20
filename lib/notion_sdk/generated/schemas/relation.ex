defmodule NotionSDK.Relation do
  @moduledoc """
  Generated Notion Sdk type for relation.
  """

  @enforce_keys [:id, :next_url, :relation, :type]
  defstruct [:id, :next_url, :relation, :type]

  @type t :: %__MODULE__{
          id: String.t(),
          next_url: nil | String.t(),
          relation: NotionSDK.EmptyObject.t(),
          type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: :string,
      next_url: {:union, [:null, :string]},
      relation: {NotionSDK.EmptyObject, :t},
      type: {:const, "relation"}
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
        name: "next_url",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
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
        name: "relation",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.EmptyObject, :t},
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
        type: {:const, "relation"},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.Relation, type, data)
  end
end
