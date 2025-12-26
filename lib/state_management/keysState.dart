import 'package:flutter/material.dart';
import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';
import 'package:echo_llm/mappings/modelSlugMappings.dart';

class KeysState extends ChangeNotifier {
  final ApiKeyHelper _apiKeyHelper = ApiKeyHelper();

  // Map of modelSlug -> apiKey
  Map<String, String> _modelKeys = {};
  Map<String, String> get modelKeys => _modelKeys;

  List<String> _availableModelSlugs = [];
  List<String> get availableModelSlugs => _availableModelSlugs;

  List<String> _availableModelNames = [];
  List<String> get availableModelNames => _availableModelNames;

  KeysState() {
    _loadKeys();
  }

  void _loadKeys() {
    _modelKeys = _apiKeyHelper.getAvailableModelKeyMap();
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
    deleteKeyForModel(
        modelSlug:
            modelSlug); // Uses the global function or we can move logic here
    _modelKeys.remove(modelSlug);
    _updateAvailableModelsList();
    notifyListeners();
  }

  bool isModelAvailable(String modelSlug) {
    return _modelKeys.containsKey(modelSlug) &&
        _modelKeys[modelSlug]!.isNotEmpty;
  }
}
