defmodule NotionSDK.ParityEndpointTest do
  use ExUnit.Case, async: true

  @manifest_path Path.expand("../../priv/generated/manifest.json", __DIR__)
  @js_sdk_package_path Path.expand("../../notion-sdk-js/package.json", __DIR__)

  @expected_operations [
    {"Blocks", "append_children", "patch", "/v1/blocks/{block_id}/children"},
    {"Blocks", "delete", "delete", "/v1/blocks/{block_id}"},
    {"Blocks", "list_children", "get", "/v1/blocks/{block_id}/children"},
    {"Blocks", "retrieve", "get", "/v1/blocks/{block_id}"},
    {"Blocks", "update", "patch", "/v1/blocks/{block_id}"},
    {"Comments", "create", "post", "/v1/comments"},
    {"Comments", "list", "get", "/v1/comments"},
    {"Comments", "retrieve", "get", "/v1/comments/{comment_id}"},
    {"DataSources", "create", "post", "/v1/data_sources"},
    {"DataSources", "list_templates", "get", "/v1/data_sources/{data_source_id}/templates"},
    {"DataSources", "query", "post", "/v1/data_sources/{data_source_id}/query"},
    {"DataSources", "retrieve", "get", "/v1/data_sources/{data_source_id}"},
    {"DataSources", "update", "patch", "/v1/data_sources/{data_source_id}"},
    {"Databases", "create", "post", "/v1/databases"},
    {"Databases", "retrieve", "get", "/v1/databases/{database_id}"},
    {"Databases", "update", "patch", "/v1/databases/{database_id}"},
    {"FileUploads", "complete", "post", "/v1/file_uploads/{file_upload_id}/complete"},
    {"FileUploads", "create", "post", "/v1/file_uploads"},
    {"FileUploads", "list", "get", "/v1/file_uploads"},
    {"FileUploads", "retrieve", "get", "/v1/file_uploads/{file_upload_id}"},
    {"FileUploads", "send", "post", "/v1/file_uploads/{file_upload_id}/send"},
    {"OAuth", "introspect", "post", "/v1/oauth/introspect"},
    {"OAuth", "revoke", "post", "/v1/oauth/revoke"},
    {"OAuth", "token", "post", "/v1/oauth/token"},
    {"Pages", "create", "post", "/v1/pages"},
    {"Pages", "move", "post", "/v1/pages/{page_id}/move"},
    {"Pages", "retrieve", "get", "/v1/pages/{page_id}"},
    {"Pages", "retrieve_markdown", "get", "/v1/pages/{page_id}/markdown"},
    {"Pages", "retrieve_property", "get", "/v1/pages/{page_id}/properties/{property_id}"},
    {"Pages", "update", "patch", "/v1/pages/{page_id}"},
    {"Pages", "update_markdown", "patch", "/v1/pages/{page_id}/markdown"},
    {"Search", "search", "post", "/v1/search"},
    {"Users", "get_self", "get", "/v1/users/me"},
    {"Users", "list", "get", "/v1/users"},
    {"Users", "retrieve", "get", "/v1/users/{user_id}"}
  ]

  test "matches the documented JS SDK endpoint surface" do
    manifest = Jason.decode!(File.read!(@manifest_path))

    actual_operations =
      manifest["operations"]
      |> Enum.map(fn operation ->
        {operation["module"], operation["function"], operation["method"], operation["path"]}
      end)
      |> Enum.sort()

    assert manifest["operation_count"] == 35
    assert actual_operations == Enum.sort(@expected_operations)

    namespace_modules =
      @expected_operations
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

    assert {"Search", "search", "post", "/v1/search"} in actual_operations
  end

  test "pins the vendored JS SDK version used as the parity oracle" do
    package = Jason.decode!(File.read!(@js_sdk_package_path))

    assert package["name"] == "@notionhq/client"
    assert package["version"] == "5.12.0"
    assert NotionSDK.Client.default_notion_version() == "2025-09-03"
  end
end
