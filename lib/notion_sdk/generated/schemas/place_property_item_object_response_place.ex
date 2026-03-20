defmodule NotionSDK.PlacePropertyItemObjectResponsePlace do
  @moduledoc """
  Generated Notion Sdk type for place property item object response place.
  """

  @enforce_keys [:lat, :lon]
  defstruct [:address, :aws_place_id, :google_place_id, :lat, :lon, :name]

  @type t :: %__MODULE__{
          address: nil | String.t(),
          aws_place_id: nil | String.t(),
          google_place_id: nil | String.t(),
          lat: number(),
          lon: number(),
          name: nil | String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      address: {:union, [:null, :string]},
      aws_place_id: {:union, [:null, :string]},
      google_place_id: {:union, [:null, :string]},
      lat: :number,
      lon: :number,
      name: {:union, [:null, :string]}
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
        name: "address",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "aws_place_id",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "google_place_id",
        nullable: false,
        read_only: false,
        required: false,
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
        name: "lat",
        nullable: false,
        read_only: false,
        required: true,
        type: :number,
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
        name: "lon",
        nullable: false,
        read_only: false,
        required: true,
        type: :number,
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
        required: false,
        type: {:union, [:null, :string]},
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
    Pristine.Runtime.Schema.decode_module_type(
      NotionSDK.PlacePropertyItemObjectResponsePlace,
      type,
      data
    )
  end
end
