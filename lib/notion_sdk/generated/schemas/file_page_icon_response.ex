defmodule NotionSDK.FilePageIconResponse do
  @moduledoc """
  File

  ## Fields

    * `file`: required
    * `type`: Type of icon. In this case, a file.

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{file: NotionSDK.InternalFileResponse.t(), type: String.t()}

  defstruct [:file, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [file: {NotionSDK.InternalFileResponse, :t}, type: {:const, "file"}]
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
        name: "file",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.InternalFileResponse, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Type of icon. In this case, a file.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "file"},
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
