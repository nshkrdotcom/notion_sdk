defmodule NotionSDK.CustomEmojiPageIconResponse do
  @moduledoc """
  Generated Notion Sdk type for custom emoji page icon response.
  """

  @enforce_keys [:custom_emoji, :type]
  defstruct [:custom_emoji, :type]

  @type t :: %__MODULE__{
          custom_emoji: NotionSDK.CustomEmojiResponse.t(),
          type: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      custom_emoji: {NotionSDK.CustomEmojiResponse, :t},
      type: {:const, "custom_emoji"}
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

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :t) when is_atom(type) do
    Pristine.Runtime.Schema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :t)

  def decode(data, type) when is_map(data) and is_atom(type) do
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.CustomEmojiPageIconResponse, type, data)
  end
end
