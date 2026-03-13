defmodule NotionSDK.ResultClassifier do
  @moduledoc false

  @behaviour Pristine.Ports.ResultClassifier

  alias NotionSDK.Retry
  alias Pristine.Core.{Response, ResultClassification}

  @upstream_failure_statuses [408, 500, 502, 503, 504]
  @retryable_groups ["notion.read", "notion.delete", "notion.file_upload_send"]

  @impl true
  def classify({:ok, %Response{status: 429, headers: headers}}, endpoint, _context, _opts) do
    retry_after_ms = Retry.parse_retry_after(headers)

    ResultClassification.normalize(%{
      retry?: true,
      retry_after_ms: retry_after_ms,
      limiter_backoff_ms: retry_after_ms,
      breaker_outcome: :ignore,
      telemetry: telemetry(endpoint, :rate_limited, true, :ignore)
    })
  end

  def classify({:ok, %Response{status: 409}}, endpoint, _context, _opts) do
    if retry_group(endpoint) == "notion.file_upload_send" do
      ResultClassification.normalize(%{
        retry?: true,
        breaker_outcome: :failure,
        telemetry: telemetry(endpoint, :retryable_conflict, true, :failure)
      })
    else
      ignore(endpoint, :client_error)
    end
  end

  def classify({:ok, %Response{status: status, headers: headers}}, endpoint, _context, _opts)
      when status in @upstream_failure_statuses do
    retryable = retry_group(endpoint) in @retryable_groups

    ResultClassification.normalize(%{
      retry?: retryable,
      retry_after_ms: Retry.parse_retry_after(headers),
      breaker_outcome: :failure,
      telemetry: telemetry(endpoint, :upstream_failure, retryable, :failure)
    })
  end

  def classify({:ok, %Response{status: status}}, endpoint, _context, _opts)
      when status >= 400 and status < 500 do
    ignore(endpoint, :client_error)
  end

  def classify({:ok, %Response{status: status}}, endpoint, _context, _opts)
      when status >= 200 and status < 400 do
    success(endpoint, :success)
  end

  def classify({:error, :circuit_open}, endpoint, _context, _opts) do
    ResultClassification.normalize(%{
      retry?: false,
      breaker_outcome: :ignore,
      telemetry: telemetry(endpoint, :circuit_open, false, :ignore)
    })
  end

  def classify({:error, reason}, endpoint, _context, _opts) do
    retryable = retryable_transport_error?(reason)

    ResultClassification.normalize(%{
      retry?: retryable,
      breaker_outcome: :failure,
      telemetry: telemetry(endpoint, :transport_error, retryable, :failure)
    })
  end

  def classify(_result, endpoint, _context, _opts), do: ignore(endpoint, :ignored)

  defp success(endpoint, classification) do
    ResultClassification.normalize(%{
      retry?: false,
      breaker_outcome: :success,
      telemetry: telemetry(endpoint, classification, false, :success)
    })
  end

  defp ignore(endpoint, classification) do
    ResultClassification.normalize(%{
      retry?: false,
      breaker_outcome: :ignore,
      telemetry: telemetry(endpoint, classification, false, :ignore)
    })
  end

  defp retry_group(endpoint) do
    Map.get(endpoint, :retry) || Map.get(endpoint, "retry") || "notion.write"
  end

  defp retryable_transport_error?(%Mint.TransportError{}), do: true
  defp retryable_transport_error?(%Mint.HTTPError{}), do: true
  defp retryable_transport_error?(:timeout), do: true
  defp retryable_transport_error?(_reason), do: false

  defp telemetry(endpoint, classification, retryable, breaker_outcome) do
    %{
      classification: classification,
      retryable: retryable,
      breaker_outcome: breaker_outcome,
      resource: Map.get(endpoint, :resource),
      retry_group: retry_group(endpoint)
    }
  end
end
