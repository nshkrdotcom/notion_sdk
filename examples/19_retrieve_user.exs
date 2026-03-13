Code.require_file("support/live_example.exs", __DIR__)

alias NotionSDK.Examples.Live
alias NotionSDK.Users

Live.banner!("19_retrieve_user.exs")

client = Live.client!()
self = Users.get_self(client) |> Live.ok!("NotionSDK.Users.get_self/1")

user =
  Users.retrieve(client, %{"user_id" => self["id"]})
  |> Live.ok!("NotionSDK.Users.retrieve/2")

Live.print_json!(
  "Retrieved user",
  %{
    "self" => Live.user_summary(self),
    "retrieved" => Live.user_summary(user)
  }
)
