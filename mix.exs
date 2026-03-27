Code.require_file("build_support/plt_fingerprint.ex", __DIR__)
Code.require_file("build_support/dependency_resolver.exs", __DIR__)

defmodule NotionSDK.MixProject do
  use Mix.Project

  alias NotionSDK.Build.PltFingerprint
  alias NotionSDK.Build.DependencyResolver

  @version "0.1.0"
  @source_url "https://github.com/nshkrdotcom/notion_sdk"

  def project do
    [
      app: :notion_sdk,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      dialyzer: dialyzer(),
      description: description(),
      package: package(),
      name: "NotionSDK",
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs()
    ]
  end

  defp elixirc_paths(:dev), do: ["lib", "codegen"]
  defp elixirc_paths(:test), do: ["lib", "test/support", "codegen"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger],
      mod: {NotionSDK.Application, []}
    ]
  end

  defp deps do
    [
      DependencyResolver.pristine_runtime(),
      DependencyResolver.pristine_codegen(),
      DependencyResolver.pristine_provider_testkit(only: :test),
      {:oapi_generator,
       github: "nshkrdotcom/open-api-generator",
       branch: "doc-generator-fix",
       only: [:dev, :test],
       runtime: false},
      {:jason, "~> 1.4"},
      {:finch, "~> 0.18"},
      {:telemetry, "~> 1.2"},
      {:mox, "~> 1.1", only: :test},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit, :mix, :oapi_generator, :pristine, :pristine_codegen],
      plt_core_path: "priv/plts/core",
      plt_local_path: Path.join("priv/plts/project", project_plt_fingerprint())
    ]
  end

  defp project_plt_fingerprint do
    PltFingerprint.project(
      project_root: __DIR__,
      dependencies: path_dependencies()
    )
  end

  defp path_dependencies do
    deps()
    |> Enum.flat_map(&path_dependency/1)
  end

  defp path_dependency({app, opts}) when is_atom(app) and is_list(opts) do
    path_dependency(app, opts)
  end

  defp path_dependency({app, _requirement, opts}) when is_atom(app) and is_list(opts) do
    path_dependency(app, opts)
  end

  defp path_dependency(_dependency), do: []

  defp path_dependency(app, opts) do
    case Keyword.fetch(opts, :path) do
      {:ok, path} -> [%{app: app, path: Path.expand(path, __DIR__)}]
      :error -> []
    end
  end

  defp description do
    """
    Elixir SDK for the Notion API, built on Pristine's hexagonal architecture.
    Ported from the official notion-sdk-js.
    """
  end

  defp package do
    [
      name: "notion_sdk",
      description: description(),
      files: ~w(build_support config lib priv mix.exs README.md CHANGELOG.md LICENSE),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      },
      maintainers: ["nshkrdotcom"]
    ]
  end

  defp docs do
    [
      main: "readme-1",
      assets: %{"assets" => "assets"},
      logo: "assets/notion_sdk.svg",
      canonical: "https://hexdocs.pm/notion_sdk",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules()
    ]
  end

  defp extras do
    [
      "README.md",
      # Getting Started
      "guides/getting-started.md",
      "guides/client-configuration.md",
      "guides/versioning-and-compatibility.md",
      # Working with Notion
      "guides/capabilities-permissions-and-sharing.md",
      "guides/pages-blocks-and-search.md",
      "guides/content-creation-and-mutation.md",
      "guides/data-sources-and-databases.md",
      "guides/file-uploads-comments-and-users.md",
      "guides/file-uploads-and-page-attachments.md",
      # Examples
      "examples/README.md",
      "examples/cookbook/README.md",
      # Authentication & Security
      "guides/oauth-and-auth-overrides.md",
      # Advanced
      "guides/low-level-requests.md",
      "guides/pagination-helpers-and-guards.md",
      "guides/errors-retries-and-observability.md",
      # Internals
      "guides/regeneration-and-parity.md",
      # Release Notes
      "CHANGELOG.md",
      "LICENSE"
    ]
  end

  defp groups_for_extras do
    [
      {"Overview", ["README.md"]},
      {"Getting Started",
       [
         "guides/getting-started.md",
         "guides/client-configuration.md",
         "guides/versioning-and-compatibility.md"
       ]},
      {"Working with Notion",
       [
         "guides/capabilities-permissions-and-sharing.md",
         "guides/pages-blocks-and-search.md",
         "guides/content-creation-and-mutation.md",
         "guides/data-sources-and-databases.md",
         "guides/file-uploads-comments-and-users.md",
         "guides/file-uploads-and-page-attachments.md"
       ]},
      {"Examples", ["examples/README.md", "examples/cookbook/README.md"]},
      {"Authentication & Security",
       [
         "guides/oauth-and-auth-overrides.md"
       ]},
      {"Advanced",
       [
         "guides/low-level-requests.md",
         "guides/pagination-helpers-and-guards.md",
         "guides/errors-retries-and-observability.md"
       ]},
      {"Internals",
       [
         "guides/regeneration-and-parity.md"
       ]},
      {"Release Notes", ["CHANGELOG.md", "LICENSE"]}
    ]
  end

  defp groups_for_modules do
    [
      {"Core",
       [
         NotionSDK.Client,
         NotionSDK.Error,
         NotionSDK.Guards,
         NotionSDK.Helpers,
         NotionSDK.OAuthTokenFile,
         NotionSDK.Pagination
       ]},
      {"API Namespaces",
       [
         NotionSDK.Blocks,
         NotionSDK.Comments,
         NotionSDK.DataSources,
         NotionSDK.Databases,
         NotionSDK.FileUploads,
         NotionSDK.OAuth,
         NotionSDK.Pages,
         NotionSDK.Search,
         NotionSDK.Users
       ]},
      {"Tooling",
       [
         NotionSDK.Codegen,
         NotionSDK.Codegen.OpenAPIProcessor,
         NotionSDK.Codegen.Provider,
         NotionSDK.Codegen.Plugins.Source,
         NotionSDK.Codegen.Source.Extractor,
         NotionSDK.Codegen.Source.PageContext,
         Mix.Tasks.Notion.Oauth,
         NotionSDK.Refresh,
         Mix.Tasks.Notion.Generate,
         Mix.Tasks.Notion.Refresh
       ]},
      {"Generated Types", generated_type_module_pattern()}
    ]
  end

  defp generated_type_module_pattern do
    ~r/^NotionSDK\.(?!Application$|Auth(?:\.|$)|Blocks$|Client$|Codegen(?:\.|$)|Comments$|DataSources$|Databases$|Error$|FileUploads$|Guards$|Helpers$|OAuth$|OAuthTokenFile$|Pages$|Pagination$|Refresh$|Retry$|Search$|Users$)[A-Z]/
  end
end
