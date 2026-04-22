defmodule NotionSDK.LowerSimulationTest do
  use ExUnit.Case, async: false

  alias NotionSDK.Client
  alias Pristine.Adapters.Transport.LowerSimulation

  @config_key :transport_simulation_profiles

  setup do
    previous_notion_transport = Application.get_env(:notion_sdk, :transport)
    previous_notion_base_url = Application.get_env(:notion_sdk, :base_url)
    previous_pristine_config = Application.get_env(:pristine, @config_key)

    on_exit(fn ->
      restore_env(:notion_sdk, :transport, previous_notion_transport)
      restore_env(:notion_sdk, :base_url, previous_notion_base_url)
      restore_env(:pristine, @config_key, previous_pristine_config)
    end)

    Application.put_env(:notion_sdk, :transport, LowerSimulation)
    Application.put_env(:notion_sdk, :base_url, "http://127.0.0.1:1")

    :ok
  end

  test "raw requests consume Pristine lower simulation through configured transport" do
    Application.put_env(:pristine, @config_key,
      required?: true,
      profiles: %{
        "notion.users.me" => [
          scenario_ref: "phase5prelim://notion/users-me",
          body: ~s({"object":"user","id":"user-1","type":"person","person":{}}),
          headers: %{"content-type" => "application/json", "x-request-id" => "notion-sim-1"}
        ]
      }
    )

    client = Client.new(auth: "secret_test_token", retry: false)

    assert client.transport == LowerSimulation

    assert {:ok, %{"id" => "user-1", "object" => "user"}} =
             Client.request(client, %{
               id: "notion.users.me",
               method: :get,
               path: "/v1/users/me",
               response_schema: nil
             })
  end

  test "missing lower simulation profile fails before provider HTTP egress" do
    Application.put_env(:pristine, @config_key, required?: true, profiles: %{})

    client = Client.new(auth: "secret_test_token", retry: false)

    assert {:error, %NotionSDK.Error{code: :api_connection, body: %{reason: reason}}} =
             Client.request(client, %{
               id: "notion.users.me",
               method: :get,
               path: "/v1/users/me",
               response_schema: nil
             })

    assert reason =~ "pristine_simulation_profile_required"
  end

  defp restore_env(app, key, nil), do: Application.delete_env(app, key)
  defp restore_env(app, key, value), do: Application.put_env(app, key, value)
end
