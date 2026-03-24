defmodule NotionSDK.Retry do
  @moduledoc false

  @behaviour Pristine.Ports.Retry

  alias Pristine.Adapters.Retry.Foundation, as: FoundationRetry

  @impl true
  def with_retry(fun, opts), do: FoundationRetry.with_retry(fun, opts)

  @impl true
  def should_retry?(response), do: FoundationRetry.should_retry?(response)

  @impl true
  def parse_retry_after(%{headers: headers}), do: parse_retry_after(headers)
  def parse_retry_after(%{"headers" => headers}), do: parse_retry_after(headers)

  def parse_retry_after(headers), do: FoundationRetry.parse_retry_after(headers)

  @impl true
  def build_policy(opts \\ []), do: FoundationRetry.build_policy(opts)

  @impl true
  def build_backoff(opts \\ []), do: FoundationRetry.build_backoff(opts)
end
