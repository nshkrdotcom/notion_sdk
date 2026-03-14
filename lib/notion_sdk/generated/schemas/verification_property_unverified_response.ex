defmodule NotionSDK.VerificationPropertyUnverifiedResponse do
  @moduledoc """
  Unverified

  ## Fields

    * `date`: required
    * `state`: Always `unverified`
    * `verified_by`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{date: nil, state: String.t(), verified_by: nil}

  defstruct [:date, :state, :verified_by]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [date: :null, state: {:const, "unverified"}, verified_by: :null]
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
        name: "date",
        nullable: false,
        read_only: false,
        required: true,
        type: :null,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `unverified`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "state",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "unverified"},
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
        name: "verified_by",
        nullable: false,
        read_only: false,
        required: true,
        type: :null,
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
