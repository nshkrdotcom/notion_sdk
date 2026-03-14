defmodule NotionSDK.GeneratedSourceTest do
  use ExUnit.Case, async: true

  @generated_dir Path.expand("../../lib/notion_sdk/generated", __DIR__)
  @oauth_source Path.join(@generated_dir, "o_auth.ex")
  @pages_source Path.join(@generated_dir, "pages.ex")
  @users_source Path.join(@generated_dir, "users.ex")
  @search_source Path.join(@generated_dir, "search.ex")
  @file_uploads_source Path.join(@generated_dir, "file_uploads.ex")
  @blocks_source Path.join(@generated_dir, "blocks.ex")
  @page_schema_source Path.join(@generated_dir, "schemas/page_object_response.ex")
  @meeting_notes_schema_source Path.join(
                                 @generated_dir,
                                 "schemas/meeting_notes_block_object_response.ex"
                               )
  @transcription_schema_source Path.join(
                                 @generated_dir,
                                 "schemas/transcription_block_response.ex"
                               )
  @todo_schema_source Path.join(@generated_dir, "schemas/to_do_to_do.ex")

  test "generated modules alias the shared Pristine runtime helper" do
    sources =
      @generated_dir
      |> Path.join("**/*.ex")
      |> Path.wildcard()
      |> Enum.map(&File.read!/1)

    assert Enum.any?(
             sources,
             &String.contains?(&1, "alias Pristine.SDK.OpenAPI.Runtime, as: OpenAPIRuntime")
           )

    assert Enum.any?(sources, &String.contains?(&1, "OpenAPIRuntime.build_schema"))
    assert Enum.any?(sources, &String.contains?(&1, "OpenAPIRuntime.decode_module_type"))
    refute Enum.any?(sources, &String.contains?(&1, "NotionSDK.GeneratedRuntime"))
  end

  test "generated oauth helpers call the hardened Pristine SDK oauth boundary" do
    source = File.read!(@oauth_source)

    assert source =~ "alias Pristine.SDK.OAuth2, as: OAuth2"
    assert source =~ "OAuth2.Provider.new("
    refute source =~ "from_manifest("
    refute source =~ "from_manifest!("
    assert source =~ "with {:ok, authorization_opts} <- authorization_opts(opts) do"
    assert source =~ "OAuth2.authorization_request(provider(), authorization_opts)"
    assert source =~ "OAuth2.authorize_url(provider(), authorization_opts)"
    assert source =~ "OAuth2.exchange_code(provider(), code, oauth_runtime_opts(opts))"

    assert source =~ "OAuth2.refresh_token(provider(), refresh_token, oauth_runtime_opts(opts))"

    assert source =~ "Keyword.put_new(params, :owner, \"user\")"
    assert source =~ "OAuth2.Error.new(:missing_redirect_uri, provider: provider().name)"
    assert source =~ "NotionSDK.Client.drop_oauth_credentials(params)"
    assert source =~ "NotionSDK.Client.oauth_request_auth(params)"
    assert source =~ ~s(security: [%{"basicAuth" => []}])
    refute source =~ "GeneratedOAuth"
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
    assert source =~ ~r/@moduledoc\s+"""\n\s+PageObjectResponse/
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

  test "generated operations use the shared pristine operation helper and emit path templates" do
    users_source = File.read!(@users_source)
    pages_source = File.read!(@pages_source)

    assert users_source =~ "use Pristine.SDK.OpenAPI.Operation"
    assert users_source =~ "NotionSDK.Client.execute_generated_request(client, %{"
    assert pages_source =~ "path_template: \"/v1/pages/{page_id}\""
    refute users_source =~ "NotionSDK.Client.request(client, %{"
    refute pages_source =~ "url: "
    refute users_source =~ "NotionSDK.GeneratedOperation"
    refute pages_source =~ "NotionSDK.GeneratedOperation"
  end

  test "current generated surface includes position variants and meeting notes" do
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

    assert Keyword.fetch!(NotionSDK.PageObjectResponse.__fields__(:t), :in_trash) == :boolean

    assert Keyword.fetch!(
             NotionSDK.MeetingNotesBlockObjectResponse.__fields__(:t),
             :meeting_notes
           ) ==
             {NotionSDK.TranscriptionBlockResponse, :t}
  end

  test "generated schema files include the real meeting notes and transcription modules" do
    meeting_notes_source = File.read!(@meeting_notes_schema_source)
    transcription_source = File.read!(@transcription_schema_source)
    blocks_source = File.read!(@blocks_source)

    assert meeting_notes_source =~ "defmodule NotionSDK.MeetingNotesBlockObjectResponse do"
    assert transcription_source =~ "defmodule NotionSDK.TranscriptionBlockResponse do"
    assert blocks_source =~ "NotionSDK.MeetingNotesBlockObjectResponse.t()"
    refute blocks_source =~ "url: "
  end

  test "generated security docs and metadata deduplicate bearer auth requirements" do
    pages_source = File.read!(@pages_source)

    assert pages_source =~ "## Security"
    assert pages_source =~ "* `bearerAuth`"
    refute pages_source =~ "* `bearerAuth`\n    * `bearerAuth`"

    refute pages_source =~
             ~s(%{"bearerAuth" => []},\n        %{"bearerAuth" => []})
  end

  test "generated source avoids credo-triggering blank lines and todo labels" do
    sources =
      @generated_dir
      |> Path.join("**/*.ex")
      |> Path.wildcard()
      |> Enum.map(&File.read!/1)

    refute Enum.any?(sources, &String.contains?(&1, "\n\n\n"))

    source = File.read!(@todo_schema_source)

    assert source =~ ~r/@moduledoc\s+"""\n\s+To Do To Do/
    refute source =~ "@moduledoc \"\"\"\n  ToDoToDo"
  end
end
