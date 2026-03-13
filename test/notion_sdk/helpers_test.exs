defmodule NotionSDK.HelpersTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Helpers

  describe "extract_notion_id/1" do
    test "extracts UUIDs from canonical and compact forms" do
      assert Helpers.extract_notion_id("abc12345-1234-5678-9abc-def012345678") ==
               "abc12345-1234-5678-9abc-def012345678"

      assert Helpers.extract_notion_id("abc12345123456789abcdef012345678") ==
               "abc12345-1234-5678-9abc-def012345678"
    end

    test "extracts IDs from Notion URLs" do
      url = "https://www.notion.so/My-Page-abc1234512345678abcdef0123456789"

      assert Helpers.extract_notion_id(url) ==
               "abc12345-1234-5678-abcd-ef0123456789"
    end

    test "prefers path ids over query parameters" do
      url =
        "https://www.notion.so/workspace/Database-abc1234512345678abcdef0123456789?p=ffffffffffffffffffffffffffffffff"

      assert Helpers.extract_notion_id(url) ==
               "abc12345-1234-5678-abcd-ef0123456789"
    end

    test "returns nil for invalid values" do
      assert Helpers.extract_notion_id("not-a-uuid") == nil
      assert Helpers.extract_notion_id("") == nil
      assert Helpers.extract_notion_id(nil) == nil
    end
  end

  describe "extract_database_id/1 and extract_page_id/1" do
    test "delegate to extract_notion_id/1" do
      page_url = "https://www.notion.so/My-Page-abc1234512345678abcdef0123456789"
      database_url = "https://www.notion.so/My-DB-fedcba9876543210fedcba9876543210"

      assert Helpers.extract_page_id(page_url) ==
               "abc12345-1234-5678-abcd-ef0123456789"

      assert Helpers.extract_database_id(database_url) ==
               "fedcba98-7654-3210-fedc-ba9876543210"
    end
  end

  describe "extract_block_id/1" do
    test "extracts a block ID from a fragment" do
      assert Helpers.extract_block_id(
               "https://notion.so/page#block-abc1234512345678abcdef0123456789"
             ) == "abc12345-1234-5678-abcd-ef0123456789"

      assert Helpers.extract_block_id("https://notion.so/page#abc1234512345678abcdef0123456789") ==
               "abc12345-1234-5678-abcd-ef0123456789"
    end

    test "returns nil when the URL does not contain a block fragment" do
      assert Helpers.extract_block_id("https://notion.so/page") == nil
      assert Helpers.extract_block_id(nil) == nil
    end
  end
end
