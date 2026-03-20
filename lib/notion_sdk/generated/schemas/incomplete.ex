defmodule NotionSDK.Incomplete do
  @moduledoc """
  Generated Notion Sdk type for incomplete.
  """

  @enforce_keys [:function, :incomplete, :type]
  defstruct [:function, :incomplete, :type]

  @type t :: %__MODULE__{
          function: String.t(),
          incomplete: NotionSDK.EmptyObject.t(),
          type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
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
      incomplete: {NotionSDK.EmptyObject, :t},
      type: {:const, "incomplete"}
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
        name: "incomplete",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.EmptyObject, :t},
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
        type: {:const, "incomplete"},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.Incomplete, type, data)
  end
end
