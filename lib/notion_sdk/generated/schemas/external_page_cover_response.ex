defmodule NotionSDK.ExternalPageCoverResponse do
  @moduledoc """
  Generated Notion Sdk type for external page cover response.
  """

  @enforce_keys [:external, :type]
  defstruct [:external, :type]

  @type t :: %__MODULE__{
          external: NotionSDK.ExternalPageCoverResponseExternal.t(),
          type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      external: {NotionSDK.ExternalPageCoverResponseExternal, :t},
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
        description: "The external URL for the cover.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "external",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.ExternalPageCoverResponseExternal, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Type of cover. In this case, an external URL.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "external"},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.ExternalPageCoverResponse, type, data)
  end
end
