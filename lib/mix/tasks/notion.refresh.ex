defmodule Mix.Tasks.Notion.Refresh do
  @moduledoc """
  Refreshes upstream inputs, regenerates `notion_sdk`, and writes a grouped diff report.

  This is the end-to-end maintenance entry point for parity updates. It snapshots the
  upstream Notion docs and vendored JS SDK inputs, extracts the committed reference
  fixtures, regenerates the Elixir SDK, and emits `priv/generated/refresh_report.json`
  for review.

  ## Usage

      mix notion.refresh
      mix notion.refresh --snapshots-only
      mix notion.refresh --notion-docs-root /path/to/notion_docs --js-sdk-root /path/to/notion-sdk-js

  ## Options

  - `--snapshots-only` captures upstream inputs without regenerating the SDK.
  - `--project-root` override the repo root used to resolve relative paths
  - `--upstream-dir` override the `priv/upstream` root
  - `--inventory-path` override `priv/upstream/parity_inventory.json`
  - `--notion-docs-root` point at the Notion docs checkout or prepared snapshot root
  - `--reference-root` override the markdown directory used for extraction and snapshotting
  - `--reference-dir` override the committed extracted OpenAPI directory
  - `--reference-context-dir` override the committed page-context directory
  - `--supplemental-dir` override the supplemental spec directory
  - `--js-sdk-root` point at the vendored JS SDK checkout
  - `--snapshot-dir` override the raw upstream snapshot directory
  - `--generated-dir` override the generated Elixir output directory
  - `--generated-artifact-dir` override the generated manifest/docs artifact directory
  """

  use Mix.Task

  @shortdoc "Refresh upstream snapshots, regenerate notion_sdk, and print grouped diffs"
  @switches [
    snapshots_only: :boolean,
    project_root: :string,
    upstream_dir: :string,
    inventory_path: :string,
    notion_docs_root: :string,
    reference_root: :string,
    reference_dir: :string,
    reference_context_dir: :string,
    supplemental_dir: :string,
    js_sdk_root: :string,
    snapshot_dir: :string,
    generated_dir: :string,
    generated_artifact_dir: :string
  ]

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")

    {opts, argv, invalid} = OptionParser.parse(args, strict: @switches)
    validate_args!(argv, invalid)

    refresh_opts =
      opts
      |> Keyword.put(:generate?, not Keyword.get(opts, :snapshots_only, false))
      |> Keyword.delete(:snapshots_only)

    runner = refresh_module()
    report = runner.run!(refresh_opts)
    Mix.shell().info(runner.format_report(report))
  end

  defp refresh_module do
    Application.get_env(:notion_sdk, :refresh_module, NotionSDK.Refresh)
  end

  defp validate_args!([], []), do: :ok

  defp validate_args!(argv, invalid) do
    unexpected =
      invalid
      |> Enum.map(fn {key, value} -> "--#{key}=#{value}" end)
      |> Kernel.++(argv)

    Mix.raise("unknown arguments for mix notion.refresh: #{Enum.join(unexpected, ", ")}")
  end
end
