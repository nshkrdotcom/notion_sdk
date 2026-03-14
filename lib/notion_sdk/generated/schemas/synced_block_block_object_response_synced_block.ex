defmodule NotionSDK.SyncedBlockBlockObjectResponseSyncedBlock do
  @moduledoc """
  SyncedBlockBlockObjectResponseSyncedBlock

  ## Fields

    * `synced_from`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime
  alias Pristine.OpenAPI.Runtime, as: OpenAPIRuntime

  @type t :: %__MODULE__{synced_from: NotionSDK.BlockId.t() | nil}

  defstruct [:synced_from]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [synced_from: {:union, [:null, {NotionSDK.BlockId, :t}]}]
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
        name: "synced_from",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, {NotionSDK.BlockId, :t}]},
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
