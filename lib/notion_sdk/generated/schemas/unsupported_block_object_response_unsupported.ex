defmodule NotionSDK.UnsupportedBlockObjectResponseUnsupported do
  @moduledoc """
  UnsupportedBlockObjectResponseUnsupported

  ## Fields

    * `block_type`: The underlying block type that is not currently supported by the Public API. Example values include: tab, form, button, drive.

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{block_type: String.t()}

  defstruct [:block_type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [block_type: :string]
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
        description:
          "The underlying block type that is not currently supported by the Public API. Example values include: tab, form, button, drive.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "block_type",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
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
