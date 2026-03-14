defmodule NotionSDK.ErrorApi503 do
  @moduledoc """
  ErrorApi503

  ## Fields

    * `additional_data`: optional
    * `code`: optional
    * `message`: optional
    * `object`: optional
    * `status`: optional

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          additional_data: map | nil,
          code: String.t() | nil,
          message: String.t() | nil,
          object: String.t() | nil,
          status: 503 | nil
        }

  defstruct [:additional_data, :code, :message, :object, :status]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      additional_data: :map,
      code: {:const, "service_unavailable"},
      message: :string,
      object: {:const, "error"},
      status: {:const, 503}
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
        name: "additional_data",
        nullable: false,
        read_only: false,
        required: false,
        type: :map,
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
        name: "code",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "service_unavailable"},
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
        name: "message",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
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
        name: "object",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "error"},
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
        name: "status",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, 503},
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
