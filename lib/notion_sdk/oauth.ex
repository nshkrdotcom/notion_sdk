defmodule NotionSDK.OAuth.Helpers do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Pristine.OAuth2

      @oauth_client_opts [
        :base_url,
        :finch,
        :foundation,
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

      @spec provider() :: OAuth2.Provider.t()
      def provider do
        OAuth2.Provider.new(
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
              {:ok, OAuth2.AuthorizationRequest.t()} | {:error, OAuth2.Error.t()}
      def authorization_request(opts \\ []) when is_list(opts) do
        with {:ok, authorization_opts} <- authorization_opts(opts) do
          OAuth2.authorization_request(provider(), authorization_opts)
        end
      end

      @spec authorize_url(keyword()) :: {:ok, String.t()} | {:error, OAuth2.Error.t()}
      def authorize_url(opts \\ []) when is_list(opts) do
        with {:ok, authorization_opts} <- authorization_opts(opts) do
          OAuth2.authorize_url(provider(), authorization_opts)
        end
      end

      @spec exchange_code(String.t(), keyword()) ::
              {:ok, OAuth2.Token.t()} | {:error, OAuth2.Error.t()}
      def exchange_code(code, opts \\ []) when is_binary(code) and is_list(opts) do
        OAuth2.exchange_code(provider(), code, oauth_runtime_opts(opts))
      end

      @spec refresh_token(String.t(), keyword()) ::
              {:ok, OAuth2.Token.t()} | {:error, OAuth2.Error.t()}
      def refresh_token(refresh_token, opts \\ [])
          when is_binary(refresh_token) and is_list(opts) do
        OAuth2.refresh_token(provider(), refresh_token, oauth_runtime_opts(opts))
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
             opts |> Keyword.put(:params, params) |> Keyword.put(:redirect_uri, redirect_uri)}

          _other ->
            {:error, OAuth2.Error.new(:missing_redirect_uri, provider: provider().name)}
        end
      end

      defp oauth_runtime_opts(opts) do
        client = Keyword.get(opts, :client) || NotionSDK.Client.new(client_opts(opts))

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
end
