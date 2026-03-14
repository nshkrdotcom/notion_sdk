defmodule NotionSDK.FormulaPropertyItemObjectResponse do
  @moduledoc """
  Formula

  ## Fields

    * `formula`: required
    * `id`: required
    * `object`: required
    * `type`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          formula:
            NotionSDK.BooleanFormulaPropertyResponse.t()
            | NotionSDK.DateFormulaPropertyResponse.t()
            | NotionSDK.NumberFormulaPropertyResponse.t()
            | NotionSDK.StringFormulaPropertyResponse.t(),
          id: String.t(),
          object: String.t(),
          type: String.t()
        }

  defstruct [:formula, :id, :object, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      formula:
        {:union,
         [
           {NotionSDK.StringFormulaPropertyResponse, :t},
           {NotionSDK.DateFormulaPropertyResponse, :t},
           {NotionSDK.NumberFormulaPropertyResponse, :t},
           {NotionSDK.BooleanFormulaPropertyResponse, :t}
         ]},
      id: :string,
      object: {:const, "property_item"},
      type: {:const, "formula"}
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
        name: "formula",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.StringFormulaPropertyResponse, :t},
             {NotionSDK.DateFormulaPropertyResponse, :t},
             {NotionSDK.NumberFormulaPropertyResponse, :t},
             {NotionSDK.BooleanFormulaPropertyResponse, :t}
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
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "formula"},
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
