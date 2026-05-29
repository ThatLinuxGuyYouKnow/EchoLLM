import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';
import 'package:echo_llm/mappings/modelDataService.dart';

final keyHandler = ApiKeyHelper();

Map<String, bool> onlineModelAvailability = {
  "gemini-3.5-flash":
      keyHandler.readKey(modelSlugNotName: 'gemini-3.5-flash').length > 1,
  "gemini-3.1-pro-preview":
      keyHandler.readKey(modelSlugNotName: 'gemini-3.1-pro-preview').length > 1,
  "gemini-2.5-pro":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.5-pro').length > 1,
  "gemini-2.5-flash":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.5-flash').length > 1,
  "gpt-5-5": keyHandler.readKey(modelSlugNotName: 'gpt-5-5').length > 1,
  "gpt-5-4": keyHandler.readKey(modelSlugNotName: 'gpt-5-4').length > 1,
  "gpt-5-4-mini":
      keyHandler.readKey(modelSlugNotName: 'gpt-5-4-mini').length > 1,
  "grok-4-3": keyHandler.readKey(modelSlugNotName: 'grok-4-3').length > 1,
  "grok-4-20": keyHandler.readKey(modelSlugNotName: 'grok-4-20').length > 1,
  "claude-sonnet-4-6":
      keyHandler.readKey(modelSlugNotName: 'claude-sonnet-4-6').length > 1,
  "claude-opus-4-8":
      keyHandler.readKey(modelSlugNotName: 'claude-opus-4-8').length > 1,
  "claude-haiku-4-5":
      keyHandler.readKey(modelSlugNotName: 'claude-haiku-4-5').length > 1,
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
