defmodule NotionSDK.UserObjectResponse do
  @moduledoc """
  Generated Notion Sdk type for user object response.
  """

  @enforce_keys []
  defstruct [:avatar_url, :id, :name, :object]

  @type t :: %__MODULE__{
          avatar_url: nil | String.t(),
          id: String.t(),
          name: nil | String.t(),
          object: String.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      avatar_url: {:union, [:null, :string]},
      id: {:string, "uuid"},
      name: {:union, [:null, :string]},
      object: {:const, "user"}
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
        description: "The avatar URL of the user.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "avatar_url",
        nullable: false,
        read_only: false,
        required: false,
        type: {:union, [:null, :string]},
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
        name: "id",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "uuid"},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The name of the user.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "name",
        nullable: false,
        read_only: false,
        required: false,
        type: {:union, [:null, :string]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The user object type name.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "object",
        nullable: false,
        read_only: false,
        required: false,
        type: {:const, "user"},
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
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.UserObjectResponse, type, data)
  end
end
