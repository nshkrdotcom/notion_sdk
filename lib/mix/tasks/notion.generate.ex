defmodule Mix.Tasks.Notion.Generate do
  @moduledoc """
  Regenerates `notion_sdk` from the committed upstream fixtures.

  Use this task when the upstream snapshot and extracted reference files are already
  committed and you only need to rebuild the generated Elixir surface.

  ## Usage

      mix notion.generate
  """

  use Mix.Task

  @shortdoc "Regenerate notion_sdk from the committed Notion codegen profile"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("compile")

    state = NotionSDK.Codegen.generate!()

    Mix.shell().info(
      "Generated NotionSDK: #{length(state.operations)} operations, #{map_size(state.schemas)} schemas"
    )
  end
end
