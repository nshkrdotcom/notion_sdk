defmodule Mix.Tasks.Notion.MaintenanceTaskTest do
  use ExUnit.Case, async: false

  alias Mix.Tasks.Notion.Generate, as: GenerateTask
  alias Mix.Tasks.Notion.Refresh, as: RefreshTask

  defmodule FakeCodegen do
    def generate!(opts) do
      send(Process.get(:notion_maintenance_task_test_pid), {:generate_opts, opts})
      %{ir: %{operations: [%{}], schemas: [%{}]}}
    end
  end

  defmodule FakeRefresh do
    def run!(opts) do
      send(Process.get(:notion_maintenance_task_test_pid), {:refresh_opts, opts})

      %{
        upstream_snapshots: %{added: [], changed: [], removed: []},
        extracted_specs: %{added: [], changed: [], removed: []},
        reference_context: %{added: [], changed: [], removed: []},
        supplemental_specs: %{added: [], changed: [], removed: []},
        generated_code: %{added: [], changed: [], removed: []},
        bridge_artifacts: %{added: [], changed: [], removed: []},
        metadata: %{}
      }
    end

    def format_report(_report), do: "fake refresh report"
  end

  setup do
    previous_shell = Mix.shell()
    Mix.shell(Mix.Shell.Process)
    Mix.Task.reenable("notion.generate")
    Mix.Task.reenable("notion.refresh")
    Process.put(:notion_maintenance_task_test_pid, self())

    on_exit(fn ->
      Application.delete_env(:notion_sdk, :codegen_module)
      Application.delete_env(:notion_sdk, :refresh_module)
      Process.delete(:notion_maintenance_task_test_pid)
      Mix.shell(previous_shell)
    end)

    :ok
  end

  test "mix notion.generate passes explicit path overrides through to codegen" do
    Application.put_env(:notion_sdk, :codegen_module, FakeCodegen)

    GenerateTask.run([
      "--project-root=/tmp/project",
      "--inventory-path=/tmp/parity_inventory.json",
      "--reference-root=/tmp/reference",
      "--reference-dir=/tmp/extracted",
      "--reference-context-dir=/tmp/reference_context",
      "--supplemental-dir=/tmp/supplemental",
      "--generated-dir=/tmp/generated",
      "--generated-artifact-dir=/tmp/generated_artifacts"
    ])

    assert_receive {:generate_opts, opts}
    assert Keyword.get(opts, :project_root) == "/tmp/project"
    assert Keyword.get(opts, :inventory_path) == "/tmp/parity_inventory.json"
    assert Keyword.get(opts, :reference_root) == "/tmp/reference"
    assert Keyword.get(opts, :reference_dir) == "/tmp/extracted"
    assert Keyword.get(opts, :reference_context_dir) == "/tmp/reference_context"
    assert Keyword.get(opts, :supplemental_dir) == "/tmp/supplemental"
    assert Keyword.get(opts, :generated_dir) == "/tmp/generated"
    assert Keyword.get(opts, :generated_artifact_dir) == "/tmp/generated_artifacts"
    assert_receive {:mix_shell, :info, ["Generated NotionSDK: 1 operations, 1 schemas"]}
  end

  test "mix notion.refresh passes explicit path overrides through and honors snapshots-only" do
    Application.put_env(:notion_sdk, :refresh_module, FakeRefresh)

    RefreshTask.run([
      "--project-root=/tmp/project",
      "--inventory-path=/tmp/parity_inventory.json",
      "--notion-docs-root=/tmp/notion_docs",
      "--reference-root=/tmp/reference",
      "--reference-dir=/tmp/extracted",
      "--reference-context-dir=/tmp/reference_context",
      "--supplemental-dir=/tmp/supplemental",
      "--js-sdk-root=/tmp/notion-sdk-js",
      "--snapshot-dir=/tmp/snapshots",
      "--generated-dir=/tmp/generated",
      "--generated-artifact-dir=/tmp/generated_artifacts",
      "--snapshots-only"
    ])

    assert_receive {:refresh_opts, opts}
    assert Keyword.get(opts, :project_root) == "/tmp/project"
    assert Keyword.get(opts, :inventory_path) == "/tmp/parity_inventory.json"
    assert Keyword.get(opts, :notion_docs_root) == "/tmp/notion_docs"
    assert Keyword.get(opts, :reference_root) == "/tmp/reference"
    assert Keyword.get(opts, :reference_dir) == "/tmp/extracted"
    assert Keyword.get(opts, :reference_context_dir) == "/tmp/reference_context"
    assert Keyword.get(opts, :supplemental_dir) == "/tmp/supplemental"
    assert Keyword.get(opts, :js_sdk_root) == "/tmp/notion-sdk-js"
    assert Keyword.get(opts, :snapshot_dir) == "/tmp/snapshots"
    assert Keyword.get(opts, :generated_dir) == "/tmp/generated"
    assert Keyword.get(opts, :generated_artifact_dir) == "/tmp/generated_artifacts"
    assert Keyword.get(opts, :generate?) == false
    assert_receive {:mix_shell, :info, ["fake refresh report"]}
  end
end
