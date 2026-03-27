defmodule NotionSDK.Build.DependencyResolver do
  @moduledoc false

  @project_root Path.expand("..", __DIR__)
  @pristine_ref "674df61e5e2ab8c73927c75fb9b16a603301f89f"

  def pristine_runtime(opts \\ []) do
    resolve(
      :pristine,
      ["../pristine/apps/pristine_runtime"],
      [github: "nshkrdotcom/pristine", ref: @pristine_ref, subdir: "apps/pristine_runtime"],
      opts
    )
  end

  def pristine_codegen(opts \\ []) do
    resolve(
      :pristine_codegen,
      ["../pristine/apps/pristine_codegen"],
      [github: "nshkrdotcom/pristine", ref: @pristine_ref, subdir: "apps/pristine_codegen"],
      opts
    )
  end

  def pristine_provider_testkit(opts \\ []) do
    resolve(
      :pristine_provider_testkit,
      ["../pristine/apps/pristine_provider_testkit"],
      [
        github: "nshkrdotcom/pristine",
        ref: @pristine_ref,
        subdir: "apps/pristine_provider_testkit"
      ],
      opts
    )
  end

  defp resolve(app, local_paths, fallback_opts, opts) do
    case Enum.find_value(local_paths, &existing_path/1) do
      nil -> {app, Keyword.merge(fallback_opts, opts)}
      path -> {app, Keyword.merge([path: path], opts)}
    end
  end

  defp existing_path(relative_path) do
    expanded_path = Path.expand(relative_path, @project_root)

    if File.dir?(expanded_path) do
      expanded_path
    end
  end
end
