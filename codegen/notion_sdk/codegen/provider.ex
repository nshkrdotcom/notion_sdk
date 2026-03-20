defmodule NotionSDK.Codegen.Provider do
  @moduledoc false

  @behaviour PristineCodegen.Provider

  alias NotionSDK.Codegen

  @impl true
  def definition(_opts) do
    %{
      provider: %{
        id: :notion_sdk,
        base_module: NotionSDK,
        client_module: NotionSDK.Client,
        package_app: :notion_sdk,
        package_name: "notion_sdk",
        source_strategy: :openapi_plus_source_plugin
      },
      runtime_defaults: %{
        base_url: "https://api.notion.com",
        default_headers: %{"Notion-Version" => NotionSDK.Client.default_notion_version()},
        user_agent_prefix: "notion-sdk-elixir",
        timeout_ms: 60_000,
        retry_defaults: %{strategy: :standard},
        serializer: :json,
        typed_responses_default: false
      },
      operations: [],
      schemas: [],
      auth_policies: [],
      pagination_policies: [],
      docs_inventory: %{guides: [], examples: [], operations: %{}},
      fingerprints: %{sources: [], generation: %{}},
      artifact_plan: %{
        generated_code_dir: "lib/notion_sdk/generated",
        artifacts: [
          %{id: :provider_ir, path: "priv/generated/provider_ir.json"},
          %{id: :generation_manifest, path: "priv/generated/generation_manifest.json"},
          %{id: :docs_inventory, path: "priv/generated/docs_inventory.json"},
          %{id: :source_inventory, path: "priv/generated/source_inventory.json"}
        ],
        forbidden_paths: [
          "priv/generated/manifest.json",
          "priv/generated/docs_manifest.json",
          "priv/generated/open_api_state.snapshot.term"
        ]
      }
    }
  end

  @impl true
  def paths(opts) do
    paths = Codegen.paths(opts)

    %{
      project_root: paths.project_root,
      generated_code_dir: paths.generated_dir,
      generated_artifact_dir: paths.generated_artifact_dir
    }
  end

  @impl true
  def source_plugins, do: [NotionSDK.Codegen.Plugins.Source]

  @impl true
  def auth_plugins, do: []

  @impl true
  def pagination_plugins, do: []

  @impl true
  def docs_plugins, do: []

  @impl true
  def refresh(opts) do
    Codegen.extract_upstream!(opts)
  end
end
