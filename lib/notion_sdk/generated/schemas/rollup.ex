defmodule NotionSDK.Rollup do
  @moduledoc """
  Rollup

  ## Fields

    * `id`: required
    * `next_url`: required
    * `rollup`: required
    * `type`: required

  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          id: String.t(),
          next_url: String.t() | nil,
          property: String.t(),
          rollup:
            NotionSDK.Array.t()
            | NotionSDK.Date.t()
            | NotionSDK.Incomplete.t()
            | NotionSDK.Number.t()
            | NotionSDK.RollupRollup.t()
            | NotionSDK.Unsupported.t(),
          type: String.t() | nil
        }

  defstruct [:id, :next_url, :property, :rollup, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: :string,
      next_url: {:union, [:null, :string]},
      property: :string,
      rollup:
        {:union,
         [
           {NotionSDK.Number, :t},
           {NotionSDK.Date, :t},
           {NotionSDK.Array, :t},
           {NotionSDK.Unsupported, :t},
           {NotionSDK.Incomplete, :t},
           {NotionSDK.RollupRollup, :t}
         ]},
      type: {:const, "rollup"}
    ]
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
        name: "rollup",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.Number, :t},
             {NotionSDK.Date, :t},
             {NotionSDK.Array, :t},
             {NotionSDK.Unsupported, :t},
             {NotionSDK.Incomplete, :t},
             {NotionSDK.RollupRollup, :t}
           ]},
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
        type: {:const, "rollup"},
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
