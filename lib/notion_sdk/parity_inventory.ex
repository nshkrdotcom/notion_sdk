defmodule NotionSDK.ParityInventory do
  @moduledoc """
  Loads the committed bounded parity inventory for the vendored Notion JS SDK surface.
  """

  @type operation :: %{
          required(String.t()) => String.t()
        }

  @type inventory :: %{
          required(String.t()) => term()
        }

  @spec project_root() :: String.t()
  def project_root do
    Path.expand("../..", __DIR__)
  end

  @spec path(keyword()) :: String.t()
  def path(opts \\ []) when is_list(opts) do
    project_root = Keyword.get(opts, :project_root, project_root())

    case Keyword.fetch(opts, :inventory_path) do
      {:ok, inventory_path} when is_binary(inventory_path) -> inventory_path
      _other -> Path.join(project_root, "priv/upstream/parity_inventory.json")
    end
  end

  @spec load!(keyword()) :: inventory()
  def load!(opts \\ []) when is_list(opts) do
    opts
    |> path()
    |> File.read!()
    |> Jason.decode!()
    |> normalize_inventory()
  end

  @spec reference_pages(keyword()) :: [String.t()]
  def reference_pages(opts \\ []) when is_list(opts) do
    load!(opts)["reference_pages"]
  end

  @spec expected_operations(keyword()) :: [{String.t(), String.t(), String.t(), String.t()}]
  def expected_operations(opts \\ []) when is_list(opts) do
    opts
    |> load!()
    |> Map.fetch!("operations")
    |> Enum.map(fn operation ->
      {
        Map.fetch!(operation, "module"),
        Map.fetch!(operation, "function"),
        Map.fetch!(operation, "method"),
        Map.fetch!(operation, "path")
      }
    end)
    |> Enum.sort()
  end

  @spec summary(keyword()) :: inventory()
  def summary(opts \\ []) when is_list(opts) do
    inventory = load!(opts)

    %{
      "js_sdk" => Map.fetch!(inventory, "js_sdk"),
      "operation_count" => Map.fetch!(inventory, "operation_count"),
      "reference_pages" => Map.fetch!(inventory, "reference_pages")
    }
  end

  defp normalize_inventory(%{"js_sdk" => js_sdk, "operations" => operations} = inventory)
       when is_map(js_sdk) and is_list(operations) do
    normalized_operations = Enum.map(operations, &normalize_operation!/1)

    inventory
    |> Map.put("operations", normalized_operations)
    |> Map.put("operation_count", length(normalized_operations))
    |> Map.put("reference_pages", reference_pages_from_operations(normalized_operations))
  end

  defp normalize_inventory(_inventory) do
    raise ArgumentError,
          "parity inventory must include js_sdk metadata and an operations list"
  end

  defp normalize_operation!(
         %{
           "function" => function,
           "method" => method,
           "module" => module,
           "path" => path,
           "reference_page" => reference_page
         } = operation
       )
       when is_binary(function) and is_binary(method) and is_binary(module) and is_binary(path) and
              is_binary(reference_page) do
    operation
  end

  defp normalize_operation!(_operation) do
    raise ArgumentError,
          "parity inventory operations must include module, function, method, path, and reference_page"
  end

  defp reference_pages_from_operations(operations) do
    operations
    |> Enum.map(&Map.fetch!(&1, "reference_page"))
    |> Enum.uniq()
  end
end
