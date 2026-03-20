defmodule NotionSDK.Code do
  @moduledoc """
  Generated Notion Sdk type for code.
  """

  @enforce_keys [:code]
  defstruct [:code, :object, :type]

  @type t :: %__MODULE__{
          code: NotionSDK.CodeCode.t(),
          object: String.t(),
          type: String.t()
        }

  @type t_code :: map()
  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      code: {NotionSDK.CodeCode, :t},
      object: {:const, "block"},
      type: {:const, "code"}
    ]
  end

  def __fields__(:t_code) do
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
        name: "code",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.CodeCode, :t},
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
        required: false,
        type: {:const, "block"},
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
        required: false,
        type: {:const, "code"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:t_code) do
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
    Pristine.Runtime.Schema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :t)

  def decode(data, type) when is_map(data) and is_atom(type) do
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.Code, type, data)
  end
end
