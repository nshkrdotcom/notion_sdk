defmodule NotionSDK.ResultClassifierTest do
  use ExUnit.Case, async: true

  alias NotionSDK.ResultClassifier
  alias Pristine.Response

  test "treats caller-side 4xx responses as breaker ignore" do
    for status <- [401, 404, 422] do
      classification =
        ResultClassifier.classify(
          {:ok, Response.new(status: status)},
          %{resource: "core_api", retry: "notion.read"},
          nil,
          []
        )

      assert classification.retry? == false
      assert classification.breaker_outcome == :ignore
      assert classification.telemetry.classification == :client_error
    end
  end

  test "treats non-upload 409 responses as breaker ignore" do
    classification =
      ResultClassifier.classify(
        {:ok, Response.new(status: 409)},
        %{resource: "core_api", retry: "notion.write"},
        nil,
        []
      )

    assert classification.retry? == false
    assert classification.breaker_outcome == :ignore
    assert classification.telemetry.classification == :client_error
  end

  test "keeps file upload send conflicts retryable" do
    classification =
      ResultClassifier.classify(
        {:ok, Response.new(status: 409)},
        %{resource: "file_upload_send", retry: "notion.file_upload_send"},
        nil,
        []
      )

    assert classification.retry? == true
    assert classification.breaker_outcome == :failure
    assert classification.telemetry.classification == :retryable_conflict
  end

  test "retries only transient transport failures" do
    transient =
      ResultClassifier.classify(
        {:error, %Mint.TransportError{reason: :closed}},
        %{resource: "core_api", retry: "notion.read"},
        nil,
        []
      )

    non_transient =
      ResultClassifier.classify(
        {:error, :nxdomain},
        %{resource: "core_api", retry: "notion.read"},
        nil,
        []
      )

    assert transient.retry? == true
    assert transient.breaker_outcome == :failure
    assert transient.telemetry.classification == :transport_error

    assert non_transient.retry? == false
    assert non_transient.breaker_outcome == :failure
    assert non_transient.telemetry.classification == :transport_error
  end

  test "retries transport errors identified by __struct__" do
    for reason <- [%{__struct__: Mint.TransportError}, %{__struct__: Mint.HTTPError}] do
      classification =
        ResultClassifier.classify(
          {:error, reason},
          %{resource: "core_api", retry: "notion.read"},
          nil,
          []
        )

      assert classification.retry? == true
      assert classification.breaker_outcome == :failure
      assert classification.telemetry.classification == :transport_error
    end
  end
end
