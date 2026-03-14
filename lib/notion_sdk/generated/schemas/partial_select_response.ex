defmodule NotionSDK.PartialSelectResponse do
  @moduledoc """
  PartialSelectResponse

  ## Fields

    * `color`: One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`
    * `id`: required
    * `name`: required

  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{color: String.t(), id: String.t(), name: String.t()}

  defstruct [:color, :id, :name]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      color:
        {:enum,
         [
           "default",
           "gray",
           "brown",
           "orange",
           "yellow",
           "green",
           "blue",
           "purple",
           "pink",
           "red"
         ]},
      id: :string,
      name: :string
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
        description:
          "One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "color",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:enum,
           [
             "default",
             "gray",
             "brown",
             "orange",
             "yellow",
             "green",
             "blue",
             "purple",
             "pink",
             "red"
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

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :t)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
