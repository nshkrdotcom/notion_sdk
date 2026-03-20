defmodule NotionSDK.FileUploadObjectResponseFileImportResult do
  @moduledoc """
  Generated Notion Sdk type for file upload object response file import result.
  """

  @enforce_keys []
  defstruct [:imported_time]

  @type t :: %__MODULE__{
          imported_time: DateTime.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      imported_time: {:string, "date-time"}
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
      NotionSDK.FileUploadObjectResponseFileImportResult,
      type,
      data
    )
  end
end
