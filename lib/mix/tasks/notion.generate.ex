defmodule Mix.Tasks.Notion.Generate do
  @moduledoc """
  Regenerates `notion_sdk` from the committed upstream fixtures.

  Use this task when the upstream snapshot and extracted reference files are already
  committed and you only need to rebuild the generated Elixir surface.

  ## Usage

      mix notion.generate

      mix notion.generate --reference-root /path/to/reference
      mix notion.generate --generated-dir /path/to/generated

  ## Options

  - `--project-root` override the repo root used to resolve relative paths
  - `--upstream-dir` override the `priv/upstream` root
  - `--inventory-path` override `priv/upstream/parity_inventory.json`
  - `--reference-root` point at upstream markdown when regenerating extracted fixtures
  - `--reference-dir` override the committed extracted OpenAPI directory
  - `--reference-context-dir` override the committed page-context directory
  - `--supplemental-dir` override the supplemental spec directory
  - `--generated-dir` override the generated Elixir output directory
  - `--generated-artifact-dir` override the generated manifest/docs artifact directory
  """

  use Mix.Task

  @shortdoc "Regenerate notion_sdk from the committed Notion codegen profile"
  @switches [
    project_root: :string,
    upstream_dir: :string,
    inventory_path: :string,
    reference_root: :string,
    reference_dir: :string,
    reference_context_dir: :string,
    supplemental_dir: :string,
    generated_dir: :string,
    generated_artifact_dir: :string
  ]

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")
    {opts, argv, invalid} = OptionParser.parse(args, strict: @switches)
    validate_args!(argv, invalid)

    state = codegen_module().generate!(opts)

    Mix.shell().info(
      "Generated NotionSDK: #{length(state.ir.operations)} operations, #{length(state.ir.schemas)} schemas"
    )
  end

  defp codegen_module do
    Application.get_env(:notion_sdk, :codegen_module, NotionSDK.Codegen)
  end

  defp validate_args!([], []), do: :ok

  defp validate_args!(argv, invalid) do
    unexpected =
      invalid
      |> Enum.map(fn {key, value} -> "--#{key}=#{value}" end)
      |> Kernel.++(argv)

    Mix.raise("unknown arguments for mix notion.generate: #{Enum.join(unexpected, ", ")}")
  end
end
