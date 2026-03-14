defmodule NotionSDK.Codegen.PageContextTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Codegen
  alias NotionSDK.Codegen.Source.Extractor

  @fixture_page Path.expand("../../fixtures/reference/manage-widgets.md", __DIR__)
  @committed_reference_spec Path.expand("../../../priv/upstream/reference/get-self.yaml", __DIR__)
  @committed_reference_context Path.expand(
                                 "../../../priv/upstream/reference_context/get-self.json",
                                 __DIR__
                               )

  test "extracts structured page context from a fixture page" do
    %{yaml: yaml, page_context: page_context} = Extractor.extract_file!(@fixture_page)

    assert yaml =~ "operationId: manage-widgets"

    assert page_context.slug == "manage-widgets"
    assert page_context.title == "Manage widgets"
    assert page_context.method == "post"
    assert page_context.path == "/v1/widgets"
    assert page_context.operation_id == "manage-widgets"

    assert page_context.lead ==
             "Use this API to manage [widgets](https://developers.notion.com/reference/widget)."

    assert page_context.source_url == "https://developers.notion.com/reference/manage-widgets"

    assert [
             %{
               "body" => "Widget writes may lag behind reads.",
               "items" => ["Retry after a short delay."],
               "kind" => "warning",
               "title" => "Widget consistency"
             }
           ] = Enum.map(page_context.warnings, &stringify_keys/1)

    assert [
             %{
               "body" =>
                 "For workspace setup, open the [Integrations dashboard](https://www.notion.so/profile/integrations).",
               "kind" => "info"
             }
           ] = Enum.map(page_context.info_notes, &stringify_keys/1)

    assert [%{"heading" => "Limits"} = limits] = Enum.map(page_context.limits, &stringify_keys/1)
    assert limits["items"] == ["Maximum of 10 ids", "Maximum name length of 50 characters"]

    assert [%{"heading" => "Errors", "body" => "Returns a 409 on conflicts."}] =
             Enum.map(page_context.errors, &stringify_keys/1)

    assert Enum.any?(page_context.sections, &(&1.heading == "Behavior"))

    assert Enum.any?(
             Enum.map(page_context.code_samples, &stringify_keys/1),
             &(&1["label"] == "TypeScript SDK")
           )

    assert Enum.any?(
             Enum.map(page_context.resources, &stringify_keys/1),
             &(&1["url"] == "https://developers.notion.com/reference/widget-entry")
           )

    assert page_context.description =~ "### Warnings"
    assert page_context.description =~ "### Resources"
  end

  test "extract_upstream! persists yaml and reference_context artifacts that load back into source_contexts" do
    project_root = make_tmp_dir!("page_context")
    reference_root = Path.join(project_root, "reference")
    fixture_path = Path.join(reference_root, "manage-widgets.md")

    File.mkdir_p!(reference_root)
    File.cp!(@fixture_page, fixture_path)

    Codegen.extract_upstream!(
      project_root: project_root,
      reference_root: reference_root,
      reference_pages: ["manage-widgets.md"]
    )

    yaml_path = Path.join(project_root, "priv/upstream/reference/manage-widgets.yaml")
    context_path = Path.join(project_root, "priv/upstream/reference_context/manage-widgets.json")

    assert File.exists?(yaml_path)
    assert File.exists?(context_path)

    artifact = context_path |> File.read!() |> Jason.decode!()

    source_contexts =
      Codegen.source_contexts(
        project_root: project_root,
        reference_root: reference_root,
        reference_pages: ["manage-widgets.md"]
      )

    assert artifact["slug"] == "manage-widgets"
    assert artifact["operation_id"] == "manage-widgets"
    assert artifact["resources"] != []
    assert artifact["code_samples"] != []

    assert source_contexts[{:post, "/v1/widgets"}]["slug"] == "manage-widgets"
    assert source_contexts[{:post, "/v1/widgets"}]["description"] =~ "### Limits"
  end

  test "extract_upstream! writes deterministic reference_context artifact bytes" do
    project_root = make_tmp_dir!("page_context_deterministic")
    reference_root = Path.join(project_root, "reference")
    fixture_path = Path.join(reference_root, "manage-widgets.md")

    File.mkdir_p!(reference_root)
    File.cp!(@fixture_page, fixture_path)

    run_extract = fn ->
      Codegen.extract_upstream!(
        project_root: project_root,
        reference_root: reference_root,
        reference_pages: ["manage-widgets.md"]
      )

      File.read!(Path.join(project_root, "priv/upstream/reference_context/manage-widgets.json"))
    end

    assert run_extract.() == run_extract.()
  end

  test "generate! reuses committed extracted fixtures when markdown sources are unavailable" do
    project_root = make_tmp_dir!("generate_from_fixtures")
    reference_root = Path.join(project_root, "missing_reference")
    reference_dir = Path.join(project_root, "priv/upstream/reference")
    reference_context_dir = Path.join(project_root, "priv/upstream/reference_context")

    File.mkdir_p!(reference_dir)
    File.mkdir_p!(reference_context_dir)
    File.cp!(@committed_reference_spec, Path.join(reference_dir, "get-self.yaml"))
    File.cp!(@committed_reference_context, Path.join(reference_context_dir, "get-self.json"))

    opts = [
      project_root: project_root,
      reference_root: reference_root,
      reference_pages: ["get-self.md"]
    ]

    state = Codegen.generate!(opts)

    assert length(state.ir.operations) == 1

    generated_files =
      project_root
      |> Path.join("lib/notion_sdk/generated/**/*.ex")
      |> Path.wildcard()

    assert generated_files != []
    assert File.exists?(Path.join(project_root, "priv/generated/manifest.json"))
    assert File.exists?(Path.join(project_root, "priv/generated/docs_manifest.json"))
  end

  test "extracts markdown resources without treating inline code brackets as links" do
    markdown = """
    > Use `widget[timezone]` with [Widget templates](/guides/widget-templates).

    # Configure widgets

    ## OpenAPI

    ````yaml post /v1/widgets
    openapi: 3.1.0
    info:
      title: Widget API
      version: 1.0.0
    paths:
      /v1/widgets:
        post:
          summary: Configure widgets
          operationId: configure-widgets
          responses:
            '200':
              description: ok
    ````
    """

    %{page_context: page_context} = Extractor.extract_markdown!(markdown, "configure-widgets")
    resources = Enum.map(page_context.resources, &stringify_keys/1)

    assert Enum.any?(resources, &(&1["label"] == "Widget templates"))

    refute Enum.any?(
             resources,
             &String.contains?(&1["label"] || "", "widget[timezone")
           )
  end

  defp stringify_keys(map) do
    Enum.into(map, %{}, fn {key, value} -> {to_string(key), value} end)
  end

  defp make_tmp_dir!(name) do
    path =
      System.tmp_dir!()
      |> Path.join("notion_sdk_#{name}_#{System.unique_integer([:positive])}")

    File.rm_rf!(path)
    File.mkdir_p!(path)
    on_exit(fn -> File.rm_rf!(path) end)
    path
  end
end
