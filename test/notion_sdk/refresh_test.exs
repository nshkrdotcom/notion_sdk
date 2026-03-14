defmodule NotionSDK.RefreshTest do
  use ExUnit.Case, async: true

  @doc_source_files [
    {"reference/get-self.md",
     """
     # Retrieve your token's bot user

     Retrieves the bot user for the current token.

     ## OpenAPI

     ````yaml get /v1/users/me
     openapi: 3.1.0
     info:
       title: Get self
       version: 1.0.0
     paths:
       /v1/users/me:
         get:
           summary: Retrieve your token's bot user
           operationId: get-self
           responses:
             '200':
               description: ok
     ````
     """},
    {"reference/versioning.md", "# Versioning\n"},
    {"reference/request-limits.md", "# Request limits\n"},
    {"reference/status-codes.md", "# Status codes\n"}
  ]
  @js_sdk_source_files [
    {"package.json", ~s({"name":"@notionhq/client","version":"5.12.0"})},
    {"README.md", "# Notion JS SDK\n"},
    {"src/Client.ts", "export const defaultNotionVersion = '2025-09-03'\n"},
    {"src/errors.ts", "export class APIResponseError extends Error {}\n"},
    {"src/helpers.ts", "export const iteratePaginatedAPI = () => {}\n"},
    {"test/Client.test.ts", "describe('Client', () => {})\n"},
    {"test/helpers.test.ts", "describe('helpers', () => {})\n"}
  ]
  @parity_inventory %{
    "js_sdk" => %{
      "package" => "@notionhq/client",
      "version" => "5.12.0"
    },
    "operations" => [
      %{
        "function" => "get_self",
        "method" => "get",
        "module" => "Users",
        "path" => "/v1/users/me",
        "reference_page" => "get-self.md"
      }
    ]
  }

  test "captures upstream snapshots from the committed parity inventory, runs generation, and writes a grouped diff report" do
    project_root = make_tmp_dir!("project")
    notion_docs_root = Path.join(project_root, "notion_docs")
    js_sdk_root = Path.join(project_root, "notion-sdk-js")
    upstream_dir = Path.join(project_root, "priv/upstream")
    generated_dir = Path.join(project_root, "lib/notion_sdk/generated")
    generated_artifact_dir = Path.join(project_root, "priv/generated")

    File.mkdir_p!(Path.join(upstream_dir, "supplemental"))
    File.write!(Path.join(upstream_dir, "supplemental/notion_sdk.root.yaml"), "openapi: 3.1.0\n")

    File.write!(
      Path.join(upstream_dir, "parity_inventory.json"),
      Jason.encode!(@parity_inventory)
    )

    Enum.each(@doc_source_files, fn {relative_path, contents} ->
      path = Path.join(notion_docs_root, relative_path)
      File.mkdir_p!(Path.dirname(path))
      File.write!(path, contents)
    end)

    Enum.each(@js_sdk_source_files, fn {relative_path, contents} ->
      path = Path.join(js_sdk_root, relative_path)
      File.mkdir_p!(Path.dirname(path))
      File.write!(path, contents)
    end)

    report =
      NotionSDK.Refresh.run!(
        project_root: project_root,
        notion_docs_root: notion_docs_root,
        js_sdk_root: js_sdk_root,
        generate_fun: fn paths ->
          File.mkdir_p!(paths.generated_dir)

          File.write!(
            Path.join(paths.generated_dir, "users.ex"),
            "defmodule NotionSDK.Users do\nend\n"
          )

          File.mkdir_p!(paths.generated_artifact_dir)

          File.write!(
            Path.join(paths.generated_artifact_dir, "manifest.json"),
            ~s({"operation_count":1})
          )

          File.write!(
            Path.join(paths.generated_artifact_dir, "docs_manifest.json"),
            ~s({"operations":[]})
          )

          :ok
        end
      )

    assert File.exists?(Path.join(upstream_dir, "snapshots/reference/get-self.md"))
    assert File.exists?(Path.join(upstream_dir, "snapshots/docs/versioning.md"))
    assert File.exists?(Path.join(upstream_dir, "snapshots/notion-sdk-js/package.json"))
    assert File.exists?(Path.join(upstream_dir, "reference/get-self.yaml"))
    assert File.exists?(Path.join(upstream_dir, "reference_context/get-self.json"))
    assert File.exists?(Path.join(generated_dir, "users.ex"))
    assert File.exists?(Path.join(generated_artifact_dir, "refresh_report.json"))

    metadata =
      upstream_dir
      |> Path.join("snapshots/metadata.json")
      |> File.read!()
      |> Jason.decode!()

    assert report.upstream_snapshots.added != []
    assert report.extracted_specs.added == ["get-self.yaml"]
    assert report.reference_context.added == ["get-self.json"]
    assert report.supplemental_specs.added == []
    assert report.generated_code.added == ["users.ex"]

    assert report.bridge_artifacts.added == [
             "docs_manifest.json",
             "manifest.json",
             "refresh_report.json"
           ]

    assert metadata["reference_pages"] == ["get-self.md"]
    assert metadata["parity_inventory"]["js_sdk"]["package"] == "@notionhq/client"
    assert metadata["parity_inventory"]["operation_count"] == 1
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
