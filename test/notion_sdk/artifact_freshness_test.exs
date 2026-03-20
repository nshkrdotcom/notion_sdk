defmodule NotionSDK.ArtifactFreshnessTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Codegen.Provider
  alias PristineProviderTestkit.Conformance

  @project_root Path.expand("../..", __DIR__)
  @final_artifacts [
    "priv/generated/provider_ir.json",
    "priv/generated/generation_manifest.json",
    "priv/generated/docs_inventory.json",
    "priv/generated/source_inventory.json"
  ]
  @legacy_artifacts [
    "priv/generated/manifest.json",
    "priv/generated/docs_manifest.json",
    "priv/generated/open_api_state.snapshot.term"
  ]

  test "committed generated artifacts match the migration matrix" do
    assert Enum.all?(@final_artifacts, &File.exists?(Path.join(@project_root, &1)))
    refute Enum.any?(@legacy_artifacts, &File.exists?(Path.join(@project_root, &1)))
  end

  test "provider conformance passes against the committed generated surface" do
    assert :ok = Conformance.verify_provider(Provider, project_root: @project_root)
  end
end
