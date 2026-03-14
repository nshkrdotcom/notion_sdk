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

  def parse_retry_after(headers) do
    with value when not is_nil(value) <- header_value(headers, "retry-after"),
         parsed when not is_nil(parsed) <- parse_retry_after_value(value) do
      parsed
    else
      _ ->
        with value when not is_nil(value) <- header_value(headers, "retry-after-ms"),
             parsed when not is_nil(parsed) <- parse_non_negative_integer(value) do
          parsed
        else
          _ -> nil
        end
    end
  end

  @impl true
  def build_policy(opts \\ []), do: FoundationRetry.build_policy(opts)

  @impl true
  def build_backoff(opts \\ []), do: FoundationRetry.build_backoff(opts)

  defp parse_retry_after_value(value) do
    parse_non_negative_integer(value, 1_000) || parse_http_date(value)
  end

  defp parse_non_negative_integer(value, multiplier \\ 1)

  defp parse_non_negative_integer(value, multiplier) when is_binary(value) do
    case Integer.parse(value) do
      {integer, _rest} when integer >= 0 -> integer * multiplier
      _ -> nil
    end
  end

  defp parse_non_negative_integer(_value, _multiplier), do: nil

  defp parse_http_date(value) when is_binary(value) do
    case convert_request_date(value) do
      {{_, _, _}, {_, _, _}} = datetime ->
        retry_after_ms =
          (:calendar.datetime_to_gregorian_seconds(datetime) -
             :calendar.datetime_to_gregorian_seconds(:calendar.universal_time())) * 1_000

        max(retry_after_ms, 0)

      _ ->
        nil
    end
  end

  defp parse_http_date(_value), do: nil

  defp convert_request_date(value) when is_binary(value) do
    with {:module, :httpd_util} <- Code.ensure_loaded(:httpd_util),
         true <- function_exported?(:httpd_util, :convert_request_date, 1) do
      httpd_util = :httpd_util
      httpd_util.convert_request_date(String.to_charlist(value))
    else
      _ -> nil
    end
  end

  defp header_value(headers, name) when is_map(headers) do
    downcased_name = String.downcase(name)

    Enum.find_value(headers, fn {key, value} ->
      if String.downcase(to_string(key)) == downcased_name and is_binary(value), do: value
    end)
  end

  defp header_value(headers, name) when is_list(headers) do
    downcased_name = String.downcase(name)

    Enum.find_value(headers, fn
      {key, value} when is_binary(value) ->
        if String.downcase(to_string(key)) == downcased_name, do: value

      _ ->
        nil
    end)
  end

  defp header_value(_headers, _name), do: nil
end
