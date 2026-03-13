defmodule NotionSDK.Codegen.Renderer do
  @moduledoc """
  Renderer overrides that emit `NotionSDK.<Resource>.<verb>(client, params)` functions.
  """

  use OpenAPI.Renderer

  alias OpenAPI.Processor.Operation
  alias OpenAPI.Processor.Operation.Param
  alias OpenAPI.Processor.Schema, as: ProcessedSchema
  alias OpenAPI.Renderer.File
  alias OpenAPI.Renderer.State
  alias OpenAPI.Renderer.Util
  alias Pristine.OpenAPI.DocComposer
  alias Pristine.OpenAPI.SchemaMaterialization

  @multipart_content_type "multipart/form-data"

  @impl OpenAPI.Renderer
  def render(state, file) do
    OpenAPI.Renderer.render(state, file)
  end

  @impl OpenAPI.Renderer
  def format(state, file) do
    state
    |> OpenAPI.Renderer.format(file)
    |> Pristine.OpenAPI.Renderer.rewrite_nested_module_aliases_in_source()
  end

  @impl OpenAPI.Renderer
  def render_default_client(_state, _file), do: nil

  @impl OpenAPI.Renderer
  def render_moduledoc(state, file) do
    moduledoc = DocComposer.module_doc(file, source_contexts: source_contexts(state))
    quote do: @moduledoc(unquote(moduledoc))
  end

  @impl OpenAPI.Renderer
  def render_operations(_state, %File{operations: []}), do: []

  @impl OpenAPI.Renderer
  def render_operations(state, %File{module: OAuth} = file) do
    Util.clean_list([
      render_oauth_helpers(state),
      OpenAPI.Renderer.render_operations(state, file)
    ])
  end

  def render_operations(state, file) do
    OpenAPI.Renderer.render_operations(state, file)
  end

  @impl OpenAPI.Renderer
  def render_operation_doc(state, operation) do
    docstring = DocComposer.operation_doc(operation, source_contexts: source_contexts(state))
    quote do: @doc(unquote(docstring))
  end

  @impl OpenAPI.Renderer
  def render_schema(state, file) do
    %State{implementation: implementation} = state
    %{module: module, operations: operations, schemas: schemas} = file

    non_operation_schemas =
      schemas
      |> Enum.filter(&(&1.output_format == :struct))
      |> Enum.group_by(&{&1.module_name, &1.type_name})
      |> Enum.map(fn {_module_and_type, grouped} -> merge_schema_group(grouped, state) end)
      |> List.flatten()
      |> Enum.sort_by(& &1.type_name)

    output_schemas =
      schemas
      |> Enum.filter(fn
        %ProcessedSchema{output_format: :struct} ->
          true

        %ProcessedSchema{context: [{:request, ^module, _, _}], output_format: :typed_map} ->
          true

        %ProcessedSchema{context: [{:response, ^module, _, _, _}], output_format: :typed_map} ->
          true

        %ProcessedSchema{module_name: ^module, output_format: :typed_map, type_name: :t} ->
          true

        %ProcessedSchema{context: [{:field, parent_ref, _}], output_format: :typed_map} ->
          parent_is_output_schema?(parent_ref, module, state)

        _else ->
          false
      end)
      |> Enum.group_by(&{&1.module_name, &1.type_name})
      |> Enum.map(fn {_module_and_type, grouped} -> merge_schema_group(grouped, state) end)
      |> List.flatten()
      |> Enum.sort_by(& &1.type_name)

    types =
      cond do
        output_schemas == [] ->
          []

        operations == [] ->
          implementation.render_schema_types(state, output_schemas)

        true ->
          implementation.render_schema_types(state, non_operation_schemas)
      end

    struct =
      if non_operation_schemas == [] do
        []
      else
        implementation.render_schema_struct(state, non_operation_schemas)
      end

    field_function =
      if length(output_schemas) > 0 do
        implementation.render_schema_field_function(state, output_schemas)
      else
        []
      end

    Util.clean_list([types, struct, field_function])
  end

  @impl OpenAPI.Renderer
  def render_schema_field_function(_state, []), do: []

  def render_schema_field_function(state, schemas) do
    default_type =
      schemas
      |> Enum.map(& &1.type_name)
      |> Enum.sort()
      |> then(fn [first | _] = types -> Enum.find(types, first, &(&1 == :t)) end)

    default =
      render_field_function(state, schemas, default_type)

    runtime_helpers = [
      render_openapi_field_function(state, schemas, default_type),
      render_schema_function(default_type, schemas),
      render_decode_function(default_type)
    ]

    Util.clean_list([default, runtime_helpers])
  end

  @impl OpenAPI.Renderer
  def render_operation_spec(state, operation) do
    %Operation{function_name: name, responses: responses} = operation

    client = quote(do: client :: NotionSDK.Client.t())
    params = quote(do: params :: map())
    return_type = render_return_type(state, responses)

    case config(state)[:types][:specs] do
      false ->
        []

      :callback ->
        quote do
          @callback unquote(name)(unquote(client), unquote(params)) :: unquote(return_type)
        end

      :callback_comprehensive ->
        [
          quote do
            @callback unquote(name)(unquote(client)) :: unquote(return_type)
          end,
          quote do
            @callback unquote(name)(unquote(client), unquote(params)) :: unquote(return_type)
          end
        ]

      :spec_comprehensive ->
        [
          quote do
            @spec unquote(name)(unquote(client)) :: unquote(return_type)
          end,
          quote do
            @spec unquote(name)(unquote(client), unquote(params)) :: unquote(return_type)
          end
        ]

      _default ->
        quote do
          @spec unquote(name)(unquote(client), unquote(params)) :: unquote(return_type)
        end
    end
  end

  @impl OpenAPI.Renderer
  def render_operation_function(state, operation) do
    %Operation{
      function_name: function_name,
      module_name: module_name,
      request_body: request_body,
      request_method: request_method,
      request_path: request_path,
      responses: responses
    } = operation

    partition_spec = request_partition_spec(state, operation)
    oauth_basic? = oauth_basic_operation?(operation)

    module_name =
      Module.concat([
        config(state)[:base_module],
        module_name
      ])

    auth =
      if oauth_basic? do
        quote(do: NotionSDK.Client.oauth_request_auth(params))
      else
        quote(do: partition.auth)
      end

    partition_params =
      if oauth_basic? do
        quote(do: NotionSDK.Client.drop_oauth_credentials(params))
      else
        quote(do: params)
      end

    request =
      [
        quote(do: {:args, params}),
        quote(do: {:call, {unquote(module_name), unquote(function_name)}}),
        quote(do: {:path_template, unquote(request_path)}),
        quote(do: {:url, render_path(unquote(request_path), partition.path_params)}),
        quote(do: {:method, unquote(request_method)}),
        quote(do: {:path_params, partition.path_params}),
        quote(do: {:query, partition.query}),
        quote(do: {:body, partition.body}),
        quote(do: {:form_data, partition.form_data}),
        quote(do: {:auth, unquote(auth)}),
        render_security_info(state, operation),
        render_request_info(state, request_body),
        render_response_info(state, responses)
      ]
      |> Enum.reject(&is_nil/1)

    quote do
      def unquote(function_name)(client, params \\ %{}) when is_map(params) do
        partition = partition(unquote(partition_params), unquote(Macro.escape(partition_spec)))

        NotionSDK.Client.request(client, %{
          unquote_splicing(request)
        })
      end
    end
  end

  defp request_partition_spec(state, operation) do
    %Operation{
      request_body: request_body,
      request_path_parameters: path_params,
      request_query_parameters: query_params
    } = operation

    {multipart_request_body, standard_request_body} =
      Enum.split_with(request_body, fn {content_type, _type} ->
        String.starts_with?(content_type, @multipart_content_type)
      end)

    %{
      auth: {"auth", :auth},
      path: key_specs(path_params),
      query: key_specs(query_params),
      body: payload_spec(state, standard_request_body, {"body", :body}),
      form_data: payload_spec(state, multipart_request_body, {"form_data", :form_data})
    }
  end

  defp payload_spec(_state, [], _fallback_key), do: %{mode: :none}

  defp payload_spec(state, request_body, fallback_key) do
    keys =
      request_body
      |> Enum.reduce(MapSet.new(), fn {_content_type, type}, names ->
        MapSet.union(names, request_field_names(state, type))
      end)
      |> MapSet.to_list()
      |> Enum.sort()

    if keys == [] do
      %{mode: :key, key: fallback_key}
    else
      %{mode: :keys, keys: Enum.map(keys, &{&1, String.to_atom(&1)})}
    end
  end

  defp merge_schema_group(grouped, state) do
    grouped
    |> Enum.sort_by(&schema_group_sort_key(&1, state.schemas))
    |> Enum.reduce(&ProcessedSchema.merge/2)
  end

  defp schema_group_sort_key(schema, schemas_by_ref) do
    stable_schema_term(schema, schemas_by_ref)
  end

  defp key_specs(params) do
    Enum.map(params, fn %Param{name: name} -> {name, String.to_atom(name)} end)
  end

  defp request_field_names(state, {:union, types}) do
    Enum.reduce(types, MapSet.new(), fn type, names ->
      MapSet.union(names, request_field_names(state, type))
    end)
  end

  defp request_field_names(state, ref) when is_reference(ref) do
    case Map.get(state.schemas, ref) do
      %{fields: fields} ->
        Enum.reduce(fields, MapSet.new(), fn field, names -> MapSet.put(names, field.name) end)

      nil ->
        MapSet.new()
    end
  end

  defp request_field_names(_state, _type), do: MapSet.new()

  defp stable_schema_term(schema, schemas_by_ref) do
    [
      module_name: stable_module_name(Map.get(schema, :module_name)),
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
      module_name: stable_module_name(Map.get(schema, :module_name)),
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

  defp stable_module_name(nil), do: nil
  defp stable_module_name(module_name) when is_atom(module_name), do: inspect(module_name)

  defp stable_atom(nil), do: nil
  defp stable_atom(atom) when is_atom(atom), do: Atom.to_string(atom)

  defp render_request_info(_state, []), do: nil

  defp render_request_info(state, request_body) do
    items =
      Enum.map(request_body, fn {content_type, type} ->
        readable = readable_type(state, type)

        quote do
          {unquote(content_type), unquote(readable)}
        end
      end)

    quote do
      {:request, unquote(items)}
    end
  end

  defp render_security_info(
         state,
         %Operation{request_method: method, request_path: path} = operation
       ) do
    case security_for_operation(state, operation, method, path) do
      nil -> nil
      security -> quote(do: {:security, unquote(Macro.escape(security))})
    end
  end

  defp security_for_operation(state, operation, method, path) do
    if is_nil(Map.get(operation, :security)) do
      state
      |> config()
      |> Keyword.get(:security_metadata, %{})
      |> Map.get(:operations, %{})
      |> Map.get({method, path})
    else
      Map.get(operation, :security)
    end
  end

  defp render_response_info(_state, []), do: nil

  defp render_response_info(state, responses) do
    items =
      responses
      |> Enum.sort_by(fn {status_or_default, _schemas} -> status_or_default end)
      |> Enum.map(fn {status_or_default, schemas} ->
        type = readable_type(state, {:union, Map.values(schemas)})

        quote do
          {unquote(status_or_default), unquote(type)}
        end
      end)

    quote do
      {:response, unquote(items)}
    end
  end

  defp render_return_type(_state, []), do: quote(do: :ok)

  defp render_oauth_helpers(state) do
    base_module = config(state)[:base_module]
    client_module = Module.concat([base_module, Client])

    quote do
      @oauth_client_opts [
        :base_url,
        :finch,
        :log_level,
        :logger,
        :notion_version,
        :retry,
        :timeout_ms,
        :transport,
        :transport_opts,
        :typed_responses,
        :user_agent
      ]

      @spec provider() :: Pristine.OAuth2.Provider.t()
      def provider do
        Pristine.OAuth2.Provider.new(
          name: "notion",
          flow: :authorization_code,
          site: "https://api.notion.com",
          authorize_url: "/v1/oauth/authorize",
          token_url: "/v1/oauth/token",
          revocation_url: "/v1/oauth/revoke",
          introspection_url: "/v1/oauth/introspect",
          client_auth_method: :basic,
          token_method: :post,
          token_content_type: "application/json"
        )
      end

      @spec authorization_request(keyword()) ::
              {:ok, Pristine.OAuth2.AuthorizationRequest.t()}
              | {:error, Pristine.OAuth2.Error.t()}
      def authorization_request(opts \\ []) when is_list(opts) do
        with {:ok, authorization_opts} <- authorization_opts(opts) do
          provider()
          |> Pristine.OAuth2.authorization_request(authorization_opts)
        end
      end

      @spec authorize_url(keyword()) :: {:ok, String.t()} | {:error, Pristine.OAuth2.Error.t()}
      def authorize_url(opts \\ []) when is_list(opts) do
        with {:ok, authorization_opts} <- authorization_opts(opts) do
          provider()
          |> Pristine.OAuth2.authorize_url(authorization_opts)
        end
      end

      @spec exchange_code(String.t(), keyword()) ::
              {:ok, Pristine.OAuth2.Token.t()} | {:error, Pristine.OAuth2.Error.t()}
      def exchange_code(code, opts \\ []) when is_binary(code) and is_list(opts) do
        provider()
        |> Pristine.OAuth2.exchange_code(code, oauth_runtime_opts(opts))
      end

      @spec refresh_token(String.t(), keyword()) ::
              {:ok, Pristine.OAuth2.Token.t()} | {:error, Pristine.OAuth2.Error.t()}
      def refresh_token(refresh_token, opts \\ [])
          when is_binary(refresh_token) and is_list(opts) do
        provider()
        |> Pristine.OAuth2.refresh_token(refresh_token, oauth_runtime_opts(opts))
      end

      defp authorization_opts(opts) do
        params =
          opts
          |> Keyword.get(:params, [])
          |> normalize_keyword()
          |> maybe_put_owner(Keyword.get(opts, :owner))

        case Keyword.get(opts, :redirect_uri) do
          redirect_uri when is_binary(redirect_uri) and redirect_uri != "" ->
            {:ok,
             opts
             |> Keyword.put(:params, params)
             |> Keyword.put(:redirect_uri, redirect_uri)}

          _other ->
            {:error, Pristine.OAuth2.Error.new(:missing_redirect_uri, provider: provider().name)}
        end
      end

      defp oauth_runtime_opts(opts) do
        client = Keyword.get(opts, :client) || unquote(client_module).new(client_opts(opts))

        token_params =
          []
          |> maybe_put(:external_account, Keyword.get(opts, :external_account))
          |> Keyword.merge(opts |> Keyword.get(:token_params, []) |> normalize_keyword())

        []
        |> Keyword.put(:context, client.context)
        |> maybe_put(:client_id, Keyword.get(opts, :client_id))
        |> maybe_put(:client_secret, Keyword.get(opts, :client_secret))
        |> maybe_put(:redirect_uri, Keyword.get(opts, :redirect_uri))
        |> maybe_put(:token_params, token_params)
      end

      defp client_opts(opts) do
        Keyword.take(opts, @oauth_client_opts)
      end

      defp maybe_put_owner(params, value) when is_binary(value) and value != "" do
        Keyword.put(params, :owner, value)
      end

      defp maybe_put_owner(params, _value) do
        Keyword.put_new(params, :owner, "user")
      end

      defp maybe_put(opts, _key, nil), do: opts
      defp maybe_put(opts, _key, []), do: opts
      defp maybe_put(opts, key, value), do: Keyword.put(opts, key, value)

      defp normalize_keyword(value) when is_list(value), do: value
      defp normalize_keyword(value) when is_map(value), do: Enum.into(value, [])
      defp normalize_keyword(_value), do: []
    end
  end

  defp render_return_type(state, responses) do
    %State{implementation: implementation} = state

    {success, error} =
      responses
      |> Enum.reject(fn {_status, schemas} -> map_size(schemas) == 0 end)
      |> Enum.reject(fn {status, _schemas} -> status >= 300 and status < 400 end)
      |> Enum.split_with(fn {status, _schemas} -> status < 300 end)

    ok =
      if success == [] do
        quote(do: :ok)
      else
        type =
          success
          |> Enum.flat_map(fn {_status, schemas} -> Map.values(schemas) end)
          |> then(&implementation.render_type(state, {:union, &1}))

        quote(do: {:ok, unquote(type)})
      end

    error =
      case config(state)[:types][:error] do
        nil ->
          render_error_union(state, error)

        error_type ->
          quote(do: {:error, unquote(render_configured_type(state, error_type))})
      end

    {:|, [], [ok, error]}
  end

  defp render_error_union(_state, []), do: quote(do: :error)

  defp render_error_union(state, error) do
    %State{implementation: implementation} = state

    type =
      error
      |> Enum.flat_map(fn {_status, schemas} -> Map.values(schemas) end)
      |> then(&implementation.render_type(state, {:union, &1}))

    quote(do: {:error, unquote(type)})
  end

  defp render_configured_type(state, {module, type}) when is_atom(module) and is_atom(type) do
    %State{implementation: implementation} = state
    implementation.render_type(state, {module, type})
  end

  defp render_configured_type(_state, module) when is_atom(module) do
    quote(do: unquote(module).t())
  end

  defp render_field_function(state, schemas, default_type) do
    docstring =
      quote do
        @doc false
      end

    typespec =
      quote do
        @spec __fields__(atom) :: keyword
      end

    header =
      quote do
        def __fields__(type \\ unquote(default_type))
      end

    clauses =
      schemas
      |> Enum.sort_by(& &1.type_name)
      |> Enum.map(fn %ProcessedSchema{fields: fields, type_name: type_name} ->
        rendered_fields =
          fields
          |> Enum.reject(& &1.private)
          |> Enum.sort_by(& &1.name)
          |> Enum.map(fn field ->
            quote do
              {unquote(String.to_atom(field.name)), unquote(readable_type(state, field.type))}
            end
          end)

        quote do
          def __fields__(unquote(type_name)) do
            unquote(rendered_fields)
          end
        end
      end)

    Util.clean_list([docstring, typespec, header, clauses])
  end

  defp render_openapi_field_function(state, schemas, default_type) do
    typespec =
      quote do
        @doc false
        @spec __openapi_fields__(atom) :: [map()]
      end

    header =
      quote do
        def __openapi_fields__(type \\ unquote(default_type))
      end

    clauses =
      Enum.map(schemas, fn %ProcessedSchema{fields: fields, type_name: type_name} ->
        openapi_fields =
          fields
          |> Enum.reject(& &1.private)
          |> Enum.sort_by(& &1.name)
          |> Enum.map(&runtime_field_metadata(&1, readable_type(state, &1.type)))

        quote do
          def __openapi_fields__(unquote(type_name)) do
            unquote(Macro.escape(openapi_fields))
          end
        end
      end)

    Util.clean_list([typespec, header, clauses])
  end

  defp runtime_field_metadata(field, rendered_type) do
    %{
      default: runtime_scalar_value(Map.get(field, :default)),
      deprecated: Map.get(field, :deprecated, false),
      description: runtime_scalar_value(Map.get(field, :description)),
      example: runtime_scalar_value(Map.get(field, :example)),
      examples: runtime_shallow_map(Map.get(field, :examples)),
      extensions: runtime_shallow_map(Map.get(field, :extensions)),
      external_docs: runtime_external_docs(Map.get(field, :external_docs)),
      name: Map.get(field, :name),
      nullable: Map.get(field, :nullable, false),
      read_only: Map.get(field, :read_only, false),
      required: Map.get(field, :required, false),
      type: rendered_type,
      write_only: Map.get(field, :write_only, false)
    }
  end

  defp runtime_external_docs(nil), do: nil

  defp runtime_external_docs(external_docs) when is_map(external_docs) do
    %{
      description: Map.get(external_docs, :description) || Map.get(external_docs, "description"),
      url: Map.get(external_docs, :url) || Map.get(external_docs, "url")
    }
  end

  defp runtime_external_docs(external_docs), do: inspect(external_docs)

  defp runtime_scalar_value(nil), do: nil
  defp runtime_scalar_value(value) when is_binary(value), do: value
  defp runtime_scalar_value(value) when is_boolean(value), do: value
  defp runtime_scalar_value(value) when is_number(value), do: value
  defp runtime_scalar_value(value) when is_atom(value), do: value
  defp runtime_scalar_value(_value), do: nil

  defp runtime_shallow_map(nil), do: nil

  defp runtime_shallow_map(value) when is_map(value) do
    Enum.into(value, %{}, fn {key, nested_value} ->
      {to_string(key), runtime_scalar_value(nested_value)}
    end)
  end

  defp runtime_shallow_map(_value), do: nil

  defp render_schema_function(default_type, schemas) do
    typespec =
      quote do
        @doc false
        @spec __schema__(atom) :: Sinter.Schema.t()
      end

    header =
      quote do
        def __schema__(type \\ unquote(default_type))
      end

    clauses =
      Enum.map(schemas, fn %ProcessedSchema{type_name: type_name} ->
        quote do
          def __schema__(unquote(type_name)) do
            OpenAPIRuntime.build_schema(__openapi_fields__(unquote(type_name)))
          end
        end
      end)

    Util.clean_list([typespec, header, clauses])
  end

  defp render_decode_function(default_type) do
    quote do
      @doc false
      @spec decode(term(), atom) :: {:ok, term()} | {:error, term()}
      def decode(data, type \\ unquote(default_type))

      def decode(data, type) do
        OpenAPIRuntime.decode_module_type(__MODULE__, type, data)
      end
    end
  end

  defp parent_is_output_schema?(parent_ref, module, state) do
    case Map.get(state.schemas, parent_ref) do
      %ProcessedSchema{context: [{:request, ^module, _, _}], output_format: :typed_map} ->
        true

      %ProcessedSchema{context: [{:response, ^module, _, _, _}], output_format: :typed_map} ->
        true

      %ProcessedSchema{module_name: ^module, output_format: :typed_map, type_name: :t} ->
        true

      %ProcessedSchema{context: [{:field, next_parent_ref, _}], output_format: :typed_map} ->
        parent_is_output_schema?(next_parent_ref, module, state)

      _else ->
        SchemaMaterialization.materialized_typed_map?(
          Map.get(state.schemas, parent_ref),
          module,
          state.schemas
        )
    end
  end

  defp readable_type(state, {:array, type}) do
    [readable_type(state, type)]
  end

  defp readable_type(state, {:union, types}) do
    types =
      types
      |> Enum.flat_map(fn
        {:union, nested} -> nested
        other -> [other]
      end)
      |> Enum.map(&readable_type(state, &1))
      |> Enum.uniq()

    case types do
      [] -> :null
      [type] -> type
      many -> {:union, many}
    end
  end

  defp readable_type(state, {:nullable, type}) do
    {:nullable, readable_type(state, type)}
  end

  defp readable_type(state, {:tuple, types}) do
    {:tuple, Enum.map(types, &readable_type(state, &1))}
  end

  defp readable_type(state, {:map, key_type, value_type}) do
    {:map, readable_type(state, key_type), readable_type(state, value_type)}
  end

  defp readable_type(state, ref) when is_reference(ref) do
    case Map.get(state.schemas, ref) do
      %ProcessedSchema{module_name: nil, type_name: type} ->
        type

      %ProcessedSchema{module_name: schema_module, type_name: type} ->
        module =
          Module.concat([
            config(state)[:base_module],
            schema_module
          ])

        {module, type}

      nil ->
        :map
    end
  end

  defp readable_type(_state, type), do: type

  defp oauth_basic_operation?(%Operation{request_path: path}) when is_binary(path) do
    String.starts_with?(path, "/v1/oauth/")
  end

  defp source_contexts(state) do
    config(state)[:source_contexts] || %{}
  end

  defp config(%State{profile: profile}) do
    Application.get_env(:oapi_generator, profile, [])
    |> Keyword.get(:output, [])
  end
end
