defmodule NotionSDK do
  @moduledoc """
  Generated Notion Sdk type for notion sdk.
  """

  @type t :: map()
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :map)

  def __fields__(:map) do
    [
      after: {:string, "date"}
    ]
  end

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
  def __openapi_fields__(type \\ :map)

  def __openapi_fields__(:map) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "after",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "date"},
        write_only: false
      }
    ]
  end

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :map) when is_atom(type) do
    Pristine.Runtime.Schema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :map)

  def decode(data, type) when is_map(data) and is_atom(type) do
    Pristine.Runtime.Schema.decode_module_type(NotionSDK, type, data)
  end
end
