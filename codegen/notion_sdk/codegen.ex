defmodule NotionSDK.Codegen do
  @moduledoc """
  Build-time generation workflow for the thin Notion SDK package.
  """

  alias Jason.OrderedObject
  alias NotionSDK.CompatibilityContract
  alias NotionSDK.Codegen.Source.Extractor
  alias NotionSDK.Codegen.Source.PageContext
  alias NotionSDK.ParityInventory
  alias Pristine.OpenAPI.Bridge

  @profile :notion_sdk

  @type path_options :: keyword()
  @type state :: map()

  @spec profile() :: atom()
  def profile, do: @profile

  @spec reference_pages() :: [String.t()]
  def reference_pages, do: ParityInventory.reference_pages()

  @spec project_root() :: String.t()
  def project_root do
    Path.expand("../..", __DIR__)
  end

  @spec paths(path_options()) :: map()
  def paths(opts \\ []) when is_list(opts) do
    project_root = Keyword.get(opts, :project_root, project_root())
    upstream_dir = Keyword.get(opts, :upstream_dir, Path.join(project_root, "priv/upstream"))

    inventory_path =
      ParityInventory.path(
        project_root: project_root,
        inventory_path: Keyword.get(opts, :inventory_path)
      )

    reference_pages = reference_pages_opt(opts, project_root, inventory_path)

    generated_dir =
      Keyword.get(opts, :generated_dir, Path.join(project_root, "lib/notion_sdk/generated"))

    %{
      project_root: project_root,
      upstream_dir: upstream_dir,
      reference_dir: Keyword.get(opts, :reference_dir, Path.join(upstream_dir, "reference")),
      reference_context_dir:
        Keyword.get(opts, :reference_context_dir, Path.join(upstream_dir, "reference_context")),
      supplemental_dir:
        Keyword.get(opts, :supplemental_dir, Path.join(upstream_dir, "supplemental")),
      generated_dir: generated_dir,
      generated_artifact_dir:
        Keyword.get(opts, :generated_artifact_dir, Path.join(project_root, "priv/generated")),
      inventory_path: inventory_path,
      reference_root:
        Keyword.get(
          opts,
          :reference_root,
          System.get_env("NOTION_DOCS_ROOT") ||
            Path.expand("../notion_docs/reference", project_root)
        ),
      reference_pages: reference_pages
    }
  end

  @spec upstream_dir(path_options()) :: String.t()
  def upstream_dir(opts \\ []), do: paths(opts).upstream_dir

  @spec reference_dir(path_options()) :: String.t()
  def reference_dir(opts \\ []), do: paths(opts).reference_dir

  @spec supplemental_dir(path_options()) :: String.t()
  def supplemental_dir(opts \\ []), do: paths(opts).supplemental_dir

  @spec reference_context_dir(path_options()) :: String.t()
  def reference_context_dir(opts \\ []), do: paths(opts).reference_context_dir

  @spec generated_dir(path_options()) :: String.t()
  def generated_dir(opts \\ []), do: paths(opts).generated_dir

  @spec generated_artifact_dir(path_options()) :: String.t()
  def generated_artifact_dir(opts \\ []), do: paths(opts).generated_artifact_dir

  @spec reference_root(path_options()) :: String.t()
  def reference_root(opts \\ []), do: paths(opts).reference_root

  @spec generate!(path_options()) :: state()
  def generate!(opts \\ []) when is_list(opts) do
    paths = paths(opts)
    extract_upstream? = extract_upstream?(paths)
    prepare_dirs!(paths, extract_upstream?: extract_upstream?)

    if extract_upstream? do
      extract_upstream!(opts)
    else
      ensure_extracted_upstream!(paths)
    end

    state =
      Bridge.run(
        profile(),
        reference_spec_files(opts),
        source_contexts: source_contexts(opts),
        base_module: NotionSDK,
        output_dir: paths.generated_dir,
        default_client: NotionSDK.Client,
        operation_use: Pristine.OpenAPI.Operation,
        error_type: NotionSDK.Error,
        processor: NotionSDK.Codegen.Processor,
        renderer: NotionSDK.Codegen.Renderer,
        supplemental_files: supplemental_spec_files(opts),
        profile_overrides: [
          output: [
            schema_subdirectory: "schemas",
            types: [specs: :spec_comprehensive]
          ]
        ]
      )

    persist_artifacts!(state, paths)
    state
  end

  @spec extract_upstream!(path_options()) :: :ok
  def extract_upstream!(opts \\ []) when is_list(opts) do
    paths = paths(opts)
    File.mkdir_p!(paths.reference_dir)
    File.mkdir_p!(paths.reference_context_dir)

    Enum.each(paths.reference_pages, fn page ->
      markdown_path = Path.join(paths.reference_root, page)
      yaml_path = reference_spec_path(paths, page)
      reference_context_path = reference_context_path(paths, page)
      %{yaml: yaml, page_context: page_context} = Extractor.extract_file!(markdown_path)
      File.write!(yaml_path, yaml)

      page_context
      |> PageContext.to_artifact()
      |> ordered_json!()
      |> then(&File.write!(reference_context_path, &1 <> "\n"))
    end)

    :ok
  end

  @spec reference_spec_files(path_options()) :: [String.t()]
  def reference_spec_files(opts \\ []) when is_list(opts) do
    paths = paths(opts)
    Enum.map(paths.reference_pages, &reference_spec_path(paths, &1))
  end

  @spec supplemental_spec_files(path_options()) :: [String.t()]
  def supplemental_spec_files(opts \\ []) when is_list(opts) do
    opts
    |> supplemental_dir()
    |> Path.join("*")
    |> Path.wildcard()
    |> Enum.filter(&String.ends_with?(&1, [".json", ".yaml", ".yml"]))
    |> Enum.sort()
  end

  @spec source_contexts(path_options()) :: %{optional({atom(), String.t()}) => map()}
  def source_contexts(opts \\ []) when is_list(opts) do
    paths = paths(opts)

    paths
    |> reference_context_files()
    |> Enum.reduce(%{}, fn artifact_path, acc ->
      artifact = artifact_path |> File.read!() |> Jason.decode!()

      case normalize_context_key(artifact) do
        nil ->
          acc

        key ->
          Map.put(acc, key, artifact)
      end
    end)
  end

  defp prepare_dirs!(paths, opts) do
    if Keyword.get(opts, :extract_upstream?, true) do
      File.rm_rf!(paths.reference_dir)
      File.rm_rf!(paths.reference_context_dir)
    end

    File.mkdir_p!(paths.reference_dir)
    File.mkdir_p!(paths.reference_context_dir)
    File.mkdir_p!(paths.supplemental_dir)
    File.rm_rf!(paths.generated_dir)
    File.mkdir_p!(paths.generated_dir)
    File.rm_rf!(paths.generated_artifact_dir)
    File.mkdir_p!(paths.generated_artifact_dir)
  end

  defp reference_pages_opt(opts, project_root, inventory_path) do
    case Keyword.fetch(opts, :reference_pages) do
      {:ok, reference_pages} ->
        reference_pages

      :error ->
        ParityInventory.reference_pages(
          project_root: project_root,
          inventory_path: inventory_path
        )
    end
  end

  defp extract_upstream?(paths) do
    Enum.all?(paths.reference_pages, fn page ->
      File.exists?(Path.join(paths.reference_root, page))
    end)
  end

  defp ensure_extracted_upstream!(paths) do
    missing_specs =
      Enum.reject(paths.reference_pages, fn page ->
        File.exists?(reference_spec_path(paths, page))
      end)

    missing_contexts =
      Enum.reject(paths.reference_pages, fn page ->
        File.exists?(reference_context_path(paths, page))
      end)

    if missing_specs != [] or missing_contexts != [] do
      raise ArgumentError,
            "missing committed upstream fixtures; run mix notion.refresh with a local notion_docs checkout or restore priv/upstream/reference and priv/upstream/reference_context"
    end
  end

  defp reference_spec_path(paths, page) do
    page
    |> Path.basename(".md")
    |> Kernel.<>(".yaml")
    |> then(&Path.join(paths.reference_dir, &1))
  end

  defp reference_context_path(paths, page) do
    page
    |> Path.basename(".md")
    |> Kernel.<>(".json")
    |> then(&Path.join(paths.reference_context_dir, &1))
  end

  defp reference_context_files(paths) do
    paths.reference_context_dir
    |> Path.join("*.json")
    |> Path.wildcard()
    |> Enum.sort()
  end

  defp normalize_context_key(%{"method" => method, "path" => path}) when is_binary(path) do
    case method do
      "get" -> {:get, path}
      "put" -> {:put, path}
      "post" -> {:post, path}
      "delete" -> {:delete, path}
      "options" -> {:options, path}
      "head" -> {:head, path}
      "patch" -> {:patch, path}
      "trace" -> {:trace, path}
      _other -> nil
    end
  end

  defp normalize_context_key(_artifact), do: nil

  defp persist_artifacts!(state, paths) do
    compatibility = CompatibilityContract.load!(project_root: paths.project_root)

    summary = %{
      compatibility: compatibility,
      profile: Atom.to_string(profile()),
      operation_count: length(state.operations),
      schema_count: map_size(state.schemas),
      operation_modules:
        state.operations |> Enum.map(&module_name/1) |> Enum.uniq() |> Enum.sort(),
      operations: Enum.map(state.operations, &operation_summary/1),
      generated_files:
        state.files
        |> Enum.map(& &1.location)
        |> Enum.reject(&is_nil/1)
        |> Enum.sort()
    }

    summary
    |> ordered_json!()
    |> then(&File.write!(Path.join(paths.generated_artifact_dir, "manifest.json"), &1))

    snapshot = canonical_snapshot(state)

    File.write!(
      Path.join(paths.generated_artifact_dir, "open_api_state.snapshot.term"),
      :erlang.term_to_binary(snapshot)
    )

    File.write!(
      Path.join(paths.generated_artifact_dir, "docs_manifest.json"),
      ordered_json!(Map.put(state.docs_manifest, :compatibility, compatibility))
    )
  end

  defp operation_summary(operation) do
    %{
      function: Atom.to_string(operation.function_name),
      method: Atom.to_string(operation.request_method),
      module: module_name(operation),
      path: operation.request_path
    }
  end

  defp canonical_snapshot(state) do
    ref_labels =
      Enum.into(state.schemas, %{}, fn {ref, schema} ->
        {ref, schema_ref_label(schema, state.schemas)}
      end)

    [
      operations:
        state.operations
        |> Enum.map(&canonical_term(&1, ref_labels))
        |> Enum.sort(),
      schemas:
        state.schemas
        |> Enum.map(fn {ref, schema} ->
          {Map.fetch!(ref_labels, ref), canonical_term(schema, ref_labels)}
        end)
        |> Enum.sort()
    ]
  end

  defp canonical_term(%_{} = struct, ref_labels),
    do: struct |> Map.from_struct() |> canonical_term(ref_labels)

  defp canonical_term(map, ref_labels) when is_map(map) do
    map
    |> Enum.map(fn {key, value} ->
      {canonical_term(key, ref_labels), canonical_term(value, ref_labels)}
    end)
    |> Enum.sort()
  end

  defp canonical_term(list, ref_labels) when is_list(list),
    do: Enum.map(list, &canonical_term(&1, ref_labels))

  defp canonical_term(tuple, ref_labels) when is_tuple(tuple) do
    tuple
    |> Tuple.to_list()
    |> Enum.map(&canonical_term(&1, ref_labels))
    |> List.to_tuple()
  end

  defp canonical_term(reference, ref_labels) when is_reference(reference) do
    Map.get(ref_labels, reference, "<schema_ref>")
  end

  defp canonical_term(value, _ref_labels), do: value

  defp schema_ref_label(schema, schemas_by_ref) do
    [
      module_name(schema) || "anonymous_schema",
      Map.get(schema, :type_name) |> stable_atom() || "anonymous_type",
      Map.get(schema, :output_format) |> stable_atom() || "none",
      stable_schema_hash(schema, schemas_by_ref)
    ]
    |> Enum.join(".")
  end

  defp module_name(%{module_name: module_name})
       when is_atom(module_name) and not is_nil(module_name) do
    module_name
    |> Module.split()
    |> Enum.join(".")
  end

  defp module_name(_schema), do: nil

  defp stable_schema_hash(schema, schemas_by_ref) do
    schema
    |> stable_schema_term(schemas_by_ref)
    |> :erlang.term_to_binary()
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
    |> binary_part(0, 12)
  end

  defp stable_schema_term(schema, schemas_by_ref) do
    [
      module_name: module_name(schema),
      type_name: stable_atom(Map.get(schema, :type_name)),
      output_format: stable_atom(Map.get(schema, :output_format)),
      title: Map.get(schema, :title),
      description: Map.get(schema, :description),
      context:
        schema
        |> Map.get(:context, [])
        |> Enum.map(&stable_term(&1, schemas_by_ref))
        |> Enum.sort(),
      fields:
        schema
        |> Map.get(:fields, [])
        |> Enum.map(&stable_field_term(&1, schemas_by_ref))
        |> Enum.sort()
    ]
  end

  defp stable_field_term(field, schemas_by_ref) do
    [
      name: Map.get(field, :name),
      type: stable_term(Map.get(field, :type), schemas_by_ref),
      required: Map.get(field, :required),
      nullable: Map.get(field, :nullable),
      private: Map.get(field, :private),
      read_only: Map.get(field, :read_only),
      write_only: Map.get(field, :write_only)
    ]
  end

  defp stable_term(reference, schemas_by_ref) when is_reference(reference) do
    case Map.get(schemas_by_ref, reference) do
      nil ->
        {:schema_ref, "missing"}

      schema ->
        {:schema_ref, shallow_schema_term(schema)}
    end
  end

  defp stable_term(%_{} = struct, schemas_by_ref),
    do: struct |> Map.from_struct() |> stable_term(schemas_by_ref)

  defp stable_term(map, schemas_by_ref) when is_map(map) do
    map
    |> Enum.map(fn {key, value} ->
      {stable_term(key, schemas_by_ref), stable_term(value, schemas_by_ref)}
    end)
    |> Enum.sort()
  end

  defp stable_term(tuple, schemas_by_ref) when is_tuple(tuple) do
    tuple
    |> Tuple.to_list()
    |> Enum.map(&stable_term(&1, schemas_by_ref))
    |> List.to_tuple()
  end

  defp stable_term(list, schemas_by_ref) when is_list(list),
    do: Enum.map(list, &stable_term(&1, schemas_by_ref))

  defp stable_term(atom, _schemas_by_ref) when is_atom(atom), do: Atom.to_string(atom)
  defp stable_term(value, _schemas_by_ref), do: value

  defp shallow_schema_term(schema) do
    [
      module_name: module_name(schema),
      type_name: stable_atom(Map.get(schema, :type_name)),
      output_format: stable_atom(Map.get(schema, :output_format)),
      title: Map.get(schema, :title),
      description: Map.get(schema, :description),
      field_names:
        schema
        |> Map.get(:fields, [])
        |> Enum.map(&Map.get(&1, :name))
        |> Enum.sort()
    ]
  end

  defp stable_atom(nil), do: nil
  defp stable_atom(atom) when is_atom(atom), do: Atom.to_string(atom)

  defp ordered_json!(term) do
    term
    |> ordered_json_term()
    |> Jason.encode!(pretty: true)
  end

  defp ordered_json_term(%_{} = struct), do: struct |> Map.from_struct() |> ordered_json_term()

  defp ordered_json_term(map) when is_map(map) do
    map
    |> Enum.map(fn {key, value} -> {to_string(key), ordered_json_term(value)} end)
    |> Enum.sort_by(fn {key, _value} -> key end)
    |> OrderedObject.new()
  end

  defp ordered_json_term(tuple) when is_tuple(tuple) do
    tuple
    |> Tuple.to_list()
    |> Enum.map(&ordered_json_term/1)
  end

  defp ordered_json_term(list) when is_list(list), do: Enum.map(list, &ordered_json_term/1)
  defp ordered_json_term(value), do: value
end
