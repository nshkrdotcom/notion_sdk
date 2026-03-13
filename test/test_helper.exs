Application.put_env(:notion_sdk, :notion_version, "2025-09-03")
Application.put_env(:notion_sdk, :base_url, "https://api.notion.com")
Application.put_env(:notion_sdk, :timeout_ms, 60_000)
Application.put_env(:notion_sdk, :user_agent, "notion-sdk-elixir/0.1.0")

Application.put_env(
  :notion_sdk,
  :retry,
  max_retries: 2,
  initial_retry_delay_ms: 1_000,
  max_retry_delay_ms: 60_000
)

ExUnit.start()
