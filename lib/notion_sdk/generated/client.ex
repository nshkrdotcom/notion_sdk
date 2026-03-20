defmodule NotionSDK.Generated.Client do
  @moduledoc """
  Generated Notion Sdk client facade over `Pristine.Client`.
  """

  @spec new(keyword()) :: Pristine.Client.t()
  def new(opts \\ []) when is_list(opts) do
    base_url = Keyword.get(opts, :base_url, "https://api.notion.com")
    timeout_ms = Keyword.get(opts, :timeout_ms, 60_000)

    default_headers =
      opts
      |> Keyword.get(:default_headers, %{})
      |> Enum.into(%{"Notion-Version" => "2025-09-03", "user-agent" => "notion-sdk-elixir"})

    default_auth = Keyword.get(opts, :default_auth, [])

    Pristine.Client.new(
      base_url: base_url,
      default_headers: default_headers,
      default_auth: default_auth,
      timeout_ms: timeout_ms
    )
  end
end
