defmodule NotionSDK.CompatibilitySurfaceTest do
  use ExUnit.Case, async: true

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
end
