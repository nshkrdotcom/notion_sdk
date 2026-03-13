defmodule NotionSDK.Guards do
  @moduledoc """
  Runtime guards for distinguishing Notion full objects from partial objects.
  """

  @spec full_block?(map()) :: boolean()
  def full_block?(%{"object" => "block", "type" => _}), do: true
  def full_block?(_response), do: false

  @spec full_comment?(map()) :: boolean()
  def full_comment?(%{"created_by" => _, "object" => "comment"}), do: true
  def full_comment?(_response), do: false

  @spec full_data_source?(map()) :: boolean()
  def full_data_source?(%{"object" => "data_source"}), do: true
  def full_data_source?(_response), do: false

  @spec full_database?(map()) :: boolean()
  def full_database?(%{"object" => "database"}), do: true
  def full_database?(_response), do: false

  @spec full_page?(map()) :: boolean()
  def full_page?(%{"object" => "page", "url" => _}), do: true
  def full_page?(_response), do: false

  @spec full_page_or_data_source?(map()) :: boolean()
  def full_page_or_data_source?(response), do: full_page?(response) or full_data_source?(response)

  @spec full_user?(map()) :: boolean()
  def full_user?(%{"object" => "user", "type" => _}), do: true
  def full_user?(_response), do: false

  @spec equation_rich_text?(map()) :: boolean()
  def equation_rich_text?(%{"type" => "equation"}), do: true
  def equation_rich_text?(_rich_text), do: false

  @spec mention_rich_text?(map()) :: boolean()
  def mention_rich_text?(%{"type" => "mention"}), do: true
  def mention_rich_text?(_rich_text), do: false

  @spec text_rich_text?(map()) :: boolean()
  def text_rich_text?(%{"type" => "text"}), do: true
  def text_rich_text?(_rich_text), do: false
end
