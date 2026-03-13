defmodule NotionSDK.PaginationTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Client
  alias NotionSDK.Pagination
  alias NotionSDK.TestTransport
  alias Pristine.Core.Response

  describe "iterate_paginated_api/3 and collect_paginated_api/3" do
    test "advance start_cursor across pages" do
      list_fun = fn _client, params ->
        send(self(), {:list_params, params})

        case Map.get(params, "start_cursor") do
          nil ->
            {:ok, %{"results" => [1, 2], "has_more" => true, "next_cursor" => "cursor-1"}}

          "cursor-1" ->
            {:ok, %{"results" => [3], "has_more" => false, "next_cursor" => nil}}
        end
      end

      assert Pagination.iterate_paginated_api(list_fun, :client, %{}) |> Enum.to_list() == [
               1,
               2,
               3
             ]

      assert_receive {:list_params, %{}}
      assert_receive {:list_params, %{"start_cursor" => "cursor-1"}}

      assert {:ok, [1, 2, 3]} = Pagination.collect_paginated_api(list_fun, :client, %{})
    end
  end

  describe "iterate_data_source_templates/2 and collect_data_source_templates/2" do
    test "iterate and collect templates across pages" do
      client =
        Client.new(
          auth: "secret_test_token",
          transport: TestTransport,
          transport_opts: [
            test_pid: self(),
            response: fn request, _context ->
              body =
                if String.contains?(
                     request.url,
                     "start_cursor=33333333-3333-3333-3333-333333333333"
                   ) do
                  %{
                    "templates" => [
                      %{
                        "id" => "44444444-4444-4444-4444-444444444444",
                        "name" => "Template 3",
                        "is_default" => false
                      }
                    ],
                    "has_more" => false,
                    "next_cursor" => nil
                  }
                else
                  %{
                    "templates" => [
                      %{
                        "id" => "11111111-1111-1111-1111-111111111111",
                        "name" => "Template 1",
                        "is_default" => true
                      },
                      %{
                        "id" => "22222222-2222-2222-2222-222222222222",
                        "name" => "Template 2",
                        "is_default" => false
                      }
                    ],
                    "has_more" => true,
                    "next_cursor" => "33333333-3333-3333-3333-333333333333"
                  }
                end

              {:ok, %Response{status: 200, headers: %{}, body: Jason.encode!(body)}}
            end
          ]
        )

      assert Pagination.iterate_data_source_templates(client, %{
               "data_source_id" => "data-source-123"
             })
             |> Enum.to_list() == [
               %{
                 id: "11111111-1111-1111-1111-111111111111",
                 name: "Template 1",
                 is_default: true
               },
               %{
                 id: "22222222-2222-2222-2222-222222222222",
                 name: "Template 2",
                 is_default: false
               },
               %{
                 id: "44444444-4444-4444-4444-444444444444",
                 name: "Template 3",
                 is_default: false
               }
             ]

      assert_receive {:transport_request, first_request, _context}

      assert first_request.url ==
               "https://api.notion.com/v1/data_sources/data-source-123/templates"

      assert_receive {:transport_request, second_request, _context}
      assert second_request.url =~ "start_cursor=33333333-3333-3333-3333-333333333333"

      assert {:ok,
              [
                %{
                  id: "11111111-1111-1111-1111-111111111111",
                  name: "Template 1",
                  is_default: true
                },
                %{
                  id: "22222222-2222-2222-2222-222222222222",
                  name: "Template 2",
                  is_default: false
                },
                %{
                  id: "44444444-4444-4444-4444-444444444444",
                  name: "Template 3",
                  is_default: false
                }
              ]} =
               Pagination.collect_data_source_templates(client, %{
                 "data_source_id" => "data-source-123"
               })
    end
  end
end
