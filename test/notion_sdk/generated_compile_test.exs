defmodule NotionSDK.GeneratedCompileTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Codegen.PublicModule

  @generation_manifest_path Path.expand("../../priv/generated/generation_manifest.json", __DIR__)
  @docs_inventory_path Path.expand("../../priv/generated/docs_inventory.json", __DIR__)
  @provider_ir_path Path.expand("../../priv/generated/provider_ir.json", __DIR__)
  @operation_functions %{
    "append_children" => :append_children,
    "complete" => :complete,
    "create" => :create,
    "delete" => :delete,
    "get_self" => :get_self,
    "introspect" => :introspect,
    "list" => :list,
    "list_children" => :list_children,
    "list_templates" => :list_templates,
    "move" => :move,
    "query" => :query,
    "retrieve" => :retrieve,
    "retrieve_markdown" => :retrieve_markdown,
    "retrieve_property" => :retrieve_property,
    "revoke" => :revoke,
    "search" => :search,
    "send" => :send,
    "token" => :token,
    "update" => :update,
    "update_markdown" => :update_markdown
  }

  test "all generated operations are present and compiled" do
    provider_ir = Jason.decode!(File.read!(@provider_ir_path))
    generation_manifest = Jason.decode!(File.read!(@generation_manifest_path))

    operations = provider_ir["operations"] || []

    assert generation_manifest["operation_count"] == 35
    assert length(operations) == 35

    Enum.each(operations, fn %{"function" => function_name, "module" => module_name} ->
      module = PublicModule.from_provider_ir!(module_name)

      function = Map.fetch!(@operation_functions, function_name)

      assert Code.ensure_loaded?(module)
      assert function_exported?(module, function, 1)
      assert function_exported?(module, function, 2)
    end)
  end

  test "generated module lookup rejects unknown provider IR names without atom creation" do
    assert_raise ArgumentError, fn ->
      PublicModule.from_provider_ir!("OtherSDK.Pages")
    end

    assert_raise ArgumentError, fn ->
      PublicModule.from_provider_ir!("NotionSDK.DoesNotExistForAtomGate")
    end
  end

  test "markdown, file upload lifecycle, and oauth functions are exported" do
    assert Code.ensure_loaded?(NotionSDK.Pages)
    assert function_exported?(NotionSDK.Pages, :retrieve_markdown, 2)
    assert function_exported?(NotionSDK.Pages, :update_markdown, 2)

    assert Code.ensure_loaded?(NotionSDK.FileUploads)
    assert function_exported?(NotionSDK.FileUploads, :create, 2)
    assert function_exported?(NotionSDK.FileUploads, :list, 2)
    assert function_exported?(NotionSDK.FileUploads, :send, 2)
    assert function_exported?(NotionSDK.FileUploads, :complete, 2)
    assert function_exported?(NotionSDK.FileUploads, :retrieve, 2)

    assert Code.ensure_loaded?(NotionSDK.OAuth)
    assert function_exported?(NotionSDK.OAuth, :token, 2)
    assert function_exported?(NotionSDK.OAuth, :revoke, 2)
    assert function_exported?(NotionSDK.OAuth, :introspect, 2)
    assert function_exported?(NotionSDK.OAuth, :provider, 0)
    assert function_exported?(NotionSDK.OAuth, :authorization_request, 1)
    assert function_exported?(NotionSDK.OAuth, :authorize_url, 1)
    assert function_exported?(NotionSDK.OAuth, :exchange_code, 2)
    assert function_exported?(NotionSDK.OAuth, :refresh_token, 2)
  end

  test "oauth owner schema modules are emitted and compiled" do
    generation_manifest =
      @generation_manifest_path
      |> File.read!()
      |> Jason.decode!()
      |> update_in(["generated_files"], fn generated_files ->
        Enum.reject(generated_files || [], fn path -> is_nil(path) end)
      end)

    assert Enum.any?(generation_manifest["generated_files"], &String.ends_with?(&1, "/user.ex"))

    assert Enum.any?(
             generation_manifest["generated_files"],
             &String.ends_with?(&1, "/workspace.ex")
           )

    assert Code.ensure_loaded?(NotionSDK.User)
    assert Code.ensure_loaded?(NotionSDK.Workspace)
    assert function_exported?(NotionSDK.User, :__schema__, 1)
    assert function_exported?(NotionSDK.Workspace, :__schema__, 1)
    assert {:ok, user_types} = Code.Typespec.fetch_types(NotionSDK.User)
    assert {:ok, workspace_types} = Code.Typespec.fetch_types(NotionSDK.Workspace)
    assert Enum.any?(user_types, &match?({:type, {:t, _, _}}, &1))
    assert Enum.any?(workspace_types, &match?({:type, {:t, _, _}}, &1))
  end

  test "docs inventory and runtime metadata helpers are materially richer" do
    docs_inventory_source = File.read!(@docs_inventory_path)
    docs_inventory = Jason.decode!(File.read!(@docs_inventory_path))

    retrieve_entry = get_in(docs_inventory, ["operations", "pages/retrieve"])

    assert retrieve_entry["doc"] =~ "## Source Context"
    assert retrieve_entry["doc"] =~ "### Limits"
    assert retrieve_entry["doc"] =~ "## Code Samples"
    assert retrieve_entry["source_context"]["slug"] == "retrieve-a-page"
    refute docs_inventory_source =~ "#Reference<"

    [field | _rest] = NotionSDK.PageObjectResponse.__openapi_fields__()

    assert Map.has_key?(field, :description)
    assert Map.has_key?(field, :deprecated)
    assert Map.has_key?(field, :example)
    assert Map.has_key?(field, :examples)
    assert Map.has_key?(field, :external_docs)
    assert Map.has_key?(field, :extensions)
    assert Map.has_key?(field, :read_only)
    assert Map.has_key?(field, :write_only)
  end
end
