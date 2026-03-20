defmodule NotionSDK.WorkspaceParentForBlockBasedObjectResponse do
  @moduledoc """
  Generated Notion Sdk type for workspace parent for block based object response.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [:type, :workspace]
  defstruct [:type, :workspace]

  @type t :: %__MODULE__{
          type: String.t(),
          workspace: true
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      type: {:const, "workspace"},
      workspace: {:const, true}
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
        description: "The parent type.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "workspace"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always true for workspace parent.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "workspace",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, true},
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
