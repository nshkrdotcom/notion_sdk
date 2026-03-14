defmodule NotionSDK.LastEditedByPropertyItemObjectResponse do
  @moduledoc """
  LastEditedByPropertyItemObjectResponse

  ## Fields

    * `id`: required
    * `last_edited_by`: required
    * `object`: required
    * `type`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          id: String.t(),
          last_edited_by:
            NotionSDK.PartialUserObjectResponse.t() | NotionSDK.UserObjectResponse.t(),
          object: String.t(),
          type: String.t()
        }

  defstruct [:id, :last_edited_by, :object, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      id: :string,
      last_edited_by:
        {:union, [{NotionSDK.PartialUserObjectResponse, :t}, {NotionSDK.UserObjectResponse, :t}]},
      object: {:const, "property_item"},
      type: {:const, "last_edited_by"}
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
        extensions: nil,
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
        extensions: nil,
        external_docs: nil,
        name: "last_edited_by",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [{NotionSDK.PartialUserObjectResponse, :t}, {NotionSDK.UserObjectResponse, :t}]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: nil,
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
        extensions: nil,
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "last_edited_by"},
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
