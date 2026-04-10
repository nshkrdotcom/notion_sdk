defmodule NotionSDK.Build.DependencyResolver do
  @moduledoc false

  @project_root Path.expand("..", __DIR__)
  @pristine_repo "nshkrdotcom/pristine"

  def pristine_runtime(opts \\ []) do
    case workspace_path(["../pristine/apps/pristine_runtime"]) do
      nil -> {:pristine, "~> 0.2.1", opts}
      path -> {:pristine, Keyword.merge([path: path], opts)}
    end
  end

  def pristine_codegen(opts \\ []) do
    resolve(
      :pristine_codegen,
      ["../pristine/apps/pristine_codegen"],
      [github: @pristine_repo, branch: "main", subdir: "apps/pristine_codegen"],
      opts
    )
  end

  def pristine_provider_testkit(opts \\ []) do
    resolve(
      :pristine_provider_testkit,
      ["../pristine/apps/pristine_provider_testkit"],
      [
        github: @pristine_repo,
        branch: "main",
        subdir: "apps/pristine_provider_testkit"
      ],
      opts
    )
  end

  defp resolve(app, local_paths, fallback_opts, opts) do
    case workspace_path(local_paths) do
      nil -> {app, Keyword.merge(fallback_opts, opts)}
      path -> {app, Keyword.merge([path: path], opts)}
    end
  end

  defp workspace_path(local_paths) do
    if prefer_workspace_paths?() do
      Enum.find_value(local_paths, &existing_path/1)
    end
  end

  defp prefer_workspace_paths? do
    workspace_paths_forced?() or
      (not release_source_deps_forced?() and not Enum.member?(Path.split(@project_root), "deps"))
  end

  defp release_source_deps_forced? do
    force_hex_deps?() or Enum.any?(System.argv(), &(&1 in ["hex.build", "hex.publish"]))
  end

  defp workspace_paths_forced? do
    not force_hex_deps?() and
      System.get_env("FORCE_WORKSPACE_PATH_DEPS") in ["1", "true", "TRUE", "yes", "YES"]
  end

  defp force_hex_deps? do
    System.get_env("NOTION_SDK_HEX_DEPS") in ["1", "true", "TRUE", "yes", "YES"]
  end

  defp existing_path(relative_path) do
    expanded_path = Path.expand(relative_path, @project_root)

    if File.dir?(expanded_path) do
      expanded_path
    end
  end
end
