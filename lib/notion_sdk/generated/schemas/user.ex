defmodule NotionSDK.User do
  @moduledoc """
  User

  ## Fields

    * `type`: required
    * `user`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          type: String.t(),
          user: NotionSDK.PartialUserObjectResponse.t() | NotionSDK.Person.t()
        }

  defstruct [:type, :user]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      type: {:const, "user"},
      user: {:union, [{NotionSDK.Person, :t}, {NotionSDK.PartialUserObjectResponse, :t}]}
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
        extensions: nil,
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "user"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
        external_docs: nil,
        name: "user",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [{NotionSDK.Person, :t}, {NotionSDK.PartialUserObjectResponse, :t}]},
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
