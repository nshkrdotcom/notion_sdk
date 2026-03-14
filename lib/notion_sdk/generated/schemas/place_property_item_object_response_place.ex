defmodule NotionSDK.PlacePropertyItemObjectResponsePlace do
  @moduledoc """
  PlacePropertyItemObjectResponsePlace

  ## Fields

    * `address`: optional
    * `aws_place_id`: optional
    * `google_place_id`: optional
    * `lat`: required
    * `lon`: required
    * `name`: optional

  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          address: String.t() | nil,
          aws_place_id: String.t() | nil,
          google_place_id: String.t() | nil,
          lat: number,
          lon: number,
          name: String.t() | nil
        }

  defstruct [:address, :aws_place_id, :google_place_id, :lat, :lon, :name]

  @doc false
  @spec __fields__(atom) :: keyword
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
