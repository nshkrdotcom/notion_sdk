defmodule NotionSDK.VerificationPropertyItemObjectResponse do
  @moduledoc """
  Generated Notion Sdk type module `NotionSDK.VerificationPropertyItemObjectResponse`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [:id, :object, :type, :verification]
  defstruct [:id, :object, :type, :verification]

  @type t :: %__MODULE__{
          id: String.t(),
          object: String.t(),
          type: String.t(),
          verification:
            nil
            | NotionSDK.VerificationPropertyResponse.t()
            | NotionSDK.VerificationPropertyUnverifiedResponse.t()
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: :string,
      object: {:const, "property_item"},
      type: {:const, "verification"},
      verification:
        {:union,
         [
           :null,
           {NotionSDK.VerificationPropertyResponse, :t},
           {NotionSDK.VerificationPropertyUnverifiedResponse, :t}
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
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "property_item"},
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
        required: true,
        type: {:const, "verification"},
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
        name: "verification",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             :null,
             {NotionSDK.VerificationPropertyResponse, :t},
             {NotionSDK.VerificationPropertyUnverifiedResponse, :t}
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
