defmodule NotionSDK.ProviderContractTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Codegen.Plugins.Source
  alias NotionSDK.Codegen.Provider
  alias PristineCodegen.Compiler

  @moduletag timeout: 120_000

  test "source plugin loads committed notion fixtures into a bounded dataset" do
    dataset = Source.load(Provider, project_root: project_root())

    assert length(dataset.operations) == 35

    assert Enum.any?(dataset.operations, fn operation ->
             operation.module == NotionSDK.Pages and operation.function == :retrieve
           end)

    assert Enum.any?(dataset.operations, fn operation ->
             operation.path_template == "/v1/oauth/token" and operation.function == :token
           end)

    assert Enum.any?(dataset.schemas, &(&1.module == NotionSDK.PageObjectResponse))
    assert Enum.any?(dataset.schemas, &(&1.module == NotionSDK.MeetingNotesBlockObjectResponse))

    assert Enum.any?(dataset.fingerprints.sources, fn source ->
             String.ends_with?(source.path, "priv/upstream/reference/get-self.yaml")
           end)

    assert Enum.any?(dataset.fingerprints.sources, fn source ->
             String.ends_with?(
               source.path,
               "priv/upstream/reference_context/retrieve-a-page.json"
             )
           end)
  end

  test "provider compiles into the final provider ir and artifact contract" do
    assert {:ok, compilation} =
             Compiler.compile(Provider, project_root: project_root())

    provider_ir = compilation.provider_ir

    assert provider_ir.provider.base_module == NotionSDK
    assert provider_ir.provider.package_app == :notion_sdk
    assert provider_ir.provider.package_name == "notion_sdk"
    assert provider_ir.provider.source_strategy == :openapi_plus_source_plugin

    assert Enum.any?(provider_ir.operations, fn operation ->
             operation.module == NotionSDK.Pages and operation.function == :retrieve
           end)

    assert Enum.any?(provider_ir.operations, fn operation ->
             operation.module == NotionSDK.OAuth and operation.function == :token
           end)

    assert Enum.any?(provider_ir.schemas, &(&1.module == NotionSDK.PageObjectResponse))

    artifact_paths = Enum.map(provider_ir.artifact_plan.artifacts, & &1.path)

    assert "priv/generated/provider_ir.json" in artifact_paths
    assert "priv/generated/generation_manifest.json" in artifact_paths
    assert "priv/generated/docs_inventory.json" in artifact_paths
    assert "priv/generated/source_inventory.json" in artifact_paths

    refute "priv/generated/manifest.json" in artifact_paths
    refute "priv/generated/docs_manifest.json" in artifact_paths
    refute "priv/generated/open_api_state.snapshot.term" in artifact_paths
  end

  defp project_root do
    Path.expand("../..", __DIR__)
  end
end
