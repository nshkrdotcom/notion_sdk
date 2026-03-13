defmodule NotionSDK.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: NotionSDK.Finch, pools: finch_pools()}
    ]

    opts = [strategy: :one_for_one, name: NotionSDK.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp finch_pools do
    %{
      "https://api.notion.com" => [
        size: 10,
        count: 1,
        conn_opts: [transport_opts: [timeout: 60_000]]
      ]
    }
  end
end
