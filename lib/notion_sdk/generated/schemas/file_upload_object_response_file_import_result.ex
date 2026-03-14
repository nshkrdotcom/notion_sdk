defmodule NotionSDK.FileUploadObjectResponseFileImportResult do
  @moduledoc """
  FileUploadObjectResponseFileImportResult

  ## Fields

    * `imported_time`: The time the file was imported into Notion. ISO 8601 format.

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{imported_time: DateTime.t() | nil}

  defstruct [:imported_time]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [imported_time: {:string, "date-time"}]
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
        description: "The time the file was imported into Notion. ISO 8601 format.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "imported_time",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "date-time"},
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
