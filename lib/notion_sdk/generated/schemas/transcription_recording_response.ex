defmodule NotionSDK.TranscriptionRecordingResponse do
  @moduledoc """
  Generated Notion Sdk type for transcription recording response.
  """

  @enforce_keys []
  defstruct [:end_time, :start_time]

  @type t :: %__MODULE__{
          end_time: DateTime.t(),
          start_time: DateTime.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      end_time: {:string, "date-time"},
      start_time: {:string, "date-time"}
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
        name: "end_time",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "date-time"},
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
        name: "start_time",
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
      NotionSDK.TranscriptionRecordingResponse,
      type,
      data
    )
  end
end
