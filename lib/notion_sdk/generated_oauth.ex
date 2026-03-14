defmodule NotionSDK.GeneratedOAuth do
  @moduledoc false

  @spec provider_new(keyword()) :: term()
  def provider_new(opts) do
    module = provider_module()
    module.new(opts)
  end

  @spec authorization_request(term(), keyword()) :: {:ok, term()} | {:error, term()}
  def authorization_request(provider, opts) do
    oauth = oauth_module()
    oauth.authorization_request(provider, opts)
  end

  @spec authorize_url(term(), keyword()) :: {:ok, String.t()} | {:error, term()}
  def authorize_url(provider, opts) do
    oauth = oauth_module()
    oauth.authorize_url(provider, opts)
  end

  @spec exchange_code(term(), String.t(), keyword()) :: {:ok, term()} | {:error, term()}
  def exchange_code(provider, code, opts) do
    oauth = oauth_module()
    oauth.exchange_code(provider, code, opts)
  end

  @spec refresh_token(term(), String.t(), keyword()) :: {:ok, term()} | {:error, term()}
  def refresh_token(provider, refresh_token, opts) do
    oauth = oauth_module()
    oauth.refresh_token(provider, refresh_token, opts)
  end

  @spec error_new(atom(), keyword()) :: term()
  def error_new(reason, opts) do
    module = error_module()
    module.new(reason, opts)
  end

  defp oauth_module do
    Module.concat([Pristine, OAuth2])
  end

  defp provider_module do
    Module.concat([Pristine, OAuth2, Provider])
  end

  defp error_module do
    Module.concat([Pristine, OAuth2, Error])
  end
end
