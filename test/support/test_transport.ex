defmodule NotionSDK.TestTransport do
  @moduledoc false

  @behaviour Pristine.Ports.Transport

  alias Pristine.Response

  @impl true
  def send(request, %{transport_opts: transport_opts} = context)
      when is_map(request) and is_map(context) do
    if test_pid = Keyword.get(transport_opts, :test_pid) do
      Kernel.send(test_pid, {:transport_request, request, context})
    end

    case Keyword.get(transport_opts, :response, default_response()) do
      response when is_function(response, 2) -> response.(request, context)
      response -> response
    end
  end

  defp default_response do
    {:ok, Response.new(status: 200, headers: %{}, body: "{}")}
  end
end
