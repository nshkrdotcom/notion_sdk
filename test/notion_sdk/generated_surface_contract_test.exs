defmodule NotionSDK.GeneratedSurfaceContractTest do
  use ExUnit.Case, async: true

  @generated_dir Path.expand("../../lib/notion_sdk/generated", __DIR__)
  @pages_source Path.join(@generated_dir, "pages.ex")
  @search_source Path.join(@generated_dir, "search.ex")
  @runtime_schema_source Path.join(@generated_dir, "runtime_schema.ex")
  @page_schema_source Path.join(@generated_dir, "schemas/page_object_response.ex")

  test "generated operation modules build Pristine.Operation values and execute directly" do
    pages_source = File.read!(@pages_source)
    search_source = File.read!(@search_source)

    assert pages_source =~ "Pristine.Operation.new("
    assert pages_source =~ "Pristine.execute("
    assert search_source =~ "def stream_search("
    assert search_source =~ "case Pristine.execute("
    assert pages_source =~ "NotionSDK.Client.pristine_client(client)"

    refute pages_source =~ "Pristine.SDK.OpenAPI"
    refute pages_source =~ "Pristine.execute_request("
    refute pages_source =~ "OpenAPIRuntime"
    refute pages_source =~ "GeneratedSupport"
  end

  test "generated schema modules expose runtime schema helpers without OpenAPI helpers" do
    source = File.read!(@page_schema_source)
    runtime_schema_source = File.read!(@runtime_schema_source)

    assert source =~ "def __openapi_fields__("
    assert source =~ "def __schema__("
    assert source =~ "def decode("
    assert source =~ "alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema"
    assert source =~ "RuntimeSchema.build_schema"
    assert source =~ "RuntimeSchema.decode_module_type"
    assert runtime_schema_source =~ "defmodule NotionSDK.Generated.RuntimeSchema do"

    refute source =~ "Pristine.SDK.OpenAPI"
    refute source =~ "OpenAPIRuntime"
    refute source =~ "Pristine.Runtime.Schema"
  end
end
