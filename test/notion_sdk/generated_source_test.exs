defmodule NotionSDK.GeneratedSourceTest do
  use ExUnit.Case, async: true

  @generated_dir Path.expand("../../lib/notion_sdk/generated", __DIR__)
  @runtime_schema_source Path.join(@generated_dir, "runtime_schema.ex")
  @oauth_source Path.join(@generated_dir, "o_auth.ex")
  @oauth_helper_source Path.expand("../../lib/notion_sdk/oauth.ex", __DIR__)
  @pages_source Path.join(@generated_dir, "pages.ex")
  @users_source Path.join(@generated_dir, "users.ex")
  @search_source Path.join(@generated_dir, "search.ex")
  @file_uploads_source Path.join(@generated_dir, "file_uploads.ex")
  @blocks_source Path.join(@generated_dir, "blocks.ex")
  @page_schema_source Path.join(@generated_dir, "schemas/page_object_response.ex")
  @annotation_response_source Path.join(@generated_dir, "schemas/annotation_response.ex")
  @root_schema_source Path.join(@generated_dir, "schemas/notion_sdk.ex")
  @meeting_notes_schema_source Path.join(
                                 @generated_dir,
                                 "schemas/meeting_notes_block_object_response.ex"
                               )
  @transcription_schema_source Path.join(
                                 @generated_dir,
                                 "schemas/transcription_block_response.ex"
                               )
  @todo_schema_source Path.join(@generated_dir, "schemas/to_do_to_do.ex")

  test "generated modules use provider-local runtime schema helpers" do
    sources =
      @generated_dir
      |> Path.join("**/*.ex")
      |> Path.wildcard()
      |> Enum.map(&File.read!/1)

    runtime_schema_source = File.read!(@runtime_schema_source)

    assert runtime_schema_source =~ "defmodule NotionSDK.Generated.RuntimeSchema do"

    assert Enum.any?(
             sources,
             &String.contains?(&1, "alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema")
           )

    assert Enum.any?(
             sources,
             &String.contains?(&1, "RuntimeSchema.build_schema")
           )

    assert Enum.any?(
             sources,
             &String.contains?(&1, "RuntimeSchema.decode_module_type")
           )

    refute Enum.any?(sources, &String.contains?(&1, "Pristine.Runtime.Schema"))
    refute Enum.any?(sources, &String.contains?(&1, "NotionSDK.GeneratedRuntime"))
  end

  test "generated oauth helpers call the shared pristine oauth boundary" do
    source = File.read!(@oauth_source)
    helper_source = File.read!(@oauth_helper_source)

    assert source =~ "use NotionSDK.OAuth.Helpers"
    refute source =~ "from_manifest("
    refute source =~ "from_manifest!("
    assert source =~ ~s(security_schemes: ["basicAuth"])
    refute source =~ "GeneratedOAuth"
    assert helper_source =~ "alias Pristine.OAuth2"
    assert helper_source =~ "OAuth2.Provider.new("
    assert helper_source =~ "OAuth2.authorization_request(provider(), authorization_opts)"
    assert helper_source =~ "OAuth2.authorize_url(provider(), authorization_opts)"
    assert helper_source =~ "OAuth2.exchange_code(provider(), code, oauth_runtime_opts(opts))"

    assert helper_source =~
             "OAuth2.refresh_token(provider(), refresh_token, oauth_runtime_opts(opts))"

    assert helper_source =~ "Keyword.put_new(params, :owner, \"user\")"
    assert helper_source =~ "OAuth2.Error.new(:missing_redirect_uri, provider: provider().name)"
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

    assert source =~ "@moduledoc"
    assert source =~ "description:"
    assert source =~ "deprecated:"
    assert source =~ "example:"
    assert source =~ "examples:"
    assert source =~ "external_docs:"
    assert source =~ "extensions:"
    assert source =~ "read_only:"
    assert source =~ "write_only:"
  end

  test "generated schema typespecs do not emit invalid string literal unions" do
    source = File.read!(@annotation_response_source)

    assert source =~ "color: String.t()"
    refute source =~ ~s(color:\n            "default")
  end

  test "generated schema typespecs avoid built-in type name collisions" do
    source = File.read!(@root_schema_source)

    refute source =~ "@type map ::"
    assert source =~ "@type t :: map()"
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

  test "generated operations use request maps and execute through the client boundary" do
    users_source = File.read!(@users_source)
    pages_source = File.read!(@pages_source)
    search_source = File.read!(@search_source)

    assert users_source =~ "opts = normalize_request_opts!(opts)"
    assert users_source =~ "defp normalize_request_opts!(opts) when is_list(opts) do"
    assert users_source =~ "request = build_get_self_request(client, params, opts)"
    assert users_source =~ "NotionSDK.Client.execute_generated_request(client, request)"
    assert users_source =~ "alias Pristine.SDK.OpenAPI.Client, as: OpenAPIClient"
    assert pages_source =~ "path_template: \"/v1/pages/{page_id}\""
    assert search_source =~ "OpenAPIClient.next_page_request(request, response)"
    refute users_source =~ "Pristine.Operation.new("
    refute users_source =~ "NotionSDK.Client.pristine_client(client)"
    refute users_source =~ "Pristine.execute(runtime_client, operation, execute_opts)"
    refute pages_source =~ "url: "
    refute users_source =~ "NotionSDK.GeneratedOperation"
    refute pages_source =~ "NotionSDK.GeneratedOperation"
  end

  test "current generated surface includes position variants and meeting notes" do
    assert match?(
             {:const, position} when position in ["after_block", "before_block", "end", "start"],
             Keyword.fetch!(
               NotionSDK.Blocks.__fields__(:append_children_json_req_position),
               :type
             )
           )

    assert match?(
             {:const, position}
             when position in ["after_block", "before_block", "end", "page_start", "start"],
             Keyword.fetch!(NotionSDK.Pages.__fields__(:create_json_req_position), :type)
           )

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
    assert blocks_source =~ "{NotionSDK.MeetingNotesBlockObjectResponse, :t}"
    refute blocks_source =~ "url: "
  end

  test "generated auth metadata carries a single bearerAuth scheme" do
    pages_source = File.read!(@pages_source)

    assert pages_source =~ ~s(security_schemes: ["bearerAuth"])
    refute pages_source =~ ~s(security_schemes: ["bearerAuth", "bearerAuth"])
  end

  test "generated source avoids credo-triggering blank lines and todo labels" do
    sources =
      @generated_dir
      |> Path.join("**/*.ex")
      |> Path.wildcard()
      |> Enum.map(&File.read!/1)

    refute Enum.any?(sources, &String.contains?(&1, "\n\n\n"))
    refute Enum.any?(sources, &String.contains?(&1, "\n         ..."))
    refute Enum.any?(sources, &String.contains?(&1, "\" <>\n         ..."))

    source = File.read!(@todo_schema_source)

    assert source =~ "defmodule NotionSDK.ToDoToDo do"
  end
end
