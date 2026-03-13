defmodule NotionSDK.Unsupported do
  @moduledoc """
  Unsupported

  ## Fields

    * `function`: required
    * `type`: required
    * `unsupported`: required

  """
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          function: String.t(),
          type: String.t(),
          unsupported: NotionSDK.EmptyObject.t()
        }

  defstruct [:function, :type, :unsupported]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      function:
        {:enum,
         [
           "count",
           "count_values",
           "empty",
           "not_empty",
           "unique",
           "show_unique",
           "percent_empty",
           "percent_not_empty",
           "sum",
           "average",
           "median",
           "min",
           "max",
           "range",
           "earliest_date",
           "latest_date",
           "date_range",
           "checked",
           "unchecked",
           "percent_checked",
           "percent_unchecked",
           "count_per_group",
           "percent_per_group",
           "show_original"
         ]},
      type: {:const, "unsupported"},
      unsupported: {NotionSDK.EmptyObject, :t}
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
        name: "function",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:enum,
           [
             "count",
             "count_values",
             "empty",
             "not_empty",
             "unique",
             "show_unique",
             "percent_empty",
             "percent_not_empty",
             "sum",
             "average",
             "median",
             "min",
             "max",
             "range",
             "earliest_date",
             "latest_date",
             "date_range",
             "checked",
             "unchecked",
             "percent_checked",
             "percent_unchecked",
             "count_per_group",
             "percent_per_group",
             "show_original"
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
        type: {:const, "unsupported"},
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
        name: "unsupported",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.EmptyObject, :t},
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
