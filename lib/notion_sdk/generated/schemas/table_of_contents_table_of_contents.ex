defmodule NotionSDK.TableOfContentsTableOfContents do
  @moduledoc """
  Generated Notion Sdk type module `NotionSDK.TableOfContentsTableOfContents`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys []
  defstruct [:color]

  @type t :: %__MODULE__{
          color: String.t()
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
         ]}
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
        required: false,
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
      }
    ]
  end

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :t) when is_atom(type) do
    RuntimeSchema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :t)

  def decode(data, type) when is_map(data) and is_atom(type) do
    RuntimeSchema.decode_module_type(__MODULE__, type, data)
  end
end
