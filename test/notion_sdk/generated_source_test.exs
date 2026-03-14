defmodule NotionSDK.GeneratedSourceTest do
  use ExUnit.Case, async: true

  @generated_dir Path.expand("../../lib/notion_sdk/generated", __DIR__)
  @oauth_source Path.join(@generated_dir, "o_auth.ex")
  @pages_source Path.join(@generated_dir, "pages.ex")
  @users_source Path.join(@generated_dir, "users.ex")
  @search_source Path.join(@generated_dir, "search.ex")
  @file_uploads_source Path.join(@generated_dir, "file_uploads.ex")
  @page_schema_source Path.join(@generated_dir, "schemas/page_object_response.ex")
  @todo_schema_source Path.join(@generated_dir, "schemas/to_do_to_do.ex")

  test "generated modules alias the NotionSDK runtime helper instead of calling it fully qualified" do
    sources =
      @generated_dir
      |> Path.join("**/*.ex")
      |> Path.wildcard()
      |> Enum.map(&File.read!/1)

    assert Enum.any?(
             sources,
             &String.contains?(&1, "alias NotionSDK.GeneratedRuntime, as: OpenAPIRuntime")
           )

    assert Enum.any?(sources, &String.contains?(&1, "OpenAPIRuntime.build_schema"))
    assert Enum.any?(sources, &String.contains?(&1, "OpenAPIRuntime.decode_module_type"))
    refute Enum.any?(sources, &String.contains?(&1, "NotionSDK.GeneratedRuntime.build_schema"))
    refute Enum.any?(sources, &String.contains?(&1, "Pristine.OpenAPI.Runtime.build_schema"))

    refute Enum.any?(
             sources,
             &String.contains?(&1, "Pristine.OpenAPI.Runtime.decode_module_type")
           )
  end

  test "generated oauth helpers preserve Pristine.OAuth2 types while routing behavior through GeneratedOAuth" do
    source = File.read!(@oauth_source)

    assert source =~ "alias Pristine.OAuth2, as: OAuth2"
    assert source =~ "alias NotionSDK.GeneratedOAuth, as: OAuthRuntime"
    assert source =~ "OAuthRuntime.provider_new("
    assert source =~ "with {:ok, authorization_opts} <- authorization_opts(opts) do"
    assert source =~ "OAuthRuntime.authorization_request(authorization_opts)"
    assert source =~ "OAuthRuntime.authorize_url(authorization_opts)"
    assert source =~ "OAuthRuntime.exchange_code(code, oauth_runtime_opts(opts))"
    assert source =~ "OAuthRuntime.refresh_token(refresh_token, oauth_runtime_opts(opts))"
    assert source =~ "Keyword.put_new(params, :owner, \"user\")"
    assert source =~ "OAuthRuntime.error_new(:missing_redirect_uri, provider: provider().name)"
    refute source =~ "OAuth2.Provider.new("
    refute source =~ "Pristine.OAuth2.authorization_request("
    refute source =~ "OAuth2.authorization_request(authorization_opts)"
  end

  test "generated operation docs include persisted source context and code samples" do
    source = File.read!(@pages_source)

    assert source =~ "## Source Context"
    assert source =~ "### Warnings"
    assert source =~ "### Limits"
    assert source =~ "### Errors"
    assert source =~ "## Code Samples"
    assert source =~ "const response = await notion.pages.retrieve({"
    assert source =~ "https://developers.notion.com/reference/retrieve-a-page"
  end

  test "generated schema runtime metadata exposes richer doc fields" do
    source = File.read!(@page_schema_source)

    refute source =~ "Provides struct and types for PageObjectResponse"
    assert source =~ "@moduledoc \"\"\"\n  PageObjectResponse"
    assert source =~ "description:"
    assert source =~ "deprecated:"
    assert source =~ "example:"
    assert source =~ "examples:"
    assert source =~ "external_docs:"
    assert source =~ "extensions:"
    assert source =~ "read_only:"
    assert source =~ "write_only:"
  end

  test "generated request maps include stable runtime metadata" do
    users_source = File.read!(@users_source)
    search_source = File.read!(@search_source)
    file_uploads_source = File.read!(@file_uploads_source)
    oauth_source = File.read!(@oauth_source)

    assert users_source =~ ~s(resource: "core_api")
    assert users_source =~ ~s(retry: "notion.read")
    assert users_source =~ ~s(circuit_breaker: "core_api")
    assert users_source =~ ~s(rate_limit: "notion.integration")

    assert search_source =~ ~s(resource: "core_api")
    assert search_source =~ ~s(retry: "notion.write")

    assert file_uploads_source =~ ~s(resource: "file_upload_send")
    assert file_uploads_source =~ ~s(retry: "notion.file_upload_send")
    assert file_uploads_source =~ ~s(circuit_breaker: "file_upload_send")

    assert oauth_source =~ ~s(resource: "oauth_control")
    assert oauth_source =~ ~s(retry: "notion.oauth_control")
    assert oauth_source =~ ~s(circuit_breaker: "oauth_control")
  end

  test "generated source avoids credo-triggering blank lines and todo labels" do
    sources =
      @generated_dir
      |> Path.join("**/*.ex")
      |> Path.wildcard()
      |> Enum.map(&File.read!/1)

    refute Enum.any?(sources, &String.contains?(&1, "\n\n\n"))

    source = File.read!(@todo_schema_source)

    assert source =~ "@moduledoc \"\"\"\n  To Do To Do"
    refute source =~ "@moduledoc \"\"\"\n  ToDoToDo"
  end
end
