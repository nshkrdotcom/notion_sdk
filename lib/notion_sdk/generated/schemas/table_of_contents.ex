defmodule NotionSDK.TableOfContents do
  @moduledoc """
  Provides struct and types for TableOfContents

  ## Types

    * Table Of Contents
    * TableOfContents.t_table_of_contents
  """
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %{
          object: String.t() | nil,
          table_of_contents:
            NotionSDK.TableOfContents.t_table_of_contents()
            | NotionSDK.TableOfContentsTableOfContents.t(),
          type: String.t() | nil
        }

  @type t_table_of_contents :: %{color: String.t() | nil}

  defstruct [:object, :table_of_contents, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      object: {:const, "block"},
      table_of_contents:
        {:union,
         [
           {NotionSDK.TableOfContents, :t_table_of_contents},
           {NotionSDK.TableOfContentsTableOfContents, :t}
         ]},
      type: {:const, "table_of_contents"}
    ]
  end

  def __fields__(:t_table_of_contents) do
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
        name: "table_of_contents",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.TableOfContents, :t_table_of_contents},
             {NotionSDK.TableOfContentsTableOfContents, :t}
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
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "table_of_contents"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:t_table_of_contents) do
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

  (
    @doc false
    @spec __schema__(atom) :: Sinter.Schema.t()
  )

  def __schema__(type \\ :t)

  def __schema__(:t) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:t))
  end

  def __schema__(:t_table_of_contents) do
    OpenAPIRuntime.build_schema(__openapi_fields__(:t_table_of_contents))
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
