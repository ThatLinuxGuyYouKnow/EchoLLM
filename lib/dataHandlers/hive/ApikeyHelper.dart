import 'package:echo_llm/mappings/modelDataService.dart';

import 'package:get_storage/get_storage.dart';

class ApiKeyHelper {
  final box = GetStorage('api-keys');
  storeKey({required String modelSlugNotName, required String apiKey}) async {
    try {
      await box.write(modelSlugNotName, apiKey);
      print('Stored API key for $modelSlugNotName');
    } catch (error) {}
  }

  String readKey({required String modelSlugNotName}) {
    final String key = box.read(modelSlugNotName) ?? '';

    return key;
  }

  Map<String, String> getAvailableModelKeyMap() {
    final result = <String, String>{};
    final uniqueSlugs = onlineModels.values.toSet();

    for (var modelSlug in uniqueSlugs) {
      final key = readKey(modelSlugNotName: modelSlug);
      if (key.isNotEmpty) {
        result[modelSlug] = key;
      }
    }

    return result;
  }
}

deleteKeyForModel({required String modelSlug}) {
  final box = GetStorage('api-keys');
  box.remove(modelSlug);
}
