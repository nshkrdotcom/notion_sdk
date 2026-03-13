Code.require_file("build_support/plt_fingerprint.ex", __DIR__)

defmodule NotionSDK.MixProject do
  use Mix.Project

  alias NotionSDK.Build.PltFingerprint

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
      {:pristine, path: "../pristine"},
      {:oauth2, "~> 2.1"},
      {:oapi_generator,
       github: "nshkrdotcom/open-api-generator", only: [:dev, :test], runtime: false},
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
      plt_add_apps: [:ex_unit, :mix, :oapi_generator],
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

  defp path_dependency?(%Mix.Dep{opts: opts}), do: is_binary(opts[:path])

  defp path_dependencies do
    Mix.Dep.load_and_cache()
    |> Enum.filter(&path_dependency?/1)
    |> Enum.map(fn %Mix.Dep{app: app, opts: opts} ->
      %{app: app, path: Path.expand(opts[:path], __DIR__)}
    end)
  end

  defp description do
    """
    Elixir SDK for the Notion API, built on Pristine's hexagonal architecture.
    Ported from the official notion-sdk-js.
    """
  end

  defp docs do
    [
      main: "readme-1",
      assets: %{"assets" => "assets"},
      logo: "assets/notion_sdk.svg",
      canonical: "https://hexdocs.pm/notion_sdk",
      source_url: @source_url,
      source_ref: "main",
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
         NotionSDK.Codegen.Processor,
         NotionSDK.Codegen.Renderer,
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
