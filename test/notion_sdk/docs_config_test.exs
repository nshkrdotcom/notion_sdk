defmodule NotionSDK.DocsConfigTest do
  use ExUnit.Case, async: true

  test "docs config does not nest modules by the NotionSDK prefix" do
    docs = Mix.Project.config()[:docs] || []

    assert Keyword.get(docs, :nest_modules_by_prefix) in [nil, []]
  end
end
