defmodule NotionSDK.UnsupportedBlockObjectResponseUnsupported do
  @moduledoc """
  Generated Notion Sdk type for unsupported block object response unsupported.
  """

  @enforce_keys [:block_type]
  defstruct [:block_type]

  @type t :: %__MODULE__{
          block_type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      block_type: :string
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
          "The underlying block type that is not currently supported by the Public API. Example values include: tab, form, button, drive.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "block_type",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
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
      NotionSDK.UnsupportedBlockObjectResponseUnsupported,
      type,
      data
    )
  end
end
