defmodule NotionSDK.Build.PltFingerprint do
  @moduledoc false

  @project_patterns [
    "mix.exs",
    "lib/**/*.{ex,exs,erl,hrl}",
    "codegen/**/*.{ex,exs,erl,hrl}",
    "lib/notion_sdk/generated/**/*.{ex,exs,erl,hrl}",
    "priv/generated/**/*"
  ]
  @dependency_patterns [
    "mix.exs",
    "lib/**/*.{ex,exs,erl,hrl}",
    "src/**/*.{ex,exs,erl,hrl}",
    "include/**/*.{erl,hrl}"
  ]

  @type dependency :: %{required(:app) => atom(), required(:path) => String.t()}

  @spec project(keyword()) :: String.t()
  def project(opts \\ []) when is_list(opts) do
    project_root =
      opts
      |> Keyword.get(:project_root, default_project_root())
      |> Path.expand()

    dependencies =
      opts
      |> Keyword.get(:dependencies, [])
      |> Enum.map(&normalize_dependency!/1)
      |> Enum.sort_by(&{&1.app, &1.path})

    [
      project: file_signatures(project_root, @project_patterns),
      dependencies: Enum.map(dependencies, &dependency_signature/1)
    ]
    |> :erlang.term_to_binary()
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
    |> binary_part(0, 12)
  end

  defp default_project_root do
    Path.expand("..", __DIR__)
  end

  defp normalize_dependency!(%{app: app, path: path})
       when is_atom(app) and is_binary(path) do
    %{app: app, path: Path.expand(path)}
  end

  defp normalize_dependency!(dependency) do
    raise ArgumentError,
          "expected dependency metadata with :app and :path, got: #{inspect(dependency)}"
  end

  defp dependency_signature(%{app: app, path: path}) do
    {app, path, file_signatures(path, @dependency_patterns)}
  end

  defp file_signatures(root, patterns) do
    root
    |> file_paths(patterns)
    |> Enum.map(&file_signature(root, &1))
  end

  defp file_paths(root, patterns) do
    patterns
    |> Enum.flat_map(fn pattern ->
      Path.wildcard(Path.join(root, pattern), match_dot: true)
    end)
    |> Enum.filter(&File.regular?/1)
    |> Enum.uniq()
    |> Enum.sort()
  end

  defp file_signature(root, path) do
    {Path.relative_to(path, root), hash_file(path)}
  end

  defp hash_file(path) do
    path
    |> File.stream!([], 64_000)
    |> Enum.reduce(:crypto.hash_init(:sha256), &:crypto.hash_update(&2, &1))
    |> :crypto.hash_final()
    |> Base.encode16(case: :lower)
  end
end
