defmodule NotionSDK.ContentWithTableRowRequest do
  @moduledoc """
  Generated Notion Sdk type for content with table row request.
  """

  @enforce_keys [:cells]
  defstruct [:cells]

  @type t :: %__MODULE__{
          cells: [[NotionSDK.RichTextItemRequest.t()]]
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      cells: {:array, {:array, {NotionSDK.RichTextItemRequest, :t}}}
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
        name: "cells",
        nullable: false,
        read_only: false,
        required: true,
        type: {:array, {:array, {NotionSDK.RichTextItemRequest, :t}}},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.ContentWithTableRowRequest, type, data)
  end
end
