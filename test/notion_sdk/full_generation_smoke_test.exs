defmodule NotionSDK.FullGenerationSmokeTest do
  use ExUnit.Case, async: false

  alias NotionSDK.Codegen
  alias NotionSDK.ParityInventory

  @moduletag timeout: 120_000

  test "generate! completes from committed fixtures without mutating the repo" do
    project_root = Codegen.project_root()
    inventory = ParityInventory.summary(project_root: project_root)
    tmp_dir = make_tmp_dir!("full_generation")

    state =
      Codegen.generate!(
        project_root: project_root,
        reference_root: Path.join(tmp_dir, "missing_reference"),
        generated_dir: Path.join(tmp_dir, "lib/notion_sdk/generated"),
        generated_artifact_dir: Path.join(tmp_dir, "priv/generated")
      )

    manifest_path = Path.join(tmp_dir, "priv/generated/manifest.json")
    docs_manifest_path = Path.join(tmp_dir, "priv/generated/docs_manifest.json")
    snapshot_path = Path.join(tmp_dir, "priv/generated/open_api_state.snapshot.term")

    manifest = Jason.decode!(File.read!(manifest_path))
    docs_manifest = Jason.decode!(File.read!(docs_manifest_path))

    assert length(state.ir.operations) == inventory["operation_count"]
    assert state.ir.schemas != []
    assert manifest["operation_count"] == inventory["operation_count"]
    assert manifest["schema_count"] > 0
    assert manifest["operation_modules"] != []
    refute Map.has_key?(manifest, "compatibility")
    refute Map.has_key?(docs_manifest, "compatibility")
    assert length(docs_manifest["operations"]) == inventory["operation_count"]
    assert File.exists?(snapshot_path)

    generated_files =
      tmp_dir
      |> Path.join("lib/notion_sdk/generated/**/*.ex")
      |> Path.wildcard()

    assert generated_files != []

    assert Path.join(
             tmp_dir,
             "lib/notion_sdk/generated/schemas/meeting_notes_block_object_response.ex"
           ) in generated_files

    assert Path.join(tmp_dir, "lib/notion_sdk/generated/schemas/transcription_block_response.ex") in generated_files
  end

  defp make_tmp_dir!(name) do
    path =
      System.tmp_dir!()
      |> Path.join("notion_sdk_#{name}_#{System.unique_integer([:positive])}")

    File.rm_rf!(path)
    File.mkdir_p!(path)
    on_exit(fn -> File.rm_rf!(path) end)
    path
  end
end
