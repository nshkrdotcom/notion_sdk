defmodule NotionSDK.CodeCode do
  @moduledoc """
  CodeCode

  ## Fields

    * `caption`: optional
    * `language`: required
    * `rich_text`: required

  """
  alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime

  @type t :: %__MODULE__{
          caption: [NotionSDK.RichTextItemRequest.t()] | nil,
          language: String.t(),
          rich_text: [NotionSDK.RichTextItemRequest.t()]
        }

  defstruct [:caption, :language, :rich_text]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      caption: [{NotionSDK.RichTextItemRequest, :t}],
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
      rich_text: [{NotionSDK.RichTextItemRequest, :t}]
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
        name: "caption",
        nullable: false,
        read_only: false,
        required: false,
        type: [{NotionSDK.RichTextItemRequest, :t}],
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
        type: [{NotionSDK.RichTextItemRequest, :t}],
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
