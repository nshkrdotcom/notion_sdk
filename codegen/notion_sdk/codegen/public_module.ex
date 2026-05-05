defmodule NotionSDK.Codegen.PublicModule do
  @moduledoc false

  @spec from_source!(module() | nil) :: module()
  def from_source!(nil), do: NotionSDK

  def from_source!(module_name) when is_atom(module_name) do
    case Module.split(module_name) do
      ["NotionSDK"] ->
        NotionSDK

      ["NotionSDK" | segments] ->
        from_segments!(segments)

      segments ->
        from_segments!(segments)
    end
  end

  @spec from_provider_ir!(String.t()) :: module()
  def from_provider_ir!(public_name) when is_binary(public_name) do
    case String.split(public_name, ".") do
      ["NotionSDK"] ->
        NotionSDK

      ["NotionSDK" | segments] ->
        from_segments!(segments)

      _other ->
        raise ArgumentError, "unknown Notion SDK public module #{inspect(public_name)}"
    end
  end

  defp from_segments!([]), do: NotionSDK

  defp from_segments!(segments) do
    Module.safe_concat([NotionSDK | segments])
  end
end
