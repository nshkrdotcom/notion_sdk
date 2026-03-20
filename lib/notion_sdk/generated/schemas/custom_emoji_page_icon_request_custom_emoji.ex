defmodule NotionSDK.CustomEmojiPageIconRequestCustomEmoji do
  @moduledoc """
  Generated Notion Sdk type for custom emoji page icon request custom emoji.
  """

  @enforce_keys [:id]
  defstruct [:id, :name, :url]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          url: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: :string,
      name: :string,
      url: :string
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
        name: "id",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The name of the custom emoji.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "name",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The URL of the custom emoji.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "url",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
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
      NotionSDK.CustomEmojiPageIconRequestCustomEmoji,
      type,
      data
    )
  end
end
