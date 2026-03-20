defmodule NotionSDK.ErrorApi404 do
  @moduledoc """
  Generated Notion Sdk type for error api404.
  """

  @enforce_keys []
  defstruct [:additional_data, :code, :message, :object, :status]

  @type t :: %__MODULE__{
          additional_data: map(),
          code: String.t(),
          message: String.t(),
          object: String.t(),
          status: 404
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      additional_data: :map,
      code: {:const, "object_not_found"},
      message: :string,
      object: {:const, "error"},
      status: {:const, 404}
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
        name: "additional_data",
        nullable: false,
        read_only: false,
        required: false,
        type: :map,
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
        name: "code",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "object_not_found"},
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
        name: "message",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
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
        name: "object",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "error"},
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
        type: {:const, 404},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.ErrorApi404, type, data)
  end
end
