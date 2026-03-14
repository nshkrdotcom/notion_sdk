defmodule NotionSDK.WorkspaceParentForBlockBasedObjectResponse do
  @moduledoc """
  WorkspaceParentForBlockBasedObjectResponse

  ## Fields

    * `type`: The parent type.
    * `workspace`: Always true for workspace parent.

  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{type: String.t(), workspace: true}

  defstruct [:type, :workspace]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [type: {:const, "workspace"}, workspace: {:const, true}]
  end

  (
    @doc false
    @spec __openapi_fields__(atom) :: [map()]
  )

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

  (
    @doc false
    @spec __schema__(atom) :: Sinter.Schema.t()
  )

  def __schema__(type \\ :t)

  def __schema__(:t) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:t))
  end

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :t)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
