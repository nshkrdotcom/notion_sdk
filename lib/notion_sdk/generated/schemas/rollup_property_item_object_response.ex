defmodule NotionSDK.RollupPropertyItemObjectResponse do
  @moduledoc """
  Rollup

  ## Fields

    * `id`: required
    * `object`: required
    * `rollup`: required
    * `type`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          id: String.t(),
          object: String.t(),
          rollup:
            NotionSDK.Array.t()
            | NotionSDK.Date.t()
            | NotionSDK.Incomplete.t()
            | NotionSDK.Number.t()
            | NotionSDK.Unsupported.t(),
          type: String.t()
        }

  defstruct [:id, :object, :rollup, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: :string,
      object: {:const, "property_item"},
      rollup:
        {:union,
         [
           {NotionSDK.Number, :t},
           {NotionSDK.Date, :t},
           {NotionSDK.Array, :t},
           {NotionSDK.Unsupported, :t},
           {NotionSDK.Incomplete, :t}
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
             {NotionSDK.Incomplete, :t}
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
        required: true,
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
