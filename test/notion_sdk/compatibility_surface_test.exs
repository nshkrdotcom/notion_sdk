defmodule NotionSDK.CompatibilitySurfaceTest do
  use ExUnit.Case, async: true

  @manifest_path Path.expand("../../priv/generated/manifest.json", __DIR__)
  @docs_manifest_path Path.expand("../../priv/generated/docs_manifest.json", __DIR__)
  @versioning_guide_path Path.expand("../../guides/versioning-and-compatibility.md", __DIR__)

  test "keeps the default Notion API version pinned to 2025-09-03" do
    assert NotionSDK.Client.default_notion_version() == "2025-09-03"
  end

  test "includes newer insert-position variants in the committed generated surface" do
    assert Keyword.fetch!(NotionSDK.Blocks.__fields__(:append_children_json_req_position), :type) ==
             {:enum, ["after_block", "end", "start"]}

    assert Keyword.fetch!(
             NotionSDK.Blocks.__fields__(:append_children_json_req_position),
             :after_block
           ) ==
             {NotionSDK.Blocks, :append_children_json_req_position_after_block}

    assert Keyword.fetch!(NotionSDK.Pages.__fields__(:create_json_req_position), :type) ==
             {:enum, ["after_block", "page_end", "page_start"]}

    assert Keyword.fetch!(NotionSDK.Pages.__fields__(:create_json_req_position), :after_block) ==
             {NotionSDK.Pages, :create_json_req_position_after_block}
  end

  test "includes additive modern response fields such as in_trash and meeting_notes" do
    assert Keyword.fetch!(NotionSDK.PageObjectResponse.__fields__(:t), :in_trash) == :boolean

    assert Keyword.fetch!(
             NotionSDK.MeetingNotesBlockObjectResponse.__fields__(:t),
             :meeting_notes
           ) ==
             {NotionSDK.TranscriptionBlockResponse, :t}
  end

  test "publishes a machine-readable compatibility contract in committed generated artifacts" do
    manifest = Jason.decode!(File.read!(@manifest_path))
    docs_manifest = Jason.decode!(File.read!(@docs_manifest_path))
    contract = NotionSDK.CompatibilityContract.load!()

    assert manifest["compatibility"] == contract
    assert docs_manifest["compatibility"] == contract
    assert contract["default_notion_version"] == NotionSDK.Client.default_notion_version()
    assert contract["opt_in_versions"] == ["2026-03-11"]

    assert Enum.any?(contract["known_seams"], fn seam ->
             seam["field"] == "position" and seam["minimum_api_version"] == "2026-03-11"
           end)

    assert Enum.any?(contract["known_seams"], fn seam ->
             seam["field"] == "meeting_notes" and seam["renamed_from"] == "transcription"
           end)
  end

  test "documents the explicit opt-in path for newer version seams" do
    guide = File.read!(@versioning_guide_path)

    assert guide =~ "2026-03-11"
    assert guide =~ "opt-in"
    assert guide =~ "priv/upstream/version_contract.json"
  end
end
