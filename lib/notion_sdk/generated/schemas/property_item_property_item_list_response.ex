defmodule NotionSDK.PropertyItemPropertyItemListResponse do
  @moduledoc """
  Property Item

  ## Fields

    * `has_more`: required
    * `next_cursor`: required
    * `object`: required
    * `property_item`: required
    * `results`: required
    * `type`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          has_more: boolean,
          next_cursor: String.t() | nil,
          object: String.t(),
          property_item:
            NotionSDK.People.t()
            | NotionSDK.Relation.t()
            | NotionSDK.RichText.t()
            | NotionSDK.Rollup.t()
            | NotionSDK.Title.t(),
          results: [
            NotionSDK.ButtonPropertyItemObjectResponse.t()
            | NotionSDK.CheckboxPropertyItemObjectResponse.t()
            | NotionSDK.CreatedByPropertyItemObjectResponse.t()
            | NotionSDK.CreatedTimePropertyItemObjectResponse.t()
            | NotionSDK.DatePropertyItemObjectResponse.t()
            | NotionSDK.EmailPropertyItemObjectResponse.t()
            | NotionSDK.FilesPropertyItemObjectResponse.t()
            | NotionSDK.FormulaPropertyItemObjectResponse.t()
            | NotionSDK.LastEditedByPropertyItemObjectResponse.t()
            | NotionSDK.LastEditedTimePropertyItemObjectResponse.t()
            | NotionSDK.MultiSelectPropertyItemObjectResponse.t()
            | NotionSDK.NumberPropertyItemObjectResponse.t()
            | NotionSDK.PeoplePropertyItemObjectResponse.t()
            | NotionSDK.PhoneNumberPropertyItemObjectResponse.t()
            | NotionSDK.PlacePropertyItemObjectResponse.t()
            | NotionSDK.RelationPropertyItemObjectResponse.t()
            | NotionSDK.RichTextPropertyItemObjectResponse.t()
            | NotionSDK.RollupPropertyItemObjectResponse.t()
            | NotionSDK.SelectPropertyItemObjectResponse.t()
            | NotionSDK.StatusPropertyItemObjectResponse.t()
            | NotionSDK.TitlePropertyItemObjectResponse.t()
            | NotionSDK.UniqueIdPropertyItemObjectResponse.t()
            | NotionSDK.UrlPropertyItemObjectResponse.t()
            | NotionSDK.VerificationPropertyItemObjectResponse.t()
          ],
          type: String.t()
        }

  defstruct [:has_more, :next_cursor, :object, :property_item, :results, :type]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      has_more: :boolean,
      next_cursor: {:union, [:null, :string]},
      object: {:const, "list"},
      property_item:
        {:union,
         [
           {NotionSDK.Title, :t},
           {NotionSDK.RichText, :t},
           {NotionSDK.People, :t},
           {NotionSDK.Relation, :t},
           {NotionSDK.Rollup, :t}
         ]},
      results: [
        union: [
          {NotionSDK.NumberPropertyItemObjectResponse, :t},
          {NotionSDK.UrlPropertyItemObjectResponse, :t},
          {NotionSDK.SelectPropertyItemObjectResponse, :t},
          {NotionSDK.MultiSelectPropertyItemObjectResponse, :t},
          {NotionSDK.StatusPropertyItemObjectResponse, :t},
          {NotionSDK.DatePropertyItemObjectResponse, :t},
          {NotionSDK.EmailPropertyItemObjectResponse, :t},
          {NotionSDK.PhoneNumberPropertyItemObjectResponse, :t},
          {NotionSDK.CheckboxPropertyItemObjectResponse, :t},
          {NotionSDK.FilesPropertyItemObjectResponse, :t},
          {NotionSDK.CreatedByPropertyItemObjectResponse, :t},
          {NotionSDK.CreatedTimePropertyItemObjectResponse, :t},
          {NotionSDK.LastEditedByPropertyItemObjectResponse, :t},
          {NotionSDK.LastEditedTimePropertyItemObjectResponse, :t},
          {NotionSDK.FormulaPropertyItemObjectResponse, :t},
          {NotionSDK.ButtonPropertyItemObjectResponse, :t},
          {NotionSDK.UniqueIdPropertyItemObjectResponse, :t},
          {NotionSDK.VerificationPropertyItemObjectResponse, :t},
          {NotionSDK.PlacePropertyItemObjectResponse, :t},
          {NotionSDK.TitlePropertyItemObjectResponse, :t},
          {NotionSDK.RichTextPropertyItemObjectResponse, :t},
          {NotionSDK.PeoplePropertyItemObjectResponse, :t},
          {NotionSDK.RelationPropertyItemObjectResponse, :t},
          {NotionSDK.RollupPropertyItemObjectResponse, :t}
        ]
      ],
      type: {:const, "property_item"}
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
        name: "has_more",
        nullable: false,
        read_only: false,
        required: true,
        type: :boolean,
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
        name: "next_cursor",
        nullable: false,
        read_only: false,
        required: true,
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
        name: "object",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "list"},
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
        name: "property_item",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:union,
           [
             {NotionSDK.Title, :t},
             {NotionSDK.RichText, :t},
             {NotionSDK.People, :t},
             {NotionSDK.Relation, :t},
             {NotionSDK.Rollup, :t}
           ]},
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
        name: "results",
        nullable: false,
        read_only: false,
        required: true,
        type: [
          union: [
            {NotionSDK.NumberPropertyItemObjectResponse, :t},
            {NotionSDK.UrlPropertyItemObjectResponse, :t},
            {NotionSDK.SelectPropertyItemObjectResponse, :t},
            {NotionSDK.MultiSelectPropertyItemObjectResponse, :t},
            {NotionSDK.StatusPropertyItemObjectResponse, :t},
            {NotionSDK.DatePropertyItemObjectResponse, :t},
            {NotionSDK.EmailPropertyItemObjectResponse, :t},
            {NotionSDK.PhoneNumberPropertyItemObjectResponse, :t},
            {NotionSDK.CheckboxPropertyItemObjectResponse, :t},
            {NotionSDK.FilesPropertyItemObjectResponse, :t},
            {NotionSDK.CreatedByPropertyItemObjectResponse, :t},
            {NotionSDK.CreatedTimePropertyItemObjectResponse, :t},
            {NotionSDK.LastEditedByPropertyItemObjectResponse, :t},
            {NotionSDK.LastEditedTimePropertyItemObjectResponse, :t},
            {NotionSDK.FormulaPropertyItemObjectResponse, :t},
            {NotionSDK.ButtonPropertyItemObjectResponse, :t},
            {NotionSDK.UniqueIdPropertyItemObjectResponse, :t},
            {NotionSDK.VerificationPropertyItemObjectResponse, :t},
            {NotionSDK.PlacePropertyItemObjectResponse, :t},
            {NotionSDK.TitlePropertyItemObjectResponse, :t},
            {NotionSDK.RichTextPropertyItemObjectResponse, :t},
            {NotionSDK.PeoplePropertyItemObjectResponse, :t},
            {NotionSDK.RelationPropertyItemObjectResponse, :t},
            {NotionSDK.RollupPropertyItemObjectResponse, :t}
          ]
        ],
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
        type: {:const, "property_item"},
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
