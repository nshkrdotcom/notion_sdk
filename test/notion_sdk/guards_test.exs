defmodule NotionSDK.GuardsTest do
  use ExUnit.Case, async: true

  alias NotionSDK.Guards

  test "recognizes full object responses" do
    assert Guards.full_block?(%{"object" => "block", "type" => "paragraph"})
    assert Guards.full_comment?(%{"object" => "comment", "created_by" => %{}})
    assert Guards.full_data_source?(%{"object" => "data_source"})
    assert Guards.full_database?(%{"object" => "database"})
    assert Guards.full_page?(%{"object" => "page", "url" => "https://www.notion.so/page"})

    assert Guards.full_page_or_data_source?(%{
             "object" => "page",
             "url" => "https://www.notion.so/page"
           })

    assert Guards.full_page_or_data_source?(%{"object" => "data_source"})
    assert Guards.full_user?(%{"object" => "user", "type" => "person"})
  end

  test "recognizes rich text response variants" do
    assert Guards.text_rich_text?(%{"type" => "text"})
    assert Guards.mention_rich_text?(%{"type" => "mention"})
    assert Guards.equation_rich_text?(%{"type" => "equation"})

    refute Guards.text_rich_text?(%{"type" => "mention"})
    refute Guards.full_page?(%{"object" => "page"})
  end
end
