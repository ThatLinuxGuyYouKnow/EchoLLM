import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';
import 'package:echo_llm/mappings/modelDataService.dart';

final keyHandler = ApiKeyHelper();

Map<String, bool> onlineModelAvailability = {
  "gemini-2.5-pro":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.5-pro').length > 1,
  "gemini-2.5-flash":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.5-flash').length > 1,
  "gpt-4.1": keyHandler.readKey(modelSlugNotName: 'gpt-4.1').length > 1,
  "gpt-4o":
      keyHandler.readKey(modelSlugNotName: 'chatgpt-4o-latest').length > 1,
  'grok-3-beta': keyHandler.readKey(modelSlugNotName: 'grok-3-beta').length > 1,
  'grok-3-mini-beta':
      keyHandler.readKey(modelSlugNotName: 'grok-3-mini-beta').length > 1,
  "claude-3-7-sonnet":
      keyHandler.readKey(modelSlugNotName: 'claude-3-7-sonnet').length > 1,
  "claude-3-5-sonnet":
      keyHandler.readKey(modelSlugNotName: 'claude-3-5-sonnet').length > 1,
  "claude-3-7-Opus":
      keyHandler.readKey(modelSlugNotName: 'claude-3-7-Opus').length > 1,
  "clause 3-5 Opus":
      keyHandler.readKey(modelSlugNotName: 'clause 3-5 Opus').length > 1
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
    final modelName = ModelDataService().getNameBySlug(slug) ?? '';

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
