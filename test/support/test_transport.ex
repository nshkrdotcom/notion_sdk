defmodule NotionSDK.TestTransport do
  @moduledoc false

  @behaviour Pristine.Ports.Transport

  alias Pristine.Core.Response
  alias Pristine.Response, as: PublicResponse

  @impl true
  def send(request, %{transport_opts: transport_opts} = context)
      when is_map(request) and is_map(context) do
    if test_pid = Keyword.get(transport_opts, :test_pid) do
      Kernel.send(test_pid, {:transport_request, request, context})
    end

    case Keyword.get(transport_opts, :response, default_response()) do
      response when is_function(response, 2) -> normalize_response(response.(request, context))
      response -> normalize_response(response)
    end
  end

  defp default_response do
    {:ok, %Response{status: 200, headers: %{}, body: "{}"}}
  end

  defp normalize_response({:ok, %PublicResponse{} = response}) do
    {:ok,
     %Response{
       status: response.status,
       headers: response.headers,
       body: response.body,
       metadata: response.metadata
     }}
  end

  defp normalize_response(other), do: other
end
