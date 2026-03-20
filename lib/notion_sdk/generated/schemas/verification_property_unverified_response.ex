defmodule NotionSDK.VerificationPropertyUnverifiedResponse do
  @moduledoc """
  Generated Notion Sdk type for verification property unverified response.
  """

  @enforce_keys [:date, :state, :verified_by]
  defstruct [:date, :state, :verified_by]

  @type t :: %__MODULE__{
          date: nil,
          state: String.t(),
          verified_by: nil
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      date: :null,
      state: {:const, "unverified"},
      verified_by: :null
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
        name: "date",
        nullable: false,
        read_only: false,
        required: true,
        type: :null,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "Always `unverified`",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "state",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "unverified"},
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
        name: "verified_by",
        nullable: false,
        read_only: false,
        required: true,
        type: :null,
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
      NotionSDK.VerificationPropertyUnverifiedResponse,
      type,
      data
    )
  end
end
