defmodule NotionSDK.CompatibilityContract do
  @moduledoc """
  Loads the committed Notion API compatibility contract for generated artifacts.
  """

  @type contract :: %{required(String.t()) => term()}

  @spec project_root() :: String.t()
  def project_root do
    Path.expand("../..", __DIR__)
  end

  @spec path(keyword()) :: String.t()
  def path(opts \\ []) when is_list(opts) do
    project_root = Keyword.get(opts, :project_root, project_root())

    case Keyword.fetch(opts, :contract_path) do
      {:ok, contract_path} when is_binary(contract_path) -> contract_path
      _other -> default_path(project_root)
    end
  end

  @spec load!(keyword()) :: contract()
  def load!(opts \\ []) when is_list(opts) do
    opts
    |> path()
    |> File.read!()
    |> Jason.decode!()
    |> normalize_contract()
  end

  defp normalize_contract(
         %{
           "default_notion_version" => default_notion_version,
           "known_seams" => known_seams,
           "opt_in_versions" => opt_in_versions,
           "policy" => policy
         } = contract
       )
       when is_binary(default_notion_version) and is_list(known_seams) and
              is_list(opt_in_versions) and
              is_map(policy) do
    contract
  end

  defp normalize_contract(_contract) do
    raise ArgumentError,
          "version contract must include default_notion_version, opt_in_versions, policy, and known_seams"
  end

  defp default_path(project_root) do
    project_path = Path.join(project_root, "priv/upstream/version_contract.json")
    bundled_path = Path.join(project_root(), "priv/upstream/version_contract.json")

    if File.exists?(project_path) do
      project_path
    else
      bundled_path
    end
  end
end
