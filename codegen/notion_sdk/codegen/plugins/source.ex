defmodule NotionSDK.Codegen.Plugins.Source do
  @moduledoc false

  alias NotionSDK.Codegen
  alias PristineCodegen.Source.Dataset

  @openapi_profile :notion_sdk_codegen_source

  @spec load(module(), keyword()) :: Dataset.t()
  def load(_provider_module, opts) when is_list(opts) do
    paths = Codegen.paths(opts)
    source_contexts = Codegen.source_contexts(opts)
    state = processed_state(paths, opts)
    raw_schemas = state.schemas
    ref_to_type = ref_to_type(raw_schemas)
    schema_groups = schema_groups(raw_schemas)
    schemas = build_schemas(schema_groups, ref_to_type)
    schema_fields_by_key = Map.new(schemas, &{{&1.module, &1.type_name}, &1.fields})
    operations = Enum.sort_by(state.operations, &operation_sort_key/1)
    pagination_policies = build_pagination_policies(operations, ref_to_type, schema_fields_by_key)

    operations =
      Enum.map(operations, fn operation ->
        build_operation(
          operation,
          source_contexts,
          ref_to_type,
          schema_fields_by_key,
          pagination_policies
        )
      end)

    %Dataset{
      operations: operations,
      schemas: schemas,
      auth_policies: auth_policies(),
      pagination_policies: pagination_policies |> Map.values() |> Enum.sort_by(& &1.id),
      docs_inventory: docs_inventory(operations),
      fingerprints: fingerprints(paths)
    }
  end

  defp processed_state(_paths, opts) do
    :global.trans({__MODULE__, :openapi_profile}, fn ->
      Application.put_env(:oapi_generator, @openapi_profile, processor_config())

      files =
        Codegen.reference_spec_files(opts) ++
          Codegen.supplemental_spec_files(opts)

      @openapi_profile
      |> Atom.to_string()
      |> OpenAPI.Call.new(files)
      |> OpenAPI.State.new()
      |> OpenAPI.Reader.run()
      |> OpenAPI.Processor.run()
    end)
  end

  defp processor_config do
    [
      processor: NotionSDK.Codegen.OpenAPIProcessor,
      output: [base_module: NotionSDK]
    ]
  end

  defp build_schemas(schema_groups, ref_to_type) do
    schema_groups
    |> Enum.map(fn {_key, schemas} ->
      schema = choose_schema(schemas, ref_to_type)
      module = public_module(schema.module_name)

      %{
        id: schema_id(module, schema.type_name),
        module: module,
        type_name: schema.type_name,
        kind: schema_kind(schema),
        fields:
          schema.fields
          |> Enum.map(&normalize_field(&1, ref_to_type))
          |> Enum.sort_by(&normalized_field_sort_key/1),
        source_refs: []
      }
    end)
    |> Enum.sort_by(&{&1.module, &1.type_name, &1.id})
  end

  defp build_operation(
         operation,
         source_contexts,
         ref_to_type,
         schema_fields_by_key,
         pagination_policies
       ) do
    module = public_module(operation.module_name)
    operation_id = operation_id(operation)
    path_template = operation.request_path
    source_context = Map.get(source_contexts, {operation.request_method, path_template}, %{})
    {request_schema, content_type} = request_schema(operation.request_body, ref_to_type)

    %{
      id: operation_id,
      module: module,
      function: operation.function_name,
      method: operation.request_method,
      path_template: path_template,
      summary: source_context["title"] || operation.summary,
      description: source_context["lead"] || operation.description,
      path_params: normalize_params(operation.request_path_parameters),
      query_params: normalize_params(operation.request_query_parameters),
      header_params: normalize_header_params(operation.request_header_parameters),
      body: body_partition(request_schema, content_type, schema_fields_by_key),
      form_data: form_data_partition(request_schema, content_type, schema_fields_by_key),
      request_schema: request_schema,
      response_schemas: response_schemas(operation.responses, ref_to_type),
      auth_policy_id: auth_policy_id(operation),
      pagination_policy_id: pagination_policy_id(operation_id, pagination_policies),
      runtime_metadata: runtime_metadata(operation),
      docs_metadata: %{
        doc: operation_doc(source_context, operation),
        source_context: source_context,
        examples: source_context["code_samples"] || [],
        doc_url: source_context["source_url"]
      }
    }
  end

  defp schema_groups(raw_schemas) do
    raw_schemas
    |> Enum.group_by(fn {_ref, schema} -> {schema.module_name, schema.type_name} end)
    |> Enum.sort_by(fn {{module_name, type_name}, _schemas} -> {module_name, type_name} end)
  end

  defp choose_schema(schemas, ref_to_type) do
    schemas
    |> Enum.map(&elem(&1, 1))
    |> Enum.sort_by(&schema_sort_key(&1, ref_to_type))
    |> hd()
  end

  defp ref_to_type(raw_schemas) do
    Map.new(raw_schemas, fn {ref, schema} ->
      {ref, {public_module(schema.module_name), schema.type_name}}
    end)
  end

  defp normalize_field(field, ref_to_type) do
    %{
      name: field.name,
      type: convert_type(field.type, ref_to_type),
      required: field.required,
      default: field.default,
      description: field.description,
      deprecated: field.deprecated,
      example: field.example,
      examples: field.examples,
      external_docs: field.external_docs,
      extensions: field.extensions,
      read_only: field.read_only,
      write_only: field.write_only,
      nullable: field.nullable
    }
  end

  defp request_schema([], _ref_to_type), do: {nil, nil}

  defp request_schema(request_body, ref_to_type) when is_list(request_body) do
    {content_type, schema} =
      request_body
      |> Enum.sort_by(fn {content_type, _schema} -> content_type_sort_key(content_type) end)
      |> hd()

    {convert_type(schema, ref_to_type), content_type}
  end

  defp response_schemas(responses, ref_to_type) do
    responses
    |> Enum.map(fn {status, content} ->
      {status, preferred_content_schema(content, ref_to_type)}
    end)
    |> Enum.sort_by(fn {status, _schema} -> status end)
    |> Map.new()
  end

  defp body_partition(_request_schema, "multipart/form-data", _schema_fields_by_key),
    do: %{mode: :none}

  defp body_partition(nil, _content_type, _schema_fields_by_key), do: %{mode: :none}

  defp body_partition(request_schema, _content_type, schema_fields_by_key) do
    payload_partition(request_schema, schema_fields_by_key)
  end

  defp form_data_partition(request_schema, "multipart/form-data", schema_fields_by_key) do
    payload_partition(request_schema, schema_fields_by_key)
  end

  defp form_data_partition(_request_schema, _content_type, _schema_fields_by_key),
    do: %{mode: :none}

  defp payload_partition({module, type_name}, schema_fields_by_key) do
    case Map.get(schema_fields_by_key, {module, type_name}, []) do
      [] ->
        %{mode: :remaining}

      fields ->
        %{
          mode: :keys,
          keys: Enum.map(fields, &{&1.name, String.to_atom(&1.name)})
        }
    end
  end

  defp payload_partition(_request_schema, _schema_fields_by_key), do: %{mode: :remaining}

  defp normalize_params(params) do
    Enum.map(params, fn param ->
      %{
        name: param.name,
        key: String.to_atom(param.name),
        required: param.required
      }
    end)
  end

  defp normalize_header_params(params) do
    params
    |> Enum.reject(fn param ->
      param.name == "Notion-Version" and
        param.value_type == {:const, NotionSDK.Client.default_notion_version()}
    end)
    |> normalize_params()
  end

  defp auth_policy_id(operation) do
    security_schemes =
      operation.security
      |> Enum.flat_map(&Map.keys/1)
      |> Enum.uniq()
      |> Enum.sort()

    cond do
      "basicAuth" in security_schemes -> "oauth_basic_override"
      "bearerAuth" in security_schemes -> "notion_bearer_override"
      true -> nil
    end
  end

  defp auth_policies do
    [
      %{
        id: "notion_bearer_override",
        mode: :request_override_optional,
        security_schemes: ["bearerAuth"],
        override_source: %{key: "auth"},
        strategy_label: "Optional bearer override"
      },
      %{
        id: "oauth_basic_override",
        mode: :request_override,
        security_schemes: ["basicAuth"],
        override_source: %{
          mode: :keys,
          keys: [{"client_id", :client_id}, {"client_secret", :client_secret}]
        },
        strategy_label: "OAuth client credentials"
      }
    ]
  end

  defp build_pagination_policies(operations, ref_to_type, schema_fields_by_key) do
    operations
    |> Enum.reduce(%{}, fn operation, acc ->
      case pagination_policy(operation, ref_to_type, schema_fields_by_key) do
        nil -> acc
        policy -> Map.put(acc, policy.id, policy)
      end
    end)
  end

  defp pagination_policy(operation, ref_to_type, schema_fields_by_key) do
    schema =
      operation.responses
      |> Enum.find_value(fn
        {status, content} when status in [200, "200"] ->
          preferred_content_schema(content, ref_to_type)

        _other ->
          nil
      end)

    with {module, type_name} <- schema,
         fields when is_list(fields) <- Map.get(schema_fields_by_key, {module, type_name}),
         true <- Enum.any?(fields, &(&1.name == "next_cursor")),
         item_field when item_field in ["results", "templates"] <- pagination_items_field(fields),
         {cursor_param, cursor_location} <-
           cursor_request_mapping(operation, schema_fields_by_key, ref_to_type) do
      %{
        id: "#{operation_id(operation)}/cursor",
        strategy: :cursor,
        request_mapping: %{
          cursor_param: cursor_param,
          cursor_location: cursor_location
        },
        response_mapping: %{cursor_path: ["next_cursor"]},
        default_limit: nil,
        items_path: [item_field]
      }
    else
      _other -> nil
    end
  end

  defp pagination_items_field(fields) do
    Enum.find_value(["results", "templates"], fn name ->
      if Enum.any?(fields, &(&1.name == name)), do: name
    end)
  end

  defp cursor_request_mapping(operation, schema_fields_by_key, ref_to_type) do
    cond do
      Enum.any?(operation.request_query_parameters, &(&1.name == "start_cursor")) ->
        {"start_cursor", :query}

      true ->
        case request_schema(operation.request_body, ref_to_type) do
          {{module, type_name}, _content_type} ->
            fields = Map.get(schema_fields_by_key, {module, type_name}, [])

            if Enum.any?(fields, &(&1.name == "start_cursor")) do
              {"start_cursor", :body}
            else
              nil
            end

          _other ->
            nil
        end
    end
  end

  defp pagination_policy_id(operation_id, pagination_policies) do
    policy_id = "#{operation_id}/cursor"
    if Map.has_key?(pagination_policies, policy_id), do: policy_id
  end

  defp runtime_metadata(operation) do
    resource = runtime_resource(operation.request_path)

    %{
      resource: resource,
      retry_group: runtime_retry_group(operation.request_method, resource),
      circuit_breaker: runtime_circuit_breaker(resource),
      rate_limit_group: "notion.integration",
      telemetry_event: telemetry_event(operation),
      timeout_ms: nil
    }
  end

  defp runtime_resource(path) do
    cond do
      String.starts_with?(path, "/v1/oauth/") ->
        "oauth_control"

      String.ends_with?(path, "/send") and String.contains?(path, "/file_uploads/") ->
        "file_upload_send"

      String.starts_with?(path, "/v1/file_uploads") ->
        "file_upload_control"

      true ->
        "core_api"
    end
  end

  defp runtime_retry_group(_method, "oauth_control"), do: "notion.oauth_control"
  defp runtime_retry_group(_method, "file_upload_send"), do: "notion.file_upload_send"
  defp runtime_retry_group(method, _resource) when method in [:get, :head], do: "notion.read"
  defp runtime_retry_group(:delete, _resource), do: "notion.delete"
  defp runtime_retry_group(_method, _resource), do: "notion.write"

  defp runtime_circuit_breaker("file_upload_send"), do: "file_upload_send"
  defp runtime_circuit_breaker("oauth_control"), do: "oauth_control"
  defp runtime_circuit_breaker(_resource), do: "core_api"

  defp telemetry_event(operation) do
    [
      :notion_sdk,
      operation.module_name |> module_segment() |> Macro.underscore() |> String.to_atom(),
      operation.function_name
    ]
  end

  defp operation_doc(source_context, operation) do
    title =
      source_context["title"] || operation.summary || humanize_operation(operation.function_name)

    description = source_context["description"]

    code_samples =
      source_context
      |> Map.get("code_samples", [])
      |> render_code_samples()

    [
      title,
      "",
      "## Source Context",
      "",
      description,
      code_samples
    ]
    |> Enum.reject(&blank?/1)
    |> Enum.join("\n")
  end

  defp render_code_samples([]), do: nil

  defp render_code_samples(code_samples) do
    samples =
      Enum.map_join(code_samples, "\n\n", fn sample ->
        label = sample["label"] || "Example"
        language = sample["language"] || "text"
        source = sample["source"] || ""

        """
        #{label}
        ```#{language}
        #{source}
        ```
        """
      end)

    "## Code Samples\n\n" <> samples
  end

  defp docs_inventory(operations) do
    operation_inventory =
      operations
      |> Enum.sort_by(& &1.id)
      |> Enum.map(fn operation ->
        {operation.id,
         %{
           module: inspect(operation.module),
           function: Atom.to_string(operation.function),
           method: Atom.to_string(operation.method),
           path: operation.path_template,
           doc: operation.docs_metadata.doc,
           source_context: operation.docs_metadata.source_context
         }}
      end)
      |> Map.new()

    %{
      guides: [],
      examples: [],
      operations: operation_inventory
    }
  end

  defp fingerprints(paths) do
    source_paths =
      [
        Path.wildcard(Path.join(paths.reference_dir, "*.yaml")),
        Path.wildcard(Path.join(paths.reference_context_dir, "*.json")),
        Path.wildcard(Path.join(paths.supplemental_dir, "*.{json,yaml,yml}"))
      ]
      |> List.flatten()
      |> Enum.sort()

    %{
      sources: Enum.map(source_paths, &fingerprint_source/1),
      generation: %{
        compiler: "pristine_codegen",
        provider: "notion_sdk",
        source_strategy: "openapi_plus_source_plugin",
        version: application_version(:pristine_codegen)
      }
    }
  end

  defp fingerprint_source(path) do
    kind =
      cond do
        String.contains?(path, "/reference_context/") -> :reference_context
        String.contains?(path, "/supplemental/") -> :supplemental
        true -> :reference
      end

    %{
      path: path,
      kind: kind,
      sha256: sha256_file(path)
    }
  end

  defp sha256_file(path) do
    path
    |> File.read!()
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
  end

  defp application_version(app) do
    case Application.spec(app, :vsn) do
      nil -> "dev"
      vsn -> List.to_string(vsn)
    end
  end

  defp operation_id(operation) do
    "#{operation.module_name |> module_segment() |> Macro.underscore()}/#{operation.function_name}"
  end

  defp public_module(module_name) do
    Module.concat([NotionSDK, module_name])
  end

  defp module_segment(module_name) when is_atom(module_name) do
    module_name
    |> Module.split()
    |> List.last()
  end

  defp schema_id(module, type_name) do
    "#{inspect(module)}.#{type_name}"
  end

  defp schema_kind(schema) do
    case schema.output_format do
      :struct -> :object
      _other -> :typed_map
    end
  end

  defp convert_type(type, ref_to_type) when is_reference(type), do: Map.fetch!(ref_to_type, type)

  defp convert_type({:union, types}, ref_to_type) when is_list(types) do
    {:union,
     types
     |> Enum.map(&convert_type(&1, ref_to_type))
     |> Enum.sort_by(&type_signature/1)}
  end

  defp convert_type({:array, type}, ref_to_type), do: {:array, convert_type(type, ref_to_type)}
  defp convert_type([type], ref_to_type), do: [convert_type(type, ref_to_type)]
  defp convert_type(type, _ref_to_type), do: type

  defp schema_sort_key(schema, ref_to_type) do
    {
      output_format_rank(schema.output_format),
      -length(schema.fields),
      -Enum.count(schema.fields, & &1.required),
      schema.fields
      |> Enum.map(&field_sort_key(&1, ref_to_type))
      |> Enum.sort()
    }
  end

  defp output_format_rank(:struct), do: 0
  defp output_format_rank(_other), do: 1

  defp field_sort_key(field, ref_to_type) do
    {
      field.name,
      if(field.required, do: 0, else: 1),
      raw_type_signature(field.type, ref_to_type),
      stable_inspect(field.default),
      stable_inspect(field.nullable),
      stable_inspect(field.deprecated),
      stable_inspect(field.read_only),
      stable_inspect(field.write_only)
    }
  end

  defp normalized_field_sort_key(field) do
    {
      field.name,
      if(field.required, do: 0, else: 1),
      type_signature(field.type)
    }
  end

  defp preferred_content_schema(content, ref_to_type) when is_map(content) do
    content
    |> Enum.sort_by(fn {content_type, _schema} -> content_type_sort_key(content_type) end)
    |> hd()
    |> elem(1)
    |> convert_type(ref_to_type)
  end

  defp content_type_sort_key("application/json"), do: {0, "application/json"}
  defp content_type_sort_key("multipart/form-data"), do: {1, "multipart/form-data"}

  defp content_type_sort_key("application/x-www-form-urlencoded"),
    do: {2, "application/x-www-form-urlencoded"}

  defp content_type_sort_key(content_type), do: {3, to_string(content_type)}

  defp operation_sort_key(operation) do
    {
      inspect(operation.module_name),
      Atom.to_string(operation.function_name),
      Atom.to_string(operation.request_method),
      operation.request_path
    }
  end

  defp raw_type_signature(type, ref_to_type) when is_reference(type) do
    {:ref, Map.fetch!(ref_to_type, type)}
  end

  defp raw_type_signature({:union, types}, ref_to_type) when is_list(types) do
    {:union, types |> Enum.map(&raw_type_signature(&1, ref_to_type)) |> Enum.sort()}
  end

  defp raw_type_signature({:enum, values}, _ref_to_type) when is_list(values) do
    {:enum, Enum.sort(values)}
  end

  defp raw_type_signature({:array, type}, ref_to_type) do
    {:array, raw_type_signature(type, ref_to_type)}
  end

  defp raw_type_signature([type], ref_to_type), do: [raw_type_signature(type, ref_to_type)]
  defp raw_type_signature(type, _ref_to_type), do: type

  defp type_signature({:union, types}) when is_list(types) do
    {:union, types |> Enum.map(&type_signature/1) |> Enum.sort()}
  end

  defp type_signature({:enum, values}) when is_list(values) do
    {:enum, Enum.sort(values)}
  end

  defp type_signature({:array, type}), do: {:array, type_signature(type)}
  defp type_signature([type]), do: [type_signature(type)]
  defp type_signature(type), do: type

  defp stable_inspect(value) do
    inspect(value, limit: :infinity, printable_limit: :infinity)
  end

  defp humanize_operation(function_name) do
    function_name
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end

  defp blank?(value), do: value in [nil, ""]
end
