defmodule NotionSDK.BoundaryContractTest do
  use ExUnit.Case, async: true

  @forbidden_patterns [
    "Pristine.Core.Context",
    "Pristine.Core.Response",
    "Pristine.Core.ResultClassification",
    "Pristine.OpenAPI.Client",
    "Pristine.OpenAPI.Operation",
    "Pristine.OpenAPI.Runtime",
    "Pristine.Profiles.Foundation"
  ]

  @handwritten_globs [
    "README.md",
    "guides/**/*.md",
    "examples/**/*.exs",
    "lib/**/*.ex",
    "test/**/*.exs",
    "codegen/**/*.ex"
  ]

  test "handwritten source depends on the hardened pristine boundary instead of old internals" do
    violations =
      @handwritten_globs
      |> Enum.flat_map(&Path.wildcard/1)
      |> Enum.reject(&generated_path?/1)
      |> Enum.flat_map(fn path ->
        source = File.read!(path)

        Enum.flat_map(@forbidden_patterns, fn pattern ->
          if String.contains?(source, pattern) do
            ["#{path}: #{pattern}"]
          else
            []
          end
        end)
      end)

    assert violations == []
  end

  defp generated_path?(path) do
    String.contains?(path, "/lib/notion_sdk/generated/") or
      path == "test/notion_sdk/boundary_contract_test.exs"
  end
end
