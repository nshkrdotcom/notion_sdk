defmodule NotionSDK.Databases do
  @moduledoc """
  Generated Notion Sdk operations for databases.
  """

  @create_partition_spec %{
    path: [],
    auth: {"auth", :auth},
    body: %{
      keys: [
        {"cover", :cover},
        {"description", :description},
        {"icon", :icon},
        {"initial_data_source", :initial_data_source},
        {"is_inline", :is_inline},
        {"parent", :parent},
        {"title", :title}
      ],
      mode: :keys
    },
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc "Create a database\n## Source Context\n### Warnings\n\nLimitations\n\nCreating new `status` database properties is currently not supported.\n\n### Notes\n\nIntegration capabilities\n\nThis endpoint requires an integration to have insert content capabilities. Attempting to call this API without insert content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](https://developers.notion.com/reference/capabilities).\n\n### Errors\n\nReturns a 404 if the specified parent page does not exist, or if the integration does not have access to the parent page.\nReturns a 400 if the request is incorrectly formatted, or a 429 HTTP response if the request exceeds the [request limits](https://developers.notion.com/reference/request-limits).\n*Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.*\n\n### Resources\n\n  * [capabilities guide](https://developers.notion.com/reference/capabilities)\n  * [request limits](https://developers.notion.com/reference/request-limits)\n  * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)\n  * [Create a database](https://developers.notion.com/reference/create-a-database)\n## Code Samples\n\nTypeScript SDK\n```javascript\nimport { Client } from \"@notionhq/client\"\n\nconst notion = new Client({ auth: process.env.NOTION_API_KEY })\n\nconst response = await notion.databases.create({\n  parent: {\n    type: \"page_id\",\n    page_id: \"b55c9c91-384d-452b-81db-d1ef79372b75\"\n  },\n  title: [{ text: { content: \"My Database\" } }]\n})\n```\n"
  @spec create(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def create(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    operation = build_create_operation(params)
    Pristine.execute(runtime_client, operation, opts)
  end

  defp build_create_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @create_partition_spec)

    Pristine.Operation.new(%{
      id: "databases/create",
      method: :post,
      path_template: "/v1/databases",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.Databases, :create_json_req},
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.DatabaseObjectResponse, :t}, {NotionSDK.PartialDatabaseObjectResponse, :t}]},
        400 => {NotionSDK.ErrorApi400, :t},
        401 => {NotionSDK.ErrorApi401, :t},
        403 => {NotionSDK.ErrorApi403, :t},
        404 => {NotionSDK.ErrorApi404, :t},
        409 => {NotionSDK.ErrorApi409, :t},
        429 => {NotionSDK.ErrorApi429, :t},
        500 => {NotionSDK.ErrorApi500, :t},
        503 => {NotionSDK.ErrorApi503, :t}
      },
      auth: %{
        use_client_default?: true,
        override: partition.auth,
        security_schemes: ["bearerAuth"]
      },
      runtime: %{
        circuit_breaker: "core_api",
        rate_limit_group: "notion.integration",
        resource: "core_api",
        retry_group: "notion.write",
        telemetry_event: [:notion_sdk, :databases, :create],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @retrieve_partition_spec %{
    path: [{"database_id", :database_id}],
    auth: {"auth", :auth},
    body: %{mode: :none},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc "Retrieve a database\n## Source Context\nRetrieves a [database object](https://developers.notion.com/reference/database) — information that describes the structure and columns of a database — for a provided database ID. The response adheres to any limits to an integration’s capabilities.\n\n### Warnings\n\nDeprecated as of version 2025-09-03\n\nThis page describes the API for versions up to and including `2022-06-28`. In the new `2025-09-03` version, the concepts of databases and data sources were split up, as described in [Upgrading to 2025-09-03](https://developers.notion.com/guides/get-started/upgrade-guide-2025-09-03).\nRefer to the new APIs instead:\n\n  * [Retrieve a database](https://developers.notion.com/reference/database-retrieve)\n  * [Retrieve a data source](https://developers.notion.com/reference/retrieve-a-data-source)\n\nThe Notion API does not support retrieving linked databases.\n\nTo fetch the information in a [linked database](https://www.notion.so/help/guides/using-linked-databases), share the original source database with your Notion integration.\n\n### Notes\n\nDatabase relations must be shared with your integration\n\nTo retrieve database properties from [database relations](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation), the related database must be shared with your integration in addition to the database being retrieved. If the related database is not shared, properties based on relations will not be included in the API response.\n\n### Overview\n\nTo fetch database rows rather than columns, use the [Query a database](https://developers.notion.com/reference/post-database-query) endpoint.\n\nTo find a database ID, navigate to the database URL in your Notion workspace. The ID is the string of characters in the URL that is between the slash following the workspace name (if applicable) and the question mark. The ID is a 32 characters alphanumeric string.\n\n<Frame caption=\"Notion database ID\">\n<img src=\"https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=00a19b68b92cd013cdc0f8867427eb44\" alt=\"1340\" data-og-width=\"1340\" width=\"1340\" data-og-height=\"550\" height=\"550\" data-path=\"images/reference/image-1.png\" data-optimize=\"true\" data-opv=\"3\" srcset=\"https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=280&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=619d6c3987ad5749bf23af7818319fa2 280w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=560&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=169ae1bb1ec28afc5a2a76da22509aa7 560w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=840&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=721d8511030842a08474ddd98a6b384f 840w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=1100&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=7916e5aadb53f7b659e522154193debe 1100w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=1650&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=3efcdcb414a369a7835d2745d192abaf 1650w, https://mintcdn.com/notion-demo/S-I3qLQnwRa7HjdK/images/reference/image-1.png?w=2500&fit=max&auto=format&n=S-I3qLQnwRa7HjdK&q=85&s=dd872b0b759a00afe4d3cd4243877c8b 2500w\" />\n</Frame>\n\nRefer to the [Build your first integration guide](https://developers.notion.com/guides/get-started/create-a-notion-integration#step-3-save-the-database-id) for more details.\n\n### Additional resources\n\n  * [How to share a database with your integration](https://developers.notion.com/guides/get-started/create-a-notion-integration#give-your-integration-page-permissions)\n  * [Working with databases guide](https://developers.notion.com/guides/data-apis/working-with-databases)\n\n### Errors\n\nErrorsEach Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.\n\n### Resources\n\n  * [Upgrading to 2025-09-03](https://developers.notion.com/guides/get-started/upgrade-guide-2025-09-03)\n  * [Retrieve a database](https://developers.notion.com/reference/database-retrieve)\n  * [Retrieve a data source](https://developers.notion.com/reference/retrieve-a-data-source)\n  * [database object](https://developers.notion.com/reference/database)\n  * [Query a database](https://developers.notion.com/reference/post-database-query)\n  * [Build your first integration guide](https://developers.notion.com/guides/get-started/create-a-notion-integration#step-3-save-the-database-id)\n  * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)\n  * [How to share a database with your integration](https://developers.notion.com/guides/get-started/create-a-notion-integration#give-your-integration-page-permissions)\n  * [Working with databases guide](https://developers.notion.com/guides/data-apis/working-with-databases)\n  * [database relations](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation)\n  * [linked database](https://www.notion.so/help/guides/using-linked-databases)\n  * [Retrieve a database](https://developers.notion.com/reference/retrieve-a-database)\n## Code Samples\n\nTypeScript SDK\n```javascript\nimport { Client } from \"@notionhq/client\"\n\nconst notion = new Client({ auth: process.env.NOTION_API_KEY })\n\nconst response = await notion.databases.retrieve({\n  database_id: \"d9824bdc-8445-4327-be8b-5b47500af6ce\"\n})\n```\n"
  @spec retrieve(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def retrieve(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    operation = build_retrieve_operation(params)
    Pristine.execute(runtime_client, operation, opts)
  end

  defp build_retrieve_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @retrieve_partition_spec)

    Pristine.Operation.new(%{
      id: "databases/retrieve",
      method: :get,
      path_template: "/v1/databases/{database_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: nil,
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.DatabaseObjectResponse, :t}, {NotionSDK.PartialDatabaseObjectResponse, :t}]},
        400 => {NotionSDK.ErrorApi400, :t},
        401 => {NotionSDK.ErrorApi401, :t},
        403 => {NotionSDK.ErrorApi403, :t},
        404 => {NotionSDK.ErrorApi404, :t},
        409 => {NotionSDK.ErrorApi409, :t},
        429 => {NotionSDK.ErrorApi429, :t},
        500 => {NotionSDK.ErrorApi500, :t},
        503 => {NotionSDK.ErrorApi503, :t}
      },
      auth: %{
        use_client_default?: true,
        override: partition.auth,
        security_schemes: ["bearerAuth"]
      },
      runtime: %{
        circuit_breaker: "core_api",
        rate_limit_group: "notion.integration",
        resource: "core_api",
        retry_group: "notion.read",
        telemetry_event: [:notion_sdk, :databases, :retrieve],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @update_partition_spec %{
    path: [{"database_id", :database_id}],
    auth: {"auth", :auth},
    body: %{
      keys: [
        {"cover", :cover},
        {"description", :description},
        {"icon", :icon},
        {"in_trash", :in_trash},
        {"is_inline", :is_inline},
        {"is_locked", :is_locked},
        {"parent", :parent},
        {"title", :title}
      ],
      mode: :keys
    },
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc "Update a database\n## Source Context\n### Warnings\n\nThe following database properties cannot be updated via the API:\n\n  * `formula`\n  * `select`\n  * `status`\n  * [Synced content](https://www.notion.so/help/guides/synced-databases-bridge-different-tools)\n  * A `multi_select` database property’s options values. An option can be removed, but not updated.\n\n### Notes\n\nDatabase relations must be shared with your integration\n\nTo update a database [relation](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation) property, the related database must also be shared with your integration.\n\n### How database property type changes work\n\nAll properties in pages are stored as rich text. Notion will convert that rich text based on the types defined in a database's schema. When a type is changed using the API, the data will continue to be available, it is just presented differently.\nFor example, a multi select property value is represented as a comma-separated list of strings (eg. \"1, 2, 3\") and a people property value is represented as a comma-separated list of IDs. These are compatible and the type can be converted.\nNote: Not all type changes work. In some cases data will no longer be returned, such as people type → file type.\n\n### Interacting with database rows\n\nThis endpoint cannot be used to update database rows.\nTo update the properties of a database row — rather than a column — use the [Update page](https://developers.notion.com/reference/patch-page) endpoint. To add a new row to a database, use the [Create a page](https://developers.notion.com/reference/post-page) endpoint.\n\n### Recommended database schema size limit\n\nDevelopers are encouraged to keep their database schema size to a maximum of **50KB**. To stay within this schema size limit, the number of properties (or columns) added to a database should be managed.\nDatabase schema updates that are too large will be blocked by the REST API to help developers keep their database queries performant. When a schema update is blocked, the error response includes a `validation_error` code with a message identifying the largest property by name, ID, and byte size to help you reduce your schema size.\n\n### Errors\n\nEach Public API endpoint can return several possible error codes. See the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation for more information.\n\n### Resources\n\n  * [Update page](https://developers.notion.com/reference/patch-page)\n  * [Create a page](https://developers.notion.com/reference/post-page)\n  * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)\n  * [Synced content](https://www.notion.so/help/guides/synced-databases-bridge-different-tools)\n  * [relation](https://www.notion.so/help/relations-and-rollups#what-is-a-database-relation)\n  * [Update a database](https://developers.notion.com/reference/update-a-database)\n## Code Samples\n\nTypeScript SDK\n```javascript\nimport { Client } from \"@notionhq/client\"\n\nconst notion = new Client({ auth: process.env.NOTION_API_KEY })\n\nconst response = await notion.databases.update({\n  database_id: \"d9824bdc-8445-4327-be8b-5b47500af6ce\",\n  title: [{ text: { content: \"Updated Database Title\" } }]\n})\n```\n"
  @spec update(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def update(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    runtime_client = NotionSDK.Client.pristine_client(client)
    operation = build_update_operation(params)
    Pristine.execute(runtime_client, operation, opts)
  end

  defp build_update_operation(params) when is_map(params) do
    partition = Pristine.Operation.partition(params, @update_partition_spec)

    Pristine.Operation.new(%{
      id: "databases/update",
      method: :patch,
      path_template: "/v1/databases/{database_id}",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.Databases, :update_json_req},
      response_schemas: %{
        200 =>
          {:union,
           [{NotionSDK.DatabaseObjectResponse, :t}, {NotionSDK.PartialDatabaseObjectResponse, :t}]},
        400 => {NotionSDK.ErrorApi400, :t},
        401 => {NotionSDK.ErrorApi401, :t},
        403 => {NotionSDK.ErrorApi403, :t},
        404 => {NotionSDK.ErrorApi404, :t},
        409 => {NotionSDK.ErrorApi409, :t},
        429 => {NotionSDK.ErrorApi429, :t},
        500 => {NotionSDK.ErrorApi500, :t},
        503 => {NotionSDK.ErrorApi503, :t}
      },
      auth: %{
        use_client_default?: true,
        override: partition.auth,
        security_schemes: ["bearerAuth"]
      },
      runtime: %{
        circuit_breaker: "core_api",
        rate_limit_group: "notion.integration",
        resource: "core_api",
        retry_group: "notion.write",
        telemetry_event: [:notion_sdk, :databases, :update],
        timeout_ms: nil
      },
      pagination: nil
    })
  end

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :create_json_req)

  def __fields__(:create_json_req) do
    [
      cover:
        {:union,
         [{NotionSDK.ExternalPageCoverRequest, :t}, {NotionSDK.FileUploadPageCoverRequest, :t}]},
      description: {:array, {NotionSDK.RichTextItemRequest, :t}},
      icon:
        {:union,
         [
           {NotionSDK.CustomEmojiPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.FileUploadPageIconRequest, :t}
         ]},
      initial_data_source: {NotionSDK.InitialDataSourceRequest, :t},
      is_inline: :boolean,
      parent: {NotionSDK.Databases, :create_json_req_parent},
      title: {:array, {NotionSDK.RichTextItemRequest, :t}}
    ]
  end

  def __fields__(:create_json_req_parent) do
    [
      type: {:enum, ["page_id", "workspace"]}
    ]
  end

  def __fields__(:update_json_req) do
    [
      cover:
        {:union,
         [{NotionSDK.ExternalPageCoverRequest, :t}, {NotionSDK.FileUploadPageCoverRequest, :t}]},
      description: {:array, {NotionSDK.RichTextItemRequest, :t}},
      icon:
        {:union,
         [
           {NotionSDK.CustomEmojiPageIconRequest, :t},
           {NotionSDK.EmojiPageIconRequest, :t},
           {NotionSDK.ExternalPageIconRequest, :t},
           {NotionSDK.FileUploadPageIconRequest, :t}
         ]},
      in_trash: :boolean,
      is_inline: :boolean,
      is_locked: :boolean,
      parent: {NotionSDK.Databases, :update_json_req_parent},
      title: {:array, {NotionSDK.RichTextItemRequest, :t}}
    ]
  end

  def __fields__(:update_json_req_parent) do
    [
      type: {:enum, ["page_id", "workspace"]}
    ]
  end

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
  def __openapi_fields__(type \\ :create_json_req)

  def __openapi_fields__(:create_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "cover",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [{NotionSDK.ExternalPageCoverRequest, :t}, {NotionSDK.FileUploadPageCoverRequest, :t}]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The description of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "description",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "icon",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             {NotionSDK.CustomEmojiPageIconRequest, :t},
             {NotionSDK.EmojiPageIconRequest, :t},
             {NotionSDK.ExternalPageIconRequest, :t},
             {NotionSDK.FileUploadPageIconRequest, :t}
           ]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "initial_data_source",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.InitialDataSourceRequest, :t},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Whether the database should be displayed inline in the parent page. Defaults to false.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_inline",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The parent page or workspace where the database will be created.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "parent",
        nullable: false,
        read_only: false,
        required: true,
        type: {NotionSDK.Databases, :create_json_req_parent},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: "The title of the database.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "title",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:create_json_req_parent) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "The type of parent.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:enum, ["page_id", "workspace"]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "cover",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [{NotionSDK.ExternalPageCoverRequest, :t}, {NotionSDK.FileUploadPageCoverRequest, :t}]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "The updated description of the database, if any. If not provided, the description will not be updated.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "description",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "icon",
        nullable: false,
        read_only: false,
        required: false,
        type:
          {:union,
           [
             {NotionSDK.CustomEmojiPageIconRequest, :t},
             {NotionSDK.EmojiPageIconRequest, :t},
             {NotionSDK.ExternalPageIconRequest, :t},
             {NotionSDK.FileUploadPageIconRequest, :t}
           ]},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Whether the database should be moved to or from the trash. If not provided, the trash status will not be updated.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "in_trash",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Whether the database should be displayed inline in the parent page. If not provided, the inline status will not be updated.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_inline",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "Whether the database should be locked from editing in the Notion app UI. If not provided, the locked state will not be updated.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "is_locked",
        nullable: false,
        read_only: false,
        required: false,
        type: :boolean,
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "The parent page or workspace to move the database to. If not provided, the database will not be moved.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "parent",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.Databases, :update_json_req_parent},
        write_only: false
      },
      %{
        default: nil,
        deprecated: false,
        description:
          "The updated title of the database, if any. If not provided, the title will not be updated.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "title",
        nullable: false,
        read_only: false,
        required: false,
        type: {:array, {NotionSDK.RichTextItemRequest, :t}},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:update_json_req_parent) do
    [
      %{
        default: nil,
        deprecated: false,
        description: "The type of parent.",
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "type",
        nullable: false,
        read_only: false,
        required: false,
        type: {:enum, ["page_id", "workspace"]},
        write_only: false
      }
    ]
  end

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :create_json_req) when is_atom(type) do
    Pristine.Runtime.Schema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :create_json_req)

  def decode(data, type) when is_map(data) and is_atom(type) do
    Pristine.Runtime.Schema.decode_module_type(NotionSDK.Databases, type, data)
  end
end
