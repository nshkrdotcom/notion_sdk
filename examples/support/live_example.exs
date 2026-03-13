defmodule NotionSDK.Examples.Live do
  @moduledoc false

  alias NotionSDK.Blocks
  alias NotionSDK.Client
  alias NotionSDK.Comments
  alias NotionSDK.Databases
  alias NotionSDK.FileUploads
  alias NotionSDK.Helpers
  alias NotionSDK.OAuthTokenFile
  alias NotionSDK.Pages
  alias NotionSDK.Search
  alias NotionSDK.Users
  alias Pristine.Adapters.TokenSource.File, as: FileTokenSource

  @default_page_size 10

  def start! do
    Mix.Task.run("app.start")
  end

  def client! do
    start!()

    Client.new(
      fetch_env!("NOTION_TOKEN"),
      client_opts_from_env()
    )
  end

  def oauth_client! do
    start!()
    Client.new(client_opts_from_env())
  end

  def oauth_bearer_client! do
    start!()

    Client.new(
      Keyword.put(client_opts_from_env(), :oauth2,
        token_source: {FileTokenSource, path: oauth_token_path()}
      )
    )
  end

  def banner!(title) when is_binary(title) do
    line = String.duplicate("=", String.length(title))
    IO.puts(line)
    IO.puts(title)
    IO.puts(line)
  end

  def ok!({:ok, value}, _label), do: value

  def ok!({:error, error}, label) do
    raise """
    #{label} failed
    #{format_error(error)}
    """
  end

  def ok!(other, label) do
    raise "#{label} returned an unexpected result: #{inspect(other, pretty: true, limit: :infinity)}"
  end

  def fetch_env!(name) when is_binary(name) do
    case get_env(name) do
      nil ->
        raise """
        missing required environment variable #{name}
        """

      value ->
        value
    end
  end

  def fetch_https_env!(name) when is_binary(name) do
    value = fetch_env!(name)

    case URI.parse(value) do
      %URI{scheme: "https", host: host} when is_binary(host) and host != "" ->
        value

      _ ->
        raise "#{name} must be an https URL, got: #{inspect(value)}"
    end
  end

  def notion_id_env!(name) when is_binary(name) do
    name
    |> fetch_env!()
    |> normalize_notion_id!(name)
  end

  def page_id! do
    notion_id_env!("NOTION_EXAMPLE_PAGE_ID")
  end

  def database_id!(client) do
    case get_env("NOTION_EXAMPLE_DATABASE_ID") do
      nil ->
        page = retrieve_page!(client)
        parent = fetch_map!(page, "parent", "page.parent")

        cond do
          is_binary(parent["database_id"]) ->
            normalize_notion_id!(parent["database_id"], "page.parent.database_id")

          true ->
            raise """
            unable to derive a database id from the page parent
            provide NOTION_EXAMPLE_DATABASE_ID or use a page that belongs to a database-backed data source
            """
        end

      value ->
        normalize_notion_id!(value, "NOTION_EXAMPLE_DATABASE_ID")
    end
  end

  def data_source_id!(client) do
    case get_env("NOTION_EXAMPLE_DATA_SOURCE_ID") do
      nil ->
        page = retrieve_page!(client)
        parent = fetch_map!(page, "parent", "page.parent")

        cond do
          is_binary(parent["data_source_id"]) ->
            normalize_notion_id!(parent["data_source_id"], "page.parent.data_source_id")

          true ->
            database_id = database_id!(client)

            database =
              Databases.retrieve(client, %{"database_id" => database_id})
              |> ok!("NotionSDK.Databases.retrieve/2")

            case Map.get(database, "data_sources", []) do
              [%{"id" => id} | _rest] when is_binary(id) ->
                normalize_notion_id!(id, "database.data_sources[0].id")

              _ ->
                raise """
                unable to derive a data source id from the database response
                provide NOTION_EXAMPLE_DATA_SOURCE_ID or use a database that exposes at least one data source
                """
            end
        end

      value ->
        normalize_notion_id!(value, "NOTION_EXAMPLE_DATA_SOURCE_ID")
    end
  end

  def block_id!(client) do
    case get_env("NOTION_EXAMPLE_BLOCK_ID") do
      nil ->
        page_id = page_id!()

        children =
          Blocks.list_children(client, %{"block_id" => page_id, "page_size" => 1})
          |> ok!("NotionSDK.Blocks.list_children/2")

        case Map.get(children, "results", []) do
          [%{"id" => id} | _rest] when is_binary(id) ->
            normalize_notion_id!(id, "first child block id")

          _ ->
            raise """
            the page has no child blocks to retrieve
            add at least one block to the page referenced by NOTION_EXAMPLE_PAGE_ID or provide NOTION_EXAMPLE_BLOCK_ID
            """
        end

      value ->
        normalize_notion_id!(value, "NOTION_EXAMPLE_BLOCK_ID")
    end
  end

  def page_property!(client) do
    page = retrieve_page!(client)
    properties = fetch_map!(page, "properties", "page.properties")

    case get_env("NOTION_EXAMPLE_PROPERTY_ID") do
      property_id when is_binary(property_id) and property_id != "" ->
        %{
          id: property_id,
          name:
            property_name_for_id(properties, property_id) ||
              "(resolved from NOTION_EXAMPLE_PROPERTY_ID)"
        }

      _ ->
        property_name = get_env("NOTION_EXAMPLE_PROPERTY_NAME")

        {name, definition} =
          if is_binary(property_name) and property_name != "" do
            Enum.find(properties, fn {candidate_name, _definition} ->
              candidate_name == property_name
            end) ||
              raise "page property #{inspect(property_name)} was not found on NOTION_EXAMPLE_PAGE_ID"
          else
            properties
            |> Enum.sort_by(&elem(&1, 0))
            |> List.first() ||
              raise "page.properties is empty and no NOTION_EXAMPLE_PROPERTY_ID or NOTION_EXAMPLE_PROPERTY_NAME was provided"
          end

        %{
          id:
            Map.get(definition, "id") ||
              raise("page property #{inspect(name)} does not expose an id"),
          name: name
        }
    end
  end

  def file_upload_id!(client) do
    case get_env("NOTION_EXAMPLE_FILE_UPLOAD_ID") do
      nil ->
        uploads =
          FileUploads.list(client, %{"page_size" => 1})
          |> ok!("NotionSDK.FileUploads.list/2")

        case Map.get(uploads, "results", []) do
          [%{"id" => id} | _rest] when is_binary(id) ->
            normalize_notion_id!(id, "first file upload id")

          _ ->
            raise """
            there are no file uploads available to retrieve
            run examples/13_create_external_file_upload.exs or examples/15_upload_small_text_file.exs first,
            or provide NOTION_EXAMPLE_FILE_UPLOAD_ID
            """
        end

      value ->
        normalize_notion_id!(value, "NOTION_EXAMPLE_FILE_UPLOAD_ID")
    end
  end

  def oauth_credentials! do
    %{
      "client_id" => fetch_env!("NOTION_OAUTH_CLIENT_ID"),
      "client_secret" => fetch_env!("NOTION_OAUTH_CLIENT_SECRET")
    }
  end

  def oauth_token_path do
    OAuthTokenFile.resolve_env_or_default(get_env("NOTION_OAUTH_TOKEN_PATH"))
  end

  def oauth_token! do
    case get_env("NOTION_OAUTH_ACCESS_TOKEN") do
      nil ->
        oauth_token_from_file!()

      value ->
        value
    end
  end

  def retrieve_page!(client) do
    Pages.retrieve(client, %{"page_id" => page_id!()})
    |> ok!("NotionSDK.Pages.retrieve/2")
  end

  def smoke!(client) do
    self = Users.get_self(client) |> ok!("NotionSDK.Users.get_self/1")

    search =
      Search.search(client, %{
        "page_size" => default_page_size(),
        "query" => get_env("NOTION_EXAMPLE_SEARCH_QUERY") || ""
      })
      |> ok!("NotionSDK.Search.search/2")

    users =
      Users.list(client, %{"page_size" => default_page_size()})
      |> ok!("NotionSDK.Users.list/2")

    %{self: self, search: search, users: users}
  end

  def default_page_size, do: @default_page_size

  def print_json!(label, value) when is_binary(label) do
    IO.puts("#{label}:")
    IO.puts(Jason.encode_to_iodata!(value, pretty: true))
  end

  def print_list_summary!(label, list, fun)
      when is_binary(label) and is_list(list) and is_function(fun, 1) do
    summary = Enum.map(list, fun)
    print_json!(label, summary)
  end

  def plain_text(parts) when is_list(parts) do
    parts
    |> Enum.map_join("", fn
      %{"plain_text" => text} when is_binary(text) -> text
      %{"text" => %{"content" => text}} when is_binary(text) -> text
      _ -> ""
    end)
    |> String.trim()
  end

  def markdown_preview(markdown, max_length \\ 500) when is_binary(markdown) and max_length > 0 do
    if String.length(markdown) <= max_length do
      markdown
    else
      String.slice(markdown, 0, max_length) <> "..."
    end
  end

  def search_results_summary(results) when is_list(results) do
    Enum.map(results, fn result ->
      %{
        "id" => result["id"],
        "object" => result["object"],
        "url" => result["url"]
      }
    end)
  end

  def user_summary(user) when is_map(user) do
    %{
      "id" => user["id"],
      "name" => user["name"],
      "object" => user["object"],
      "type" => user["type"]
    }
  end

  def database_summary(database) when is_map(database) do
    %{
      "id" => database["id"],
      "object" => database["object"],
      "title" => plain_text(database["title"] || []),
      "url" => database["url"],
      "data_source_count" => length(database["data_sources"] || [])
    }
  end

  def data_source_summary(data_source) when is_map(data_source) do
    %{
      "id" => data_source["id"],
      "object" => data_source["object"],
      "title" => plain_text(data_source["title"] || []),
      "url" => data_source["url"],
      "property_count" => map_size(data_source["properties"] || %{})
    }
  end

  def page_summary(page) when is_map(page) do
    %{
      "id" => page["id"],
      "object" => page["object"],
      "url" => page["url"],
      "parent" => page["parent"],
      "property_names" => page["properties"] |> Map.keys() |> Enum.sort()
    }
  end

  def block_summary(block) when is_map(block) do
    %{
      "id" => block["id"],
      "object" => block["object"],
      "type" => block["type"],
      "has_children" => block["has_children"]
    }
  end

  def file_upload_summary(file_upload) when is_map(file_upload) do
    %{
      "id" => file_upload["id"],
      "object" => file_upload["object"],
      "status" => file_upload["status"],
      "filename" => file_upload["filename"],
      "content_type" => file_upload["content_type"],
      "content_length" => file_upload["content_length"]
    }
  end

  def put_if_present(map, _key, nil), do: map
  def put_if_present(map, _key, ""), do: map
  def put_if_present(map, key, value), do: Map.put(map, key, value)

  def infer_filename_from_url!(url) when is_binary(url) do
    uri = URI.parse(url)
    path = uri.path || ""

    case Path.basename(path) do
      "" ->
        raise "unable to infer a filename from #{inspect(url)}; provide NOTION_EXAMPLE_FILE_FILENAME"

      "/" ->
        raise "unable to infer a filename from #{inspect(url)}; provide NOTION_EXAMPLE_FILE_FILENAME"

      basename ->
        basename
    end
  end

  def temp_text_file!(name, contents) when is_binary(name) and is_binary(contents) do
    path = Path.join(System.tmp_dir!(), "#{System.unique_integer([:positive])}_#{name}")
    File.write!(path, contents)
    path
  end

  def cleanup_file!(path) when is_binary(path) do
    File.rm(path)
    :ok
  end

  def get_env(name) when is_binary(name) do
    System.get_env(name)
  end

  def page_comments!(client) do
    Comments.list(client, %{
      "block_id" => page_id!(),
      "page_size" => default_page_size()
    })
    |> ok!("NotionSDK.Comments.list/2")
  end

  def page_children!(client) do
    Blocks.list_children(client, %{
      "block_id" => page_id!(),
      "page_size" => default_page_size()
    })
    |> ok!("NotionSDK.Blocks.list_children/2")
  end

  defp oauth_token_from_file! do
    path = oauth_token_path()

    case FileTokenSource.fetch(path: path) do
      {:ok, %Pristine.OAuth2.Token{access_token: access_token}}
      when is_binary(access_token) and access_token != "" ->
        access_token

      {:ok, %Pristine.OAuth2.Token{}} ->
        raise """
        #{path} does not contain an access token
        regenerate it with `mix notion.oauth --save`
        """

      :error ->
        raise """
        #{path} does not exist
        generate it with `mix notion.oauth --save --manual --no-browser`
        for a registered HTTPS redirect URI, or `mix notion.oauth --save` for a
        registered loopback redirect URI. Set NOTION_OAUTH_TOKEN_PATH only if
        you want to override the default saved path.
        """

      {:error, reason} ->
        raise "failed to load #{path}: #{inspect(reason)}"
    end
  end

  defp client_opts_from_env do
    []
    |> maybe_put_client_opt(:base_url, "NOTION_BASE_URL")
    |> maybe_put_client_opt(:notion_version, "NOTION_VERSION")
    |> maybe_put_integer_client_opt(:timeout_ms, "NOTION_TIMEOUT_MS")
  end

  defp maybe_put_client_opt(opts, key, env_name) do
    case get_env(env_name) do
      nil -> opts
      "" -> opts
      value -> Keyword.put(opts, key, value)
    end
  end

  defp maybe_put_integer_client_opt(opts, key, env_name) do
    case get_env(env_name) do
      nil ->
        opts

      "" ->
        opts

      value ->
        case Integer.parse(value) do
          {integer, ""} when integer > 0 ->
            Keyword.put(opts, key, integer)

          _ ->
            raise "#{env_name} must be a positive integer, got: #{inspect(value)}"
        end
    end
  end

  defp normalize_notion_id!(value, label) when is_binary(value) do
    case Helpers.extract_notion_id(value) do
      nil ->
        raise "#{label} must be a Notion UUID or a Notion URL that contains one, got: #{inspect(value)}"

      id ->
        id
    end
  end

  defp fetch_map!(map, key, label) when is_map(map) and is_binary(key) and is_binary(label) do
    case Map.get(map, key) do
      value when is_map(value) -> value
      other -> raise "#{label} must be a map, got: #{inspect(other)}"
    end
  end

  defp property_name_for_id(properties, property_id)
       when is_map(properties) and is_binary(property_id) do
    properties
    |> Enum.find_value(fn {name, definition} ->
      if Map.get(definition, "id") == property_id, do: name
    end)
  end

  defp format_error(error) do
    cond do
      is_struct(error) and function_exported?(error.__struct__, :message, 1) ->
        Exception.message(error)

      true ->
        inspect(error, pretty: true, limit: :infinity)
    end
  end
end
