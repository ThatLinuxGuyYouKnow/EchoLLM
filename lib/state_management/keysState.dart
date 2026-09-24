import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:echo_llm/mappings/providerConfig.dart';
import 'package:flutter/material.dart';
import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';

class KeysState extends ChangeNotifier {
  final ApiKeyHelper _apiKeyHelper = ApiKeyHelper();

  // Map of providerId -> apiKey (one key per provider).
  Map<String, String> _providerKeys = {};
  Map<String, String> get providerKeys => _providerKeys;

  List<String> _availableModelSlugs = [];
  List<String> get availableModelSlugs => _availableModelSlugs;

  List<String> _availableModelNames = [];
  List<String> get availableModelNames => _availableModelNames;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  KeysState() {
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    // One-time upgrade: fold legacy per-model keys into provider keys.
    try {
      await _apiKeyHelper.migrateLegacyKeys();
    } catch (_) {}
    _providerKeys = await _apiKeyHelper.getAvailableProviderKeyMap();
    _isLoaded = true;
    _updateAvailableModelsList();
    notifyListeners();
  }

  void _updateAvailableModelsList() {
    final service = ModelDataService();
    _availableModelSlugs = [
      for (final slug in service.modelSlugs)
        if (_providerKeys.containsKey(service.getProviderId(slug))) slug,
    ];
    _availableModelNames = [
      for (final slug in _availableModelSlugs)
        service.getNameBySlug(slug) ?? slug,
    ];
  }

  Future<void> addProviderKey({
    required String providerId,
    required String key,
  }) async {
    await _apiKeyHelper.storeProviderKey(providerId: providerId, apiKey: key);
    _providerKeys[providerId] = key;
    _updateAvailableModelsList();
    notifyListeners();
  }

  Future<void> deleteProviderKey({required String providerId}) async {
    await _apiKeyHelper.deleteProviderKey(providerId: providerId);
    _providerKeys.remove(providerId);
    _updateAvailableModelsList();
    notifyListeners();
  }

  /// Reads a provider key directly from secure storage (always up-to-date).
  Future<String> getKeyForProvider(String providerId) async {
    return _apiKeyHelper.readProviderKey(providerId: providerId);
  }

  bool isProviderAvailable(String providerId) {
    return _providerKeys.containsKey(providerId) &&
        _providerKeys[providerId]!.isNotEmpty;
  }

  bool isModelAvailable(String modelSlug) {
    final providerId = ModelDataService().getProviderId(modelSlug);
    if (providerId.isEmpty) return false;
    return isProviderAvailable(providerId);
  }

  /// Display names of providers that currently have a key.
  List<String> get availableProviderNames => [
        for (final p in kProviders)
          if (isProviderAvailable(p.id)) p.displayName,
      ];
}
