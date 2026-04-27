import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:flutter/material.dart';
import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';

class KeysState extends ChangeNotifier {
  final ApiKeyHelper _apiKeyHelper = ApiKeyHelper();

  // Map of modelSlug -> apiKey
  Map<String, String> _modelKeys = {};
  Map<String, String> get modelKeys => _modelKeys;

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
    _modelKeys = await _apiKeyHelper.getAvailableModelKeyMap();
    _isLoaded = true;
    _updateAvailableModelsList();
    notifyListeners();
  }

  void _updateAvailableModelsList() {
    _availableModelSlugs = _modelKeys.keys.toList();

    _availableModelNames.clear();
    for (var slug in _availableModelSlugs) {
      final name = onlineModels.entries
          .firstWhere((entry) => entry.value == slug,
              orElse: () => const MapEntry('', ''))
          .key;
      if (name.isNotEmpty) {
        _availableModelNames.add(name);
      }
    }
  }

  Future<void> addKey({required String modelSlug, required String key}) async {
    await _apiKeyHelper.storeKey(modelSlugNotName: modelSlug, apiKey: key);
    _modelKeys[modelSlug] = key;
    _updateAvailableModelsList();
    notifyListeners();
  }

  Future<void> deleteKey({required String modelSlug}) async {
    await deleteKeyForModel(modelSlug: modelSlug);
    _modelKeys.remove(modelSlug);
    _updateAvailableModelsList();
    notifyListeners();
  }

  /// Reads a key directly from secure storage (always up-to-date).
  Future<String> getKeyForSlug(String modelSlug) async {
    return _apiKeyHelper.readKey(modelSlugNotName: modelSlug);
  }

  bool isModelAvailable(String modelSlug) {
    return _modelKeys.containsKey(modelSlug) &&
        _modelKeys[modelSlug]!.isNotEmpty;
  }
}
