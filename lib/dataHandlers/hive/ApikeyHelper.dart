import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:echo_llm/mappings/providerConfig.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyHelper {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ──────────────── Provider-scoped keys (current) ────────────────

  Future<void> storeProviderKey({
    required String providerId,
    required String apiKey,
  }) async {
    try {
      await _storage.write(key: providerStorageKey(providerId), value: apiKey);
    } catch (_) {}
  }

  Future<String> readProviderKey({required String providerId}) async {
    try {
      return await _storage.read(key: providerStorageKey(providerId)) ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> deleteProviderKey({required String providerId}) async {
    try {
      await _storage.delete(key: providerStorageKey(providerId));
    } catch (_) {}
  }

  Future<Map<String, String>> getAvailableProviderKeyMap() async {
    final result = <String, String>{};
    for (final provider in kProviders) {
      final key = await readProviderKey(providerId: provider.id);
      if (key.isNotEmpty) result[provider.id] = key;
    }
    return result;
  }

  // ──────────────── Legacy per-model-slug keys (migration only) ────────────────
  //
  // Keys used to be stored once per model slug. They are auto-migrated to one
  // key per provider on load: the first stored slug-key found for a provider
  // becomes that provider's key, then the consumed legacy entries are
  // removed. Unknown slugs are left untouched.

  Future<Map<String, String>> migrateLegacyKeys() async {
    final migrated = <String, String>{};
    late Map<String, String> all;
    try {
      all = await _storage.readAll();
    } catch (_) {
      return migrated;
    }

    final service = ModelDataService();
    for (final entry in all.entries) {
      if (entry.key.startsWith('provider:')) continue;
      if (entry.value.isEmpty) continue;
      final providerId = service.getProviderId(entry.key);
      if (providerId.isEmpty) continue;
      if (migrated.containsKey(providerId)) continue;
      final existing = await readProviderKey(providerId: providerId);
      if (existing.isEmpty) {
        await storeProviderKey(providerId: providerId, apiKey: entry.value);
        migrated[providerId] = entry.value;
      }
    }

    for (final entry in all.entries) {
      if (entry.key.startsWith('provider:')) continue;
      final providerId = service.getProviderId(entry.key);
      if (providerId.isEmpty) continue;
      final current = await readProviderKey(providerId: providerId);
      if (current.isNotEmpty) {
        try {
          await _storage.delete(key: entry.key);
        } catch (_) {}
      }
    }
    return migrated;
  }
}

Future<void> deleteKeyForModel({required String modelSlug}) async {
  // Legacy helper kept for compatibility: removes a stale per-slug entry.
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  try {
    await storage.delete(key: modelSlug);
  } catch (_) {}
}
