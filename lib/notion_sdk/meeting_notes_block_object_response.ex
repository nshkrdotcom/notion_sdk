defmodule NotionSDK.MeetingNotesBlockObjectResponse do
  @moduledoc false

  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  defstruct [:meeting_notes, :object, :type]

  @type t :: %__MODULE__{
          meeting_notes: term(),
          object: String.t() | nil,
          type: String.t() | nil
        }

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(:t) do
    [
      meeting_notes: {NotionSDK.TranscriptionBlockResponse, :t},
      object: :string,
      type: {:const, "meeting_notes"}
    ]
  end

  def __fields__(_type), do: __fields__(:t)

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
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
        name: "meeting_notes",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.TranscriptionBlockResponse, :t},
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
        required: true,
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
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "meeting_notes"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(_type), do: __openapi_fields__(:t)

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(_type \\ :t) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:t))
  end

  @doc false
  @spec decode(term(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :t) do
    OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
  end
end
