defmodule NotionSDK.OAuth do
  @moduledoc """
  Generated Notion Sdk operations for o auth.
  """

  use NotionSDK.OAuth.Helpers

  alias NotionSDK.Generated.RuntimeSchema, as: RuntimeSchema

  alias Pristine.SDK.OpenAPI.Client, as: OpenAPIClient

  @introspect_partition_spec %{
    path: [],
    auth: %{
      keys: [{"client_id", :client_id}, {"client_secret", :client_secret}],
      mode: :keys
    },
    body: %{keys: [{"token", :token}], mode: :keys},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Introspect a token
       ## Source Context
       Get a token's active status, scope, and issued time.

       ### Resources

       * [Introspect a token](https://developers.notion.com/reference/introspect-token)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client()

       const response = await notion.oauth.introspect({
       client_id: process.env.OAUTH_CLIENT_ID,
       client_secret: process.env.OAUTH_CLIENT_SECRET,
       token: "access_token_to_introspect"
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec introspect(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def introspect(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_introspect_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  defp build_introspect_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @introspect_partition_spec)

    %{
      id: "o_auth/introspect",
      args: params,
      call: {__MODULE__, :introspect},
      opts: opts,
      method: :post,
      path_template: "/v1/oauth/introspect",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.OAuth, :introspect_json_req},
      response_schemas: %{
        200 => {NotionSDK.OAuth, :introspect_200_json_resp},
        400 => {NotionSDK.ErrorOauth400, :t},
        401 => {NotionSDK.ErrorOauth401, :t},
        403 => {NotionSDK.ErrorOauth403, :t},
        500 => {NotionSDK.ErrorOauth500, :t}
      },
      auth: %{
        use_client_default?: false,
        override: partition.auth,
        security_schemes: ["basicAuth"]
      },
      resource: "oauth_control",
      retry: "notion.oauth_control",
      circuit_breaker: "oauth_control",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :oauth, :introspect],
      timeout: nil,
      pagination: nil
    }
  end

  @revoke_partition_spec %{
    path: [],
    auth: %{
      keys: [{"client_id", :client_id}, {"client_secret", :client_secret}],
      mode: :keys
    },
    body: %{keys: [{"token", :token}], mode: :keys},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Revoke a token
       ## Source Context
       Revoke an access token.

       ### Resources

       * [Revoke a token](https://developers.notion.com/reference/revoke-token)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client()

       const response = await notion.oauth.revoke({
       client_id: process.env.OAUTH_CLIENT_ID,
       client_secret: process.env.OAUTH_CLIENT_SECRET,
       token: "access_token_to_revoke"
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec revoke(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def revoke(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_revoke_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  defp build_revoke_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @revoke_partition_spec)

    %{
      id: "o_auth/revoke",
      args: params,
      call: {__MODULE__, :revoke},
      opts: opts,
      method: :post,
      path_template: "/v1/oauth/revoke",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema: {NotionSDK.OAuth, :revoke_json_req},
      response_schemas: %{
        200 => {NotionSDK.OAuth, :revoke_200_json_resp},
        400 => {NotionSDK.ErrorOauth400, :t},
        401 => {NotionSDK.ErrorOauth401, :t},
        403 => {NotionSDK.ErrorOauth403, :t},
        500 => {NotionSDK.ErrorOauth500, :t}
      },
      auth: %{
        use_client_default?: false,
        override: partition.auth,
        security_schemes: ["basicAuth"]
      },
      resource: "oauth_control",
      retry: "notion.oauth_control",
      circuit_breaker: "oauth_control",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :oauth, :revoke],
      timeout: nil,
      pagination: nil
    }
  end

  @token_partition_spec %{
    path: [],
    auth: %{
      keys: [{"client_id", :client_id}, {"client_secret", :client_secret}],
      mode: :keys
    },
    body: %{mode: :remaining},
    query: [],
    headers: [],
    form_data: %{mode: :none}
  }

  @doc ~S"""
       Create a token
       ## Source Context
       ### Warnings

       Redirect URI requirements for public integrations

       The `redirect_uri` is a *required* field in the request body for this endpoint if:
       In most cases, the `redirect_uri` field is required.
       This field is not allowed in the request body if:
       Learn more in the public integration section of the [Authorization Guide](https://developers.notion.com/guides/get-started/authorization#public-integration-auth-flow-set-up).
       *Note: Each Public API endpoint can return several possible error codes. To see a full description of each type of error code, see the [Error codes section](https://developers.notion.com/reference/status-codes#error-codes) of the Status codes documentation.*

       * the `redirect_uri` query parameter was set in the [Authorization URL](https://developers.notion.com/guides/get-started/authorization#step-1-navigate-the-user-to-the-integrations-authorization-url) provided to users, *or*;
       * there are more than one `redirect_uri`s included in the [integration's settings](https://www.notion.so/profile/integrations) under **OAuth Domain & URIs**.
       * there is one `redirect_uri` included in the [integration's settings](https://www.notion.so/profile/integrations) under **OAuth Domain & URIs**, *and* the `redirect_uri` query parameter was not included in the Authorization URL.

       ### Notes

       For step-by-step instructions on how to use this endpoint to create a public integration, check out the [Authorization guide](https://developers.notion.com/guides/get-started/authorization#set-up-the-auth-flow-for-a-public-integration). To walkthrough how to create tokens for Link Previews, refer to the [Link Previews guide](https://developers.notion.com/guides/link-previews/build-a-link-preview-integration).

       ### Resources

       * [Authorization guide](https://developers.notion.com/guides/get-started/authorization#set-up-the-auth-flow-for-a-public-integration)
       * [Link Previews guide](https://developers.notion.com/guides/link-previews/build-a-link-preview-integration)
       * [Authorization URL](https://developers.notion.com/guides/get-started/authorization#step-1-navigate-the-user-to-the-integrations-authorization-url)
       * [integration's settings](https://www.notion.so/profile/integrations)
       * [Authorization Guide](https://developers.notion.com/guides/get-started/authorization#public-integration-auth-flow-set-up)
       * [Error codes section](https://developers.notion.com/reference/status-codes#error-codes)
       * [Create a token](https://developers.notion.com/reference/create-a-token)
       ## Code Samples

       TypeScript SDK
       ```javascript
       import { Client } from "@notionhq/client"

       const notion = new Client()

       const response = await notion.oauth.token({
       client_id: process.env.OAUTH_CLIENT_ID,
       client_secret: process.env.OAUTH_CLIENT_SECRET,
       grant_type: "authorization_code",
       code: "abc123-authorization-code",
       redirect_uri: "https://example.com/callback"
       })
       ```

       """
       |> String.trim_leading("\n")
       |> String.trim_trailing("\n")
  @spec token(term(), map(), keyword()) :: {:ok, term()} | {:error, term()}
  def token(client, params \\ %{}, opts \\ [])
      when is_map(params) and is_list(opts) do
    opts = normalize_request_opts!(opts)
    request = build_token_request(client, params, opts)
    NotionSDK.Client.execute_generated_request(client, request)
  end

  defp build_token_request(client, params, opts)
       when is_map(params) and is_list(opts) do
    _ = client
    partition = OpenAPIClient.partition(params, @token_partition_spec)

    %{
      id: "o_auth/token",
      args: params,
      call: {__MODULE__, :token},
      opts: opts,
      method: :post,
      path_template: "/v1/oauth/token",
      path_params: partition.path_params,
      query: partition.query,
      headers: partition.headers,
      body: partition.body,
      form_data: partition.form_data,
      request_schema:
        {:union, [{NotionSDK.OAuth, :token_json_req}, {NotionSDK.OAuth, :token_json_req}]},
      response_schemas: %{
        200 => {NotionSDK.OAuth, :token_200_json_resp},
        400 => {NotionSDK.ErrorOauth400, :t},
        401 => {NotionSDK.ErrorOauth401, :t},
        403 => {NotionSDK.ErrorOauth403, :t},
        500 => {NotionSDK.ErrorOauth500, :t}
      },
      auth: %{
        use_client_default?: false,
        override: partition.auth,
        security_schemes: ["basicAuth"]
      },
      resource: "oauth_control",
      retry: "notion.oauth_control",
      circuit_breaker: "oauth_control",
      rate_limit: "notion.integration",
      telemetry: [:notion_sdk, :oauth, :token],
      timeout: nil,
      pagination: nil
    }
  end

  @spec normalize_request_opts!(list()) :: keyword()
  defp normalize_request_opts!(opts) when is_list(opts) do
    if Keyword.keyword?(opts) do
      opts
    else
      raise ArgumentError, "request opts must be a keyword list"
    end
  end

  @doc false
  @spec __fields__(atom()) :: keyword()
  def __fields__(type \\ :introspect_200_json_resp)

  def __fields__(:introspect_200_json_resp) do
    [
      active: :boolean,
      iat: :integer,
      request_id: {:string, "uuid"},
      scope: :string
    ]
  end

  def __fields__(:introspect_json_req) do
    [
      token: :string
    ]
  end

  def __fields__(:revoke_200_json_resp) do
    [
      request_id: {:string, "uuid"}
    ]
  end

  def __fields__(:revoke_json_req) do
    [
      token: :string
    ]
  end

  def __fields__(:token_200_json_resp) do
    [
      access_token: :string,
      bot_id: {:string, "uuid"},
      duplicated_template_id: {:union, [:null, string: "uuid"]},
      owner: {:union, [{NotionSDK.User, :t}, {NotionSDK.Workspace, :t}]},
      refresh_token: {:union, [:null, :string]},
      request_id: {:string, "uuid"},
      token_type: {:const, "bearer"},
      workspace_icon: {:union, [:null, :string]},
      workspace_id: {:string, "uuid"},
      workspace_name: {:union, [:null, :string]}
    ]
  end

  def __fields__(:token_json_req) do
    [
      code: :string,
      external_account: {NotionSDK.OAuth, :token_json_req_external_account},
      grant_type: {:const, "authorization_code"},
      redirect_uri: :string
    ]
  end

  def __fields__(:token_json_req_external_account) do
    [
      key: :string,
      name: :string
    ]
  end

  @doc false
  @spec __openapi_fields__(atom()) :: [map()]
  def __openapi_fields__(type \\ :introspect_200_json_resp)

  def __openapi_fields__(:introspect_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "active",
        nullable: false,
        read_only: false,
        required: true,
        type: :boolean,
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
        name: "iat",
        nullable: false,
        read_only: false,
        required: false,
        type: :integer,
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
        name: "request_id",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "uuid"},
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
        name: "scope",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:introspect_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "token",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:revoke_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "request_id",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "uuid"},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:revoke_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "token",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:token_200_json_resp) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "access_token",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
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
        name: "bot_id",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "uuid"},
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
        name: "duplicated_template_id",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, string: "uuid"]},
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
        name: "owner",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [{NotionSDK.User, :t}, {NotionSDK.Workspace, :t}]},
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
        name: "refresh_token",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
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
        name: "request_id",
        nullable: false,
        read_only: false,
        required: false,
        type: {:string, "uuid"},
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
        name: "token_type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "bearer"},
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
        name: "workspace_icon",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
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
        name: "workspace_id",
        nullable: false,
        read_only: false,
        required: true,
        type: {:string, "uuid"},
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
        name: "workspace_name",
        nullable: false,
        read_only: false,
        required: true,
        type: {:union, [:null, :string]},
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:token_json_req) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "code",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
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
        name: "external_account",
        nullable: false,
        read_only: false,
        required: false,
        type: {NotionSDK.OAuth, :token_json_req_external_account},
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
        name: "grant_type",
        nullable: false,
        read_only: false,
        required: true,
        type: {:const, "authorization_code"},
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
        name: "redirect_uri",
        nullable: false,
        read_only: false,
        required: false,
        type: :string,
        write_only: false
      }
    ]
  end

  def __openapi_fields__(:token_json_req_external_account) do
    [
      %{
        default: nil,
        deprecated: false,
        description: nil,
        example: nil,
        examples: nil,
        extensions: %{},
        external_docs: nil,
        name: "key",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
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
        name: "name",
        nullable: false,
        read_only: false,
        required: true,
        type: :string,
        write_only: false
      }
    ]
  end

  @doc false
  @spec __schema__(atom()) :: Sinter.Schema.t()
  def __schema__(type \\ :introspect_200_json_resp) when is_atom(type) do
    RuntimeSchema.build_schema(__openapi_fields__(type))
  end

  @doc false
  @spec decode(map(), atom()) :: {:ok, term()} | {:error, term()}
  def decode(data, type \\ :introspect_200_json_resp)

  def decode(data, type) when is_map(data) and is_atom(type) do
    RuntimeSchema.decode_module_type(__MODULE__, type, data)
  end
end
