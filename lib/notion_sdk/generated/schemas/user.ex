defmodule NotionSDK.User do
  @moduledoc """
  Generated Notion Sdk type for user.
  """

  @enforce_keys [:type, :user]
  defstruct [:type, :user]

  @type t :: %__MODULE__{
          type: String.t(),
          user: NotionSDK.PartialUserObjectResponse.t() | NotionSDK.Person.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      type: {:const, "user"},
      user: {:union, [{NotionSDK.PartialUserObjectResponse, :t}, {NotionSDK.Person, :t}]}
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
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "user"},
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
        name: "user",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [{NotionSDK.PartialUserObjectResponse, :t}, {NotionSDK.Person, :t}]},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.User, type, data)
  end
end
