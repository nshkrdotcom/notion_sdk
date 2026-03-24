defmodule NotionSDK.Generated.Client do
  @moduledoc """
  Generated Notion Sdk client facade over `NotionSDK.Client`.
  """

  @spec new(keyword()) :: NotionSDK.Client.t()
  def new(opts \\ []) when is_list(opts) do
    NotionSDK.Client.new(opts)
  end
end
