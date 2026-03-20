defmodule NotionSDK.OAuthTest do
  use ExUnit.Case, async: true

  alias NotionSDK.TestTransport
  alias Pristine.OAuth2.Token
  alias Pristine.Response

  test "builds Notion authorization requests programmatically with owner=user by default" do
    assert {:ok, request} =
             NotionSDK.OAuth.authorization_request(
               client_id: "client-id",
               redirect_uri: "https://example.com/callback",
               state: "state-123"
             )

    assert request.url =~ "https://api.notion.com/v1/oauth/authorize"
    assert request.url =~ "client_id=client-id"
    assert request.url =~ "redirect_uri=https%3A%2F%2Fexample.com%2Fcallback"
    assert request.url =~ "state=state-123"
    assert request.url =~ "owner=user"
  end

  test "fails clearly when redirect_uri is missing from authorization requests" do
    assert {:error, %{reason: :missing_redirect_uri}} =
             NotionSDK.OAuth.authorization_request(client_id: "client-id")

    assert {:error, %{reason: :missing_redirect_uri}} =
             NotionSDK.OAuth.authorize_url(client_id: "client-id", state: "state-123")
  end

  test "exchanges and refreshes Notion OAuth tokens programmatically" do
    response =
      {:ok,
       Response.new(
         status: 200,
         headers: %{"content-type" => "application/json"},
         body:
           Jason.encode!(%{
             "access_token" => "secret_access",
             "refresh_token" => "refresh_access",
             "token_type" => "bearer"
           })
       )}

    assert {:ok, exchange_token} =
             NotionSDK.OAuth.exchange_code("auth-code",
               client_id: "client-id",
               client_secret: "client-secret",
               redirect_uri: "https://example.com/callback",
               transport: TestTransport,
               transport_opts: [test_pid: self(), response: response]
             )

    assert exchange_token.__struct__ == Token.from_map(%{}).__struct__
    assert exchange_token.access_token == "secret_access"

    assert_receive {:transport_request, exchange_request, _context}

    assert exchange_request.headers["authorization"] ==
             "Basic #{Base.encode64("client-id:client-secret")}"

    refute exchange_request.body =~ "client_id"
    refute exchange_request.body =~ "client_secret"

    assert {:ok, refresh_token} =
             NotionSDK.OAuth.refresh_token("refresh_access",
               client_id: "client-id",
               client_secret: "client-secret",
               transport: TestTransport,
               transport_opts: [test_pid: self(), response: response]
             )

    assert refresh_token.__struct__ == Token.from_map(%{}).__struct__
    assert refresh_token.access_token == "secret_access"

    assert_receive {:transport_request, refresh_request, _context}
    assert refresh_request.body =~ "refresh_token"
  end
end
