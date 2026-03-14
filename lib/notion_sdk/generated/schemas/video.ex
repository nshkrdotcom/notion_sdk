defmodule NotionSDK.Video do
  @moduledoc """
  Video

  ## Fields

    * `object`: optional
    * `type`: optional
    * `video`: required

  """
  alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %{
          object: String.t() | nil,
          type: String.t() | nil,
          video: NotionSDK.External.t() | NotionSDK.FileUpload.t()
        }

  defstruct [:object, :type, :video]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      object: {:const, "block"},
      type: {:const, "video"},
      video: {:union, [{NotionSDK.External, :t}, {NotionSDK.FileUpload, :t}]}
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
        name: "object",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "block"},
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
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "video"},
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
        name: "video",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [{NotionSDK.External, :t}, {NotionSDK.FileUpload, :t}]},
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
