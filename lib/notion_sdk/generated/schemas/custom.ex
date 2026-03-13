defmodule NotionSDK.Custom do
  @moduledoc """
  Provides struct and types for Custom

  ## Types

    * Custom
    * Custom.t_custom
  """
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %{custom: NotionSDK.Custom.t_custom(), type: String.t()}

  @type t_custom :: %{name: String.t()}

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [custom: {NotionSDK.Custom, :t_custom}, type: {:const, "custom"}]
  end

  def __fields__(:t_custom) do
    [name: :string]
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "custom",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Custom, :t_custom},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `custom`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "custom"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:t_custom) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "The custom display name to use",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "name",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
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

  def __schema__(:t_custom) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:t_custom))
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
