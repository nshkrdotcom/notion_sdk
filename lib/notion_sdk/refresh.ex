defmodule NotionSDK.Refresh do
  @moduledoc """
  Repeatable upstream snapshot, regeneration, and diff workflow for `notion_sdk`.
  """

  @doc_snapshot_pages [
    "versioning.md",
    "request-limits.md",
    "status-codes.md"
  ]
  @js_sdk_snapshot_files [
    "package.json",
    "README.md",
    "src/Client.ts",
    "src/errors.ts",
    "src/helpers.ts",
    "test/Client.test.ts",
    "test/helpers.test.ts"
  ]

  @type change_set :: %{
          added: [String.t()],
          changed: [String.t()],
          removed: [String.t()]
        }

  @type report :: %{
          upstream_snapshots: change_set(),
          extracted_specs: change_set(),
          reference_context: change_set(),
          supplemental_specs: change_set(),
          generated_code: change_set(),
          bridge_artifacts: change_set(),
          metadata: map()
        }

  @spec run!(keyword()) :: report()
  def run!(opts \\ []) when is_list(opts) do
    paths = paths(opts)
    before = fingerprint_groups(paths)

    snapshot_upstream!(paths)

    codegen_apply!(
      :extract_upstream!,
      project_root: paths.project_root,
      reference_root: paths.reference_root,
      reference_pages: paths.reference_pages
    )

    if Map.fetch!(paths, :generate?) do
      Map.fetch!(paths, :generate_fun).(paths)
    end

    after_fingerprints = fingerprint_groups(paths)
    report = build_report(before, after_fingerprints, paths)
    write_report!(paths, report)

    final_report =
      paths
      |> fingerprint_groups()
      |> then(&build_report(before, &1, paths))

    write_report!(paths, final_report)
    final_report
  end

  @spec format_report(report()) :: String.t()
  def format_report(report) do
    [
      "upstream_snapshots: " <> summarize_change_set(report.upstream_snapshots),
      "extracted_specs: " <> summarize_change_set(report.extracted_specs),
      "reference_context: " <> summarize_change_set(report.reference_context),
      "supplemental_specs: " <> summarize_change_set(report.supplemental_specs),
      "generated_code: " <> summarize_change_set(report.generated_code),
      "bridge_artifacts: " <> summarize_change_set(report.bridge_artifacts)
    ]
    |> Enum.join("\n")
  end

  @spec paths(keyword()) :: map()
  def paths(opts \\ []) when is_list(opts) do
    notion_docs_root =
      Keyword.get(
        opts,
        :notion_docs_root,
        codegen_apply!(:reference_root, project_root: project_root(opts)) |> Path.dirname()
      )

    reference_root =
      Keyword.get(opts, :reference_root, Path.join(notion_docs_root, "reference"))

    inventory_path =
      NotionSDK.ParityInventory.path(
        project_root: project_root(opts),
        inventory_path: Keyword.get(opts, :inventory_path)
      )

    reference_pages =
      case Keyword.fetch(opts, :reference_pages) do
        {:ok, pages} ->
          pages

        :error ->
          NotionSDK.ParityInventory.reference_pages(
            project_root: project_root(opts),
            inventory_path: inventory_path
          )
      end

    codegen_paths =
      codegen_apply!(
        :paths,
        project_root: project_root(opts),
        reference_root: reference_root,
        inventory_path: inventory_path,
        reference_pages: reference_pages
      )

    %{
      project_root: Map.fetch!(codegen_paths, :project_root),
      upstream_dir: Map.fetch!(codegen_paths, :upstream_dir),
      reference_dir: Map.fetch!(codegen_paths, :reference_dir),
      reference_context_dir: Map.fetch!(codegen_paths, :reference_context_dir),
      supplemental_dir: Map.fetch!(codegen_paths, :supplemental_dir),
      generated_dir: Map.fetch!(codegen_paths, :generated_dir),
      generated_artifact_dir: Map.fetch!(codegen_paths, :generated_artifact_dir),
      inventory_path: inventory_path,
      reference_root: Map.fetch!(codegen_paths, :reference_root),
      notion_docs_root: notion_docs_root,
      js_sdk_root:
        Keyword.get(opts, :js_sdk_root, Path.join(codegen_paths.project_root, "notion-sdk-js")),
      snapshot_dir:
        Keyword.get(opts, :snapshot_dir, Path.join(codegen_paths.upstream_dir, "snapshots")),
      reference_pages: codegen_paths.reference_pages,
      doc_snapshot_pages: Keyword.get(opts, :doc_snapshot_pages, @doc_snapshot_pages),
      js_sdk_snapshot_files: Keyword.get(opts, :js_sdk_snapshot_files, @js_sdk_snapshot_files),
      generate?: Keyword.get(opts, :generate?, true),
      generate_fun: Keyword.get(opts, :generate_fun, &default_generate/1)
    }
  end

  defp project_root(opts), do: Keyword.get(opts, :project_root, codegen_apply!(:project_root))

  defp default_generate(paths) do
    codegen_apply!(
      :generate!,
      project_root: paths.project_root,
      reference_root: paths.reference_root,
      reference_pages: paths.reference_pages
    )
  end

  defp codegen_apply!(fun, opts \\ []) when is_atom(fun) and is_list(opts) do
    module = codegen_module()
    Code.ensure_loaded?(module)

    cond do
      opts == [] and function_exported?(module, fun, 0) ->
        apply(module, fun, [])

      function_exported?(module, fun, 1) ->
        apply(module, fun, [opts])

      function_exported?(module, fun, 0) ->
        apply(module, fun, [])
    end
  end

  defp codegen_module do
    Module.concat(NotionSDK, Codegen)
  end

  defp snapshot_upstream!(paths) do
    reference_snapshot_dir = Path.join(paths.snapshot_dir, "reference")
    docs_snapshot_dir = Path.join(paths.snapshot_dir, "docs")
    js_sdk_snapshot_dir = Path.join(paths.snapshot_dir, "notion-sdk-js")

    File.mkdir_p!(reference_snapshot_dir)
    File.mkdir_p!(docs_snapshot_dir)
    File.mkdir_p!(js_sdk_snapshot_dir)

    Enum.each(paths.reference_pages, fn page ->
      copy_snapshot!(
        Path.join(paths.reference_root, page),
        Path.join(reference_snapshot_dir, page)
      )
    end)

    Enum.each(paths.doc_snapshot_pages, fn page ->
      copy_snapshot!(
        Path.join(paths.reference_root, page),
        Path.join(docs_snapshot_dir, page)
      )
    end)

    Enum.each(paths.js_sdk_snapshot_files, fn relative_path ->
      copy_snapshot!(
        Path.join(paths.js_sdk_root, relative_path),
        Path.join(js_sdk_snapshot_dir, relative_path)
      )
    end)

    parity_inventory =
      NotionSDK.ParityInventory.summary(
        project_root: paths.project_root,
        inventory_path: paths.inventory_path
      )

    metadata = %{
      js_sdk_version: package_version(paths),
      notion_default_version: NotionSDK.Client.default_notion_version(),
      reference_pages: paths.reference_pages,
      parity_inventory: parity_inventory,
      provenance: provenance_metadata(paths),
      doc_snapshot_pages: paths.doc_snapshot_pages,
      js_sdk_snapshot_files: paths.js_sdk_snapshot_files
    }

    File.write!(
      Path.join(paths.snapshot_dir, "metadata.json"),
      ordered_json!(metadata)
    )
  end

  defp copy_snapshot!(source, destination) do
    File.mkdir_p!(Path.dirname(destination))
    File.cp!(source, destination)
  end

  defp package_version(paths) do
    paths.js_sdk_root
    |> Path.join("package.json")
    |> File.read!()
    |> json_decode!()
    |> Map.get("version")
  end

  defp provenance_metadata(paths) do
    %{
      captured_at: DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601(),
      notion_docs: %{
        git: git_provenance(paths.notion_docs_root),
        tracked_files_sha256:
          tracked_files_sha256(
            paths.reference_root,
            Enum.uniq(paths.reference_pages ++ paths.doc_snapshot_pages)
          )
      },
      js_sdk: %{
        package_version: package_version(paths),
        git: git_provenance(paths.js_sdk_root),
        tracked_files_sha256: tracked_files_sha256(paths.js_sdk_root, paths.js_sdk_snapshot_files)
      }
    }
  end

  defp tracked_files_sha256(root, relative_paths) do
    relative_paths
    |> Enum.sort()
    |> Enum.map(fn relative_path ->
      [relative_path, <<0>>, File.read!(Path.join(root, relative_path))]
    end)
    |> IO.iodata_to_binary()
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
  end

  defp git_provenance(root) do
    with true <- is_binary(root) and File.dir?(root),
         {:ok, commit} <- git_stdout(root, ["rev-parse", "HEAD"]) do
      %{
        available: true,
        commit: commit,
        origin_url: git_stdout(root, ["config", "--get", "remote.origin.url"]) |> value_or_nil()
      }
    else
      _other ->
        %{
          available: false,
          commit: nil,
          origin_url: nil
        }
    end
  end

  defp git_stdout(root, args) do
    case System.cmd("git", ["-C", root | args], stderr_to_stdout: true) do
      {output, 0} -> {:ok, String.trim(output)}
      {_output, _exit_code} -> :error
    end
  end

  defp value_or_nil({:ok, ""}), do: nil
  defp value_or_nil({:ok, value}), do: value
  defp value_or_nil(:error), do: nil

  defp build_report(before, current, paths) do
    %{
      upstream_snapshots: diff_group(before.upstream_snapshots, current.upstream_snapshots),
      extracted_specs: diff_group(before.extracted_specs, current.extracted_specs),
      reference_context: diff_group(before.reference_context, current.reference_context),
      supplemental_specs: diff_group(before.supplemental_specs, current.supplemental_specs),
      generated_code: diff_group(before.generated_code, current.generated_code),
      bridge_artifacts: diff_group(before.bridge_artifacts, current.bridge_artifacts),
      metadata: %{
        generated?: Map.fetch!(paths, :generate?),
        js_sdk_root: paths.js_sdk_root,
        notion_docs_root: paths.notion_docs_root,
        snapshot_dir: paths.snapshot_dir
      }
    }
  end

  defp write_report!(paths, report) do
    File.mkdir_p!(paths.generated_artifact_dir)

    File.write!(
      Path.join(paths.generated_artifact_dir, "refresh_report.json"),
      ordered_json!(report)
    )
  end

  defp fingerprint_groups(paths) do
    %{
      upstream_snapshots: fingerprint_dir(paths.snapshot_dir),
      extracted_specs: fingerprint_dir(paths.reference_dir),
      reference_context: fingerprint_dir(paths.reference_context_dir),
      supplemental_specs: fingerprint_dir(paths.supplemental_dir),
      generated_code: fingerprint_dir(paths.generated_dir),
      bridge_artifacts: fingerprint_dir(paths.generated_artifact_dir)
    }
  end

  defp fingerprint_dir(dir) do
    if File.dir?(dir) do
      dir
      |> Path.join("**/*")
      |> Path.wildcard(match_dot: true)
      |> Enum.filter(&File.regular?/1)
      |> Enum.reduce(%{}, fn file, acc ->
        relative_path = Path.relative_to(file, dir)
        Map.put(acc, relative_path, file_hash(file))
      end)
    else
      %{}
    end
  end

  defp file_hash(file) do
    file
    |> File.read!()
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
  end

  defp diff_group(before, current) do
    before_keys = Map.keys(before) |> MapSet.new()
    after_keys = Map.keys(current) |> MapSet.new()

    %{
      added: after_keys |> MapSet.difference(before_keys) |> MapSet.to_list() |> Enum.sort(),
      changed:
        before_keys
        |> MapSet.intersection(after_keys)
        |> Enum.filter(&(Map.fetch!(before, &1) != Map.fetch!(current, &1)))
        |> Enum.sort(),
      removed: before_keys |> MapSet.difference(after_keys) |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp summarize_change_set(change_set) do
    parts =
      [
        {"added", length(change_set.added)},
        {"changed", length(change_set.changed)},
        {"removed", length(change_set.removed)}
      ]
      |> Enum.map(fn {label, count} -> "#{label}=#{count}" end)

    Enum.join(parts, ", ")
  end

  defp ordered_json!(term) do
    term
    |> ordered_json_term()
    |> json_encode!(pretty: true)
  end

  defp ordered_json_term(%_{} = struct), do: struct |> Map.from_struct() |> ordered_json_term()

  defp ordered_json_term(map) when is_map(map) do
    map
    |> Enum.map(fn {key, value} -> {to_string(key), ordered_json_term(value)} end)
    |> Enum.sort_by(fn {key, _value} -> key end)
    |> ordered_object_new()
  end

  defp ordered_json_term(tuple) when is_tuple(tuple) do
    tuple
    |> Tuple.to_list()
    |> Enum.map(&ordered_json_term/1)
  end

  defp ordered_json_term(list) when is_list(list), do: Enum.map(list, &ordered_json_term/1)
  defp ordered_json_term(value), do: value

  defp json_decode!(value) do
    module = json_module()
    module.decode!(value)
  end

  defp json_encode!(value, opts) do
    module = json_module()
    module.encode!(value, opts)
  end

  defp ordered_object_new(entries) do
    module = ordered_object_module()
    module.new(entries)
  end

  defp json_module do
    Module.concat([Jason])
  end

  defp ordered_object_module do
    Module.concat([Jason, OrderedObject])
  end
end
