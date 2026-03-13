Code.require_file("../../examples/support/live_example.exs", __DIR__)

defmodule NotionSDK.Examples.LiveTest do
  use ExUnit.Case, async: false

  @moduletag :tmp_dir

  alias NotionSDK.Examples.Live

  @example_envs [
    "NOTION_EXAMPLE_BLOCK_ID",
    "NOTION_EXAMPLE_DATA_SOURCE_ID",
    "NOTION_EXAMPLE_DATABASE_ID",
    "NOTION_EXAMPLE_FILE_UPLOAD_ID",
    "NOTION_EXAMPLE_FILE_URL",
    "NOTION_EXAMPLE_FILE_FILENAME",
    "NOTION_EXAMPLE_FILE_CONTENT_TYPE",
    "NOTION_EXAMPLE_PAGE_ID",
    "NOTION_EXAMPLE_PROPERTY_ID",
    "NOTION_EXAMPLE_PROPERTY_NAME",
    "NOTION_EXAMPLE_SEARCH_QUERY",
    "NOTION_OAUTH_AUTH_CODE",
    "NOTION_OAUTH_EXCHANGE_TOKEN_PATH",
    "NOTION_OAUTH_REVOKE_TOKEN",
    "NOTION_OAUTH_TOKEN_PATH",
    "XDG_CONFIG_HOME"
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

  test "oauth token path falls back to the default saved location", %{tmp_dir: tmp_dir} do
    System.put_env("XDG_CONFIG_HOME", tmp_dir)

    assert Live.oauth_token_path() ==
             Path.join([tmp_dir, "notion_sdk", "oauth", "notion.json"])
  end

  test "oauth exchange token path defaults to a temp file and honors env override" do
    assert Live.oauth_exchange_token_path() ==
             Path.join(System.tmp_dir!(), "notion_sdk_example_oauth_exchange.json")

    System.put_env("NOTION_OAUTH_EXCHANGE_TOKEN_PATH", "/tmp/custom-notion-oauth.json")

    assert Live.oauth_exchange_token_path() == "/tmp/custom-notion-oauth.json"
  end

  test "oauth auth code helper prefers the explicit env var" do
    System.put_env("NOTION_OAUTH_AUTH_CODE", "example-auth-code")

    assert Live.oauth_auth_code_or_prompt!() == "example-auth-code"
  end

  test "ok! raises with structured Pristine error details" do
    error = %Pristine.Error{
      type: :not_found,
      status: 404,
      message: "Resource not found",
      body: %{
        "code" => "object_not_found",
        "message" => "Could not find page with ID: 32222fc0-502f-808e-b33f-cdd53e4d9a60.",
        "request_id" => "req_123"
      },
      response: %Pristine.Core.Response{
        status: 404,
        headers: %{},
        body: %{},
        metadata: %{url: "https://api.notion.com/v1/pages/32222fc0-502f-808e-b33f-cdd53e4d9a60"}
      }
    }

    exception =
      assert_raise RuntimeError, fn ->
        Live.ok!({:error, error}, "NotionSDK.Pages.retrieve/2")
      end

    message = Exception.message(exception)

    assert message =~ "NotionSDK.Pages.retrieve/2 failed"
    assert message =~ "status: 404"
    assert message =~ "code: object_not_found"
    assert message =~ "detail: Could not find page with ID: 32222fc0-502f-808e-b33f-cdd53e4d9a60."
    assert message =~ "request_id: req_123"

    assert message =~
             "request_url: https://api.notion.com/v1/pages/32222fc0-502f-808e-b33f-cdd53e4d9a60"
  end
end
