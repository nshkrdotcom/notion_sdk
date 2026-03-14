defmodule NotionSDK.GeneratedRuntime do
  @moduledoc false

  @spec build_schema(term()) :: term()
  def build_schema(fields) do
    module = runtime_module()
    module.build_schema(fields)
  end

  @spec decode_module_type(module(), atom(), term()) :: term()
  def decode_module_type(module, type, data) do
    runtime = runtime_module()
    runtime.decode_module_type(module, type, data)
  end

  defp runtime_module do
    Module.concat([Pristine, OpenAPI, Runtime])
  end
end
