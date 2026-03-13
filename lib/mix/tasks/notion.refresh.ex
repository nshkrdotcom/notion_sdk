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

  ## Options

  - `--snapshots-only` captures upstream inputs without regenerating the SDK.
  """

  use Mix.Task

  @shortdoc "Refresh upstream snapshots, regenerate notion_sdk, and print grouped diffs"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("compile")

    {opts, _argv, _invalid} =
      OptionParser.parse(args,
        strict: [snapshots_only: :boolean]
      )

    report =
      NotionSDK.Refresh.run!(generate?: not Keyword.get(opts, :snapshots_only, false))

    Mix.shell().info(NotionSDK.Refresh.format_report(report))
  end
end
