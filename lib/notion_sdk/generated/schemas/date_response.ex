defmodule NotionSDK.DateResponse do
  @moduledoc """
  Generated Notion Sdk type module `NotionSDK.DateResponse`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [:end, :start, :time_zone]
  defstruct [:end, :start, :time_zone]

  @type t :: %__MODULE__{
          end: nil | Date.t(),
          start: Date.t(),
          time_zone: nil | String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      end: {:union, [:null, string: "date"]},
      start: {:string, "date"},
      time_zone: {:union, [:null, :string]}
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
        description: "The end date of the date object, if any.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "end",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, string: "date"]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The start date of the date object.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "start",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "date"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The time zone of the date object.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "time_zone",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
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
