defmodule NotionSDK.ResultClassifier do
  @moduledoc false

  @behaviour Pristine.Ports.ResultClassifier

  alias NotionSDK.ProviderProfile
  alias Pristine.Adapters.ResultClassifier.HTTP
  alias Pristine.SDK.Context

  @impl true
  def classify(result, endpoint, context, opts) do
    HTTP.classify(result, endpoint, ensure_provider_profile(context), opts)
  end

  defp ensure_provider_profile(nil), do: Context.new(provider_profile: ProviderProfile.profile())

  defp ensure_provider_profile(context) when is_map(context) do
    case Map.get(context, :provider_profile) do
      nil -> Map.put(context, :provider_profile, ProviderProfile.profile())
      _profile -> context
    end
  end

  defp ensure_provider_profile(_context),
    do: Context.new(provider_profile: ProviderProfile.profile())
end
