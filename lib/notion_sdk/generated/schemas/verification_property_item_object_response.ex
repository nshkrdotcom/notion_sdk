defmodule NotionSDK.VerificationPropertyItemObjectResponse do
  @moduledoc """
  Verification

  ## Fields

    * `id`: required
    * `object`: required
    * `type`: required
    * `verification`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          id: String.t(),
          object: String.t(),
          type: String.t(),
          verification:
            NotionSDK.VerificationPropertyResponse.t()
            | NotionSDK.VerificationPropertyUnverifiedResponse.t()
            | nil
        }

  defstruct [:id, :object, :type, :verification]

  @doc false
  @spec __fields__(atom) :: keyword
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
           {NotionSDK.VerificationPropertyUnverifiedResponse, :t},
           {NotionSDK.VerificationPropertyResponse, :t}
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
             {NotionSDK.VerificationPropertyUnverifiedResponse, :t},
             {NotionSDK.VerificationPropertyResponse, :t}
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

  (
    @doc false
    @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
    def decode(data, type \\ :t)

    def decode(data, type) do
      OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
    end
  )
end
