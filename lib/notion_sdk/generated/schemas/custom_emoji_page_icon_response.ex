defmodule NotionSDK.CustomEmojiPageIconResponse do
  @moduledoc """
  Custom Emoji

  ## Fields

    * `custom_emoji`: required
    * `type`: Type of icon. In this case, a custom emoji.

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{custom_emoji: NotionSDK.CustomEmojiResponse.t(), type: String.t()}

  defstruct [:custom_emoji, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [custom_emoji: {NotionSDK.CustomEmojiResponse, :t}, type: {:const, "custom_emoji"}]
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
        name: "custom_emoji",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.CustomEmojiResponse, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Type of icon. In this case, a custom emoji.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "custom_emoji"},
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
