import 'package:echo_llm/dataHandlers/heyHelper.dart';

import 'package:echo_llm/mappings/modelSlugMappings.dart';

final keyHandler = ApiKeyHelper();

Map<String, bool> onlineModelAvailability = {
  "gemini-2.5-pro":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.5-pro').length > 1,
  "gemini-2.5-flash":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.5-flash').length > 1,
  "gemini-2.0-flash":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.0-flash').length > 1,
  "gemini-2.0-flash-lite":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.0-flash-lite').length > 1,
  "gpt-4.1": keyHandler.readKey(modelSlugNotName: 'gpt-4.1').length > 1,
  "gpt-4o": keyHandler.readKey(modelSlugNotName: 'gpt-4o').length > 1,
  "grok-2-1212": keyHandler.readKey(modelSlugNotName: "grok-2-1212").length > 1,
  'grok-3-beta': keyHandler.readKey(modelSlugNotName: 'grok-3-beta').length > 1,
  'grok-3-mini-beta':
      keyHandler.readKey(modelSlugNotName: 'grok-3-mini-beta').length > 1
};
bool isAtleastOneModelAvailable() {
  List models = onlineModelAvailability.keys.toList();
  List<String> availableModels = [];
  for (var model in models) {
    String key = keyHandler.readKey(modelSlugNotName: model);
    if (key.isNotEmpty) {
      availableModels.add(model);
    }
  }
  return availableModels.isNotEmpty;
}

List<String> getAvailableModelsForUser() {
  final allSlugs = onlineModelAvailability.keys.toList();
  List<String> availableModelNames = [];

  final availableSlugs = allSlugs.where((slug) {
    return keyHandler.readKey(modelSlugNotName: slug).isNotEmpty;
  }).toList();

  // Reverse lookup: get model names from slugs
  for (var slug in availableSlugs) {
    final modelName = onlineModels.entries
        .firstWhere((entry) => entry.value == slug,
            orElse: () => const MapEntry('', ''))
        .key;

    if (modelName.isNotEmpty) {
      availableModelNames.add(modelName);
    }
  }

  // If no keys set, just show all names (not slugs)
  if (availableModelNames.isEmpty) {
    availableModelNames = onlineModels.keys.toList();
  }

  return availableModelNames;
}
