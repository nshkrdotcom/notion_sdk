import Config

config :notion_sdk,
  notion_version: "2025-09-03",
  base_url: "https://api.notion.com",
  timeout_ms: 60_000,
  user_agent: "notion-sdk-elixir/0.1.0"

config :notion_sdk, :retry,
  max_retries: 2,
  initial_retry_delay_ms: 1_000,
  max_retry_delay_ms: 60_000

import_config "#{config_env()}.exs"
