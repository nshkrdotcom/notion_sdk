defmodule NotionSDK.CalloutBlockObjectResponseCallout do
  @moduledoc """
  Generated Notion Sdk type for callout block object response callout.
  """

  @enforce_keys [:color, :icon, :rich_text]
  defstruct [:color, :icon, :rich_text]

  @type t :: %__MODULE__{
          color: String.t(),
          icon:
            nil
            | NotionSDK.CustomEmojiPageIconResponse.t()
            | NotionSDK.EmojiPageIconResponse.t()
            | NotionSDK.ExternalPageIconResponse.t()
            | NotionSDK.FilePageIconResponse.t(),
          rich_text: [NotionSDK.RichTextItemResponse.t()]
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      color:
        {:enum,
         [
           "default",
           "gray",
           "brown",
           "orange",
           "yellow",
           "green",
           "blue",
           "purple",
           "pink",
           "red",
           "default_background",
           "gray_background",
           "brown_background",
           "orange_background",
           "yellow_background",
           "green_background",
           "blue_background",
           "purple_background",
           "pink_background",
           "red_background"
         ]},
      icon:
        {:union,
         [
           :null,
           {NotionSDK.CustomEmojiPageIconResponse, :t},
           {NotionSDK.EmojiPageIconResponse, :t},
           {NotionSDK.ExternalPageIconResponse, :t},
           {NotionSDK.FilePageIconResponse, :t}
         ]},
      rich_text: {:array, {NotionSDK.RichTextItemResponse, :t}}
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
        description:
          "One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`, `purple`, `pink`, `red`, `default_background`, `gray_background`, `brown_background`, `orange_background`, `yellow_background`, `green_background`, `blue_background`, `purple_background`, `pink_background`, `red_background`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "color",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:enum,
           [
             "default",
             "gray",
             "brown",
             "orange",
             "yellow",
             "green",
             "blue",
             "purple",
             "pink",
             "red",
             "default_background",
             "gray_background",
             "brown_background",
             "orange_background",
             "yellow_background",
             "green_background",
             "blue_background",
             "purple_background",
             "pink_background",
             "red_background"
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
        name: "icon",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             :null,
             {NotionSDK.CustomEmojiPageIconResponse, :t},
             {NotionSDK.EmojiPageIconResponse, :t},
             {NotionSDK.ExternalPageIconResponse, :t},
             {NotionSDK.FilePageIconResponse, :t}
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
        name: "rich_text",
        nullable: false,
        read_only: false,
        required: true,
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
    Pristine.Runtime.Schema.decode_module_type(
      NotionSDK.CalloutBlockObjectResponseCallout,
      type,
      data
    )
  end
end
