defmodule NotionSDK.TranscriptionBlockResponse do
  @moduledoc """
  Generated Notion Sdk type for transcription block response.
  """

  @enforce_keys []
  defstruct [:calendar_event, :children, :recording, :status, :title]

  @type t :: %__MODULE__{
          calendar_event: NotionSDK.TranscriptionCalendarEventResponse.t(),
          children: NotionSDK.TranscriptionChildrenResponse.t(),
          recording: NotionSDK.TranscriptionRecordingResponse.t(),
          status: String.t(),
          title: [NotionSDK.RichTextItemResponse.t()]
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      calendar_event: {NotionSDK.TranscriptionCalendarEventResponse, :t},
      children: {NotionSDK.TranscriptionChildrenResponse, :t},
      recording: {NotionSDK.TranscriptionRecordingResponse, :t},
      status:
        {:enum,
         [
           "transcription_not_started",
           "transcription_paused",
           "transcription_in_progress",
           "summary_in_progress",
           "notes_ready"
         ]},
      title: {:array, {NotionSDK.RichTextItemResponse, :t}}
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
        name: "calendar_event",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.TranscriptionCalendarEventResponse, :t},
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
        name: "children",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.TranscriptionChildrenResponse, :t},
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
        name: "recording",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.TranscriptionRecordingResponse, :t},
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
        name: "status",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:enum,
           [
             "transcription_not_started",
             "transcription_paused",
             "transcription_in_progress",
             "summary_in_progress",
             "notes_ready"
           ]},
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
        name: "title",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.RichTextItemResponse, :t}},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.TranscriptionBlockResponse, type, data)
  end
end
