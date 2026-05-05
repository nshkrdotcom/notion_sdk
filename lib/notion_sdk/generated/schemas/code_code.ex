defmodule NotionSDK.CodeCode do
  @moduledoc """
  Generated Notion Sdk type module `NotionSDK.CodeCode`.
  """

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  @enforce_keys [:language, :rich_text]
  defstruct [:caption, :language, :rich_text]

  @type t :: %__MODULE__{
          caption: [NotionSDK.RichTextItemRequest.t()],
          language: String.t(),
          rich_text: [NotionSDK.RichTextItemRequest.t()]
        }
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      caption: {:array, {NotionSDK.RichTextItemRequest, :t}},
      language:
        {:enum,
         [
           "abap",
           "abc",
           "agda",
           "arduino",
           "ascii art",
           "assembly",
           "bash",
           "basic",
           "bnf",
           "c",
           "c#",
           "c++",
           "clojure",
           "coffeescript",
           "coq",
           "css",
           "dart",
           "dhall",
           "diff",
           "docker",
           "ebnf",
           "elixir",
           "elm",
           "erlang",
           "f#",
           "flow",
           "fortran",
           "gherkin",
           "glsl",
           "go",
           "graphql",
           "groovy",
           "haskell",
           "hcl",
           "html",
           "idris",
           "java",
           "javascript",
           "json",
           "julia",
           "kotlin",
           "latex",
           "less",
           "lisp",
           "livescript",
           "llvm ir",
           "lua",
           "makefile",
           "markdown",
           "markup",
           "matlab",
           "mathematica",
           "mermaid",
           "nix",
           "notion formula",
           "objective-c",
           "ocaml",
           "pascal",
           "perl",
           "php",
           "plain text",
           "powershell",
           "prolog",
           "protobuf",
           "purescript",
           "python",
           "r",
           "racket",
           "reason",
           "ruby",
           "rust",
           "sass",
           "scala",
           "scheme",
           "scss",
           "shell",
           "smalltalk",
           "solidity",
           "sql",
           "swift",
           "toml",
           "typescript",
           "vb.net",
           "verilog",
           "vhdl",
           "visual basic",
           "webassembly",
           "xml",
           "yaml",
           "java/c/c++/c#"
         ]},
      rich_text: {:array, {NotionSDK.RichTextItemRequest, :t}}
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
        name: "caption",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
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
        name: "language",
        nullable: false,
        read_only: false,
        required: true,
        type:
          {:enum,
           [
             "abap",
             "abc",
             "agda",
             "arduino",
             "ascii art",
             "assembly",
             "bash",
             "basic",
             "bnf",
             "c",
             "c#",
             "c++",
             "clojure",
             "coffeescript",
             "coq",
             "css",
             "dart",
             "dhall",
             "diff",
             "docker",
             "ebnf",
             "elixir",
             "elm",
             "erlang",
             "f#",
             "flow",
             "fortran",
             "gherkin",
             "glsl",
             "go",
             "graphql",
             "groovy",
             "haskell",
             "hcl",
             "html",
             "idris",
             "java",
             "javascript",
             "json",
             "julia",
             "kotlin",
             "latex",
             "less",
             "lisp",
             "livescript",
             "llvm ir",
             "lua",
             "makefile",
             "markdown",
             "markup",
             "matlab",
             "mathematica",
             "mermaid",
             "nix",
             "notion formula",
             "objective-c",
             "ocaml",
             "pascal",
             "perl",
             "php",
             "plain text",
             "powershell",
             "prolog",
             "protobuf",
             "purescript",
             "python",
             "r",
             "racket",
             "reason",
             "ruby",
             "rust",
             "sass",
             "scala",
             "scheme",
             "scss",
             "shell",
             "smalltalk",
             "solidity",
             "sql",
             "swift",
             "toml",
             "typescript",
             "vb.net",
             "verilog",
             "vhdl",
             "visual basic",
             "webassembly",
             "xml",
             "yaml",
             "java/c/c++/c#"
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
        name: "rich_text",
        nullable: false,
        read_only: false,
        required: true,
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
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
