defmodule NotionSDK.ExamplesReadinessTest do
  use ExUnit.Case, async: true

  @examples_dir Path.expand("../../examples", __DIR__)
  @cookbook_dir Path.join(@examples_dir, "cookbook")
  @readme_path Path.join(@examples_dir, "README.md")
  @runner_path Path.join(@examples_dir, "run_all.sh")

  test "example scripts parse as valid Elixir" do
    example_paths = root_example_paths() ++ cookbook_example_paths()

    assert example_paths != []

    Enum.each(example_paths, fn path ->
      assert {:ok, _quoted} = path |> File.read!() |> Code.string_to_quoted(file: path)
    end)
  end

  test "regression and cookbook inventories stay pinned" do
    assert length(root_example_paths()) == 36
    assert length(cookbook_example_paths()) == 5
  end

  test "example runner shell script parses" do
    {_, 0} = System.cmd("bash", ["-n", @runner_path], stderr_to_stdout: true)
  end

  test "example readme points to the local runner and documents key env vars" do
    readme = File.read!(@readme_path)

    assert readme =~ "[`run_all.sh`](./run_all.sh)"
    assert readme =~ "[Cookbook README](./cookbook/README.md)"
    assert readme =~ "Read comments"
    assert readme =~ "./examples/run_all.sh mutations"
    assert readme =~ "./examples/run_all.sh cookbook"
    refute readme =~ "/home/home/"

    for env_name <- [
          "NOTION_TOKEN",
          "NOTION_BASE_URL",
          "NOTION_VERSION",
          "NOTION_TIMEOUT_MS",
          "NOTION_EXAMPLE_PAGE_ID",
          "NOTION_EXAMPLE_SEARCH_QUERY",
          "NOTION_EXAMPLE_FILE_URL",
          "NOTION_OAUTH_CLIENT_ID",
          "NOTION_OAUTH_CLIENT_SECRET",
          "NOTION_OAUTH_TOKEN_PATH",
          "NOTION_OAUTH_AUTH_CODE",
          "NOTION_OAUTH_EXCHANGE_TOKEN_PATH",
          "NOTION_OAUTH_REVOKE_TOKEN"
        ] do
      assert readme =~ env_name
    end
  end

  defp root_example_paths do
    @examples_dir
    |> Path.join("[0-9][0-9]_*.exs")
    |> Path.wildcard()
    |> Enum.sort()
  end

  defp cookbook_example_paths do
    @cookbook_dir
    |> Path.join("[0-9][0-9]_*.exs")
    |> Path.wildcard()
    |> Enum.sort()
  end
end
