Code.require_file("../../examples/support/live_example.exs", __DIR__)

defmodule NotionSDK.Examples.LiveTest do
  use ExUnit.Case, async: false

  alias NotionSDK.Examples.Live

  @example_envs [
    "NOTION_EXAMPLE_BLOCK_ID",
    "NOTION_EXAMPLE_DATA_SOURCE_ID",
    "NOTION_EXAMPLE_DATABASE_ID",
    "NOTION_EXAMPLE_FILE_UPLOAD_ID",
    "NOTION_EXAMPLE_FILE_URL",
    "NOTION_EXAMPLE_PAGE_ID",
    "NOTION_EXAMPLE_PROPERTY_ID",
    "NOTION_EXAMPLE_PROPERTY_NAME",
    "NOTION_EXAMPLE_SEARCH_QUERY",
    "NOTION_BLOCK_ID",
    "NOTION_DATA_SOURCE_ID",
    "NOTION_DATABASE_ID",
    "NOTION_FILE_EXTERNAL_URL",
    "NOTION_FILE_UPLOAD_ID",
    "NOTION_PAGE_ID",
    "NOTION_PAGE_PROPERTY_ID",
    "NOTION_PAGE_PROPERTY_NAME",
    "NOTION_SEARCH_QUERY"
  ]

  setup do
    previous =
      Map.new(@example_envs, fn name ->
        {name, System.get_env(name)}
      end)

    Enum.each(@example_envs, &System.delete_env/1)

    on_exit(fn ->
      Enum.each(previous, fn
        {name, nil} -> System.delete_env(name)
        {name, value} -> System.put_env(name, value)
      end)
    end)

    :ok
  end

  test "accepts the new NOTION_EXAMPLE_* fixture names" do
    System.put_env("NOTION_EXAMPLE_PAGE_ID", "b55c9c91-384d-452b-81db-d1ef79372b75")
    System.put_env("NOTION_EXAMPLE_FILE_URL", "https://example.com/path/to/file.pdf")

    assert Live.page_id!() == "b55c9c91-384d-452b-81db-d1ef79372b75"
    assert Live.fetch_env!("NOTION_EXAMPLE_FILE_URL") == "https://example.com/path/to/file.pdf"

    assert Live.fetch_https_env!("NOTION_EXAMPLE_FILE_URL") ==
             "https://example.com/path/to/file.pdf"
  end

  test "keeps legacy example env vars working during the transition" do
    System.put_env("NOTION_PAGE_ID", "b55c9c91-384d-452b-81db-d1ef79372b75")
    System.put_env("NOTION_FILE_EXTERNAL_URL", "https://example.com/path/to/file.pdf")

    assert Live.page_id!() == "b55c9c91-384d-452b-81db-d1ef79372b75"
    assert Live.fetch_env!("NOTION_EXAMPLE_FILE_URL") == "https://example.com/path/to/file.pdf"

    assert Live.fetch_https_env!("NOTION_EXAMPLE_FILE_URL") ==
             "https://example.com/path/to/file.pdf"
  end
end
