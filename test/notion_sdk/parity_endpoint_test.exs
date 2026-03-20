defmodule NotionSDK.ParityEndpointTest do
  use ExUnit.Case, async: true

  @provider_ir_path Path.expand("../../priv/generated/provider_ir.json", __DIR__)
  @inventory_path Path.expand("../../priv/upstream/parity_inventory.json", __DIR__)
  @js_sdk_package_path Path.expand("../../notion-sdk-js/package.json", __DIR__)

  test "matches the committed bounded parity inventory" do
    provider_ir = Jason.decode!(File.read!(@provider_ir_path))
    inventory = NotionSDK.ParityInventory.load!()
    expected_operations = NotionSDK.ParityInventory.expected_operations()

    actual_operations =
      provider_ir["operations"]
      |> Enum.map(fn operation ->
        module =
          operation["module"]
          |> String.trim_leading("NotionSDK.")

        {module, operation["function"], operation["method"], operation["path_template"]}
      end)
      |> Enum.sort()

    assert File.exists?(@inventory_path)
    assert length(provider_ir["operations"]) == length(expected_operations)
    assert actual_operations == Enum.sort(expected_operations)

    namespace_modules =
      expected_operations
      |> Enum.map(&elem(&1, 0))
      |> Enum.reject(&(&1 == "Search"))
      |> Enum.uniq()
      |> Enum.sort()

    assert namespace_modules == [
             "Blocks",
             "Comments",
             "DataSources",
             "Databases",
             "FileUploads",
             "OAuth",
             "Pages",
             "Users"
           ]

    assert inventory["operation_count"] == length(expected_operations)
    assert {"Search", "search", "post", "/v1/search"} in actual_operations
  end

  test "pins the vendored JS SDK version used as the parity oracle" do
    package = Jason.decode!(File.read!(@js_sdk_package_path))
    inventory = NotionSDK.ParityInventory.load!()

    assert package["name"] == inventory["js_sdk"]["package"]
    assert package["version"] == inventory["js_sdk"]["version"]
    assert NotionSDK.Client.default_notion_version() == "2025-09-03"
  end
end
