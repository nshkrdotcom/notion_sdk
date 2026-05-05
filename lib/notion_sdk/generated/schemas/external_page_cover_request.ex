defmodule NotionSDK.ExternalPageCoverRequest do
  @moduledoc """
  Generated Notion Sdk type module `NotionSDK.ExternalPageCoverRequest`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [:external]
  defstruct [:external, :type]

  @type t :: %__MODULE__{
          external: NotionSDK.ExternalPageCoverRequestExternal.t(),
          type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      external: {NotionSDK.ExternalPageCoverRequestExternal, :t},
      type: {:const, "external"}
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
        description: "External URL for the cover.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "external",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ExternalPageCoverRequestExternal, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `external`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "external"},
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
