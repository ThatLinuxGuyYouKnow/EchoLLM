/// First-class provider registry.
///
/// Identity in the app is now `providerId` + model slug. API keys are stored
/// once per provider (not once per model), and inference routing switches on
/// [ProviderInfo.id].
class ProviderInfo {
  final String id;
  final String displayName;
  final String iconAsset;
  final String brandingAsset;
  final String keyUrl;
  final String keyHint;

  const ProviderInfo({
    required this.id,
    required this.displayName,
    required this.iconAsset,
    required this.brandingAsset,
    required this.keyUrl,
    required this.keyHint,
  });
}

/// Canonical provider ids. Keep in sync with `provider_id` in modelData.json.
class ProviderIds {
  static const String google = 'google';
  static const String openai = 'openai';
  static const String xai = 'xai';
  static const String anthropic = 'anthropic';
  static const String opencodeGo = 'opencode-go';
}

/// Display/grouping order. Existing direct providers first (stable tile
/// order), OpenCode Go last.
const List<ProviderInfo> kProviders = [
  ProviderInfo(
    id: ProviderIds.google,
    displayName: 'Google',
    iconAsset: 'assets/model_icons/gemini-icon.png',
    brandingAsset: 'assets/branding/gemini.png',
    keyUrl: 'https://aistudio.google.com/apikey',
    keyHint: 'Google AI Studio API key',
  ),
  ProviderInfo(
    id: ProviderIds.openai,
    displayName: 'OpenAI',
    iconAsset: 'assets/model_icons/openai-icon.png',
    brandingAsset: 'assets/branding/openai.png',
    keyUrl: 'https://platform.openai.com/api-keys',
    keyHint: 'OpenAI API key',
  ),
  ProviderInfo(
    id: ProviderIds.xai,
    displayName: 'xAI',
    iconAsset: 'assets/model_icons/xai-icon.png',
    brandingAsset: 'assets/branding/grok4.png',
    keyUrl: 'https://console.x.ai',
    keyHint: 'xAI API key',
  ),
  ProviderInfo(
    id: ProviderIds.anthropic,
    displayName: 'Anthropic',
    iconAsset: 'assets/model_icons/claude-icon.png',
    brandingAsset: 'assets/branding/claude-branding.png',
    keyUrl: 'https://console.anthropic.com/settings/keys',
    keyHint: 'Anthropic API key',
  ),
  ProviderInfo(
    id: ProviderIds.opencodeGo,
    displayName: 'OpenCode Go',
    iconAsset: 'assets/model_icons/opencode-icon.png',
    brandingAsset: 'assets/branding/opencode.png',
    keyUrl: 'https://opencode.ai/auth',
    keyHint: 'OpenCode Go API key (\$10/mo subscription)',
  ),
];

ProviderInfo? providerById(String id) {
  for (final p in kProviders) {
    if (p.id == id) return p;
  }
  return null;
}

/// Secure-storage key for a provider's API key.
String providerStorageKey(String providerId) => 'provider:$providerId';
