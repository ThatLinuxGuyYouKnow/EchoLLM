import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:echo_llm/mappings/providerConfig.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson keeps explicit provider_id and api_id', () {
    final model = ModelInfo.fromJson({
      'name': 'Grok 4.6 (OpenCode Go)',
      'slug': 'grok-4.6-go',
      'Provider': 'OpenCode Go',
      'provider_id': 'opencode-go',
      'api_id': 'grok-4.6',
    });
    expect(model.providerId, ProviderIds.opencodeGo);
    expect(model.apiId, 'grok-4.6');
  });

  test('fromJson falls back for legacy payloads without new keys', () {
    final model = ModelInfo.fromJson({
      'name': 'Grok 4.6 (OpenCode Go)',
      'slug': 'grok-4.6-go',
      'Provider': 'OpenCode Go',
    });
    expect(model.providerId, ProviderIds.opencodeGo);
    expect(model.apiId, 'grok-4.6-go');
  });

  test('inferProviderId covers all display strings', () {
    expect(ModelInfo.inferProviderId('Google / DeepMind'), ProviderIds.google);
    expect(ModelInfo.inferProviderId('OpenAI'), ProviderIds.openai);
    expect(ModelInfo.inferProviderId('xAI'), ProviderIds.xai);
    expect(ModelInfo.inferProviderId('Anthropic'), ProviderIds.anthropic);
    expect(ModelInfo.inferProviderId('OpenCode Go'), ProviderIds.opencodeGo);
  });

  test('provider registry has unique ids and assets', () {
    final ids = kProviders.map((p) => p.id).toSet();
    expect(ids.length, kProviders.length);
    for (final p in kProviders) {
      expect(providerById(p.id), isNotNull);
      expect(providerStorageKey(p.id), 'provider:${p.id}');
    }
  });
}
