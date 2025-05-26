import 'package:echo_llm/mappings/modelAvailabilityMapping.dart';

import 'package:get_storage/get_storage.dart';

class ApiKeyHelper {
  final box = GetStorage('api-keys');
  storeKey({required String modelSlugNotName, required String apiKey}) async {
    try {
      await box.write(modelSlugNotName, apiKey);
      return true;
    } catch (error) {
      return false;
    }
  }

  String readKey({required String modelSlugNotName}) {
    final String key = box.read(modelSlugNotName) ?? '';
    key.length > 1
        ? print('key for ' + modelSlugNotName + "is not null")
        : print('key is null for ' + modelSlugNotName);
    return key;
  }

  Map<String, String> getAvailableModelKeyMap() {
    final result = <String, String>{};

    onlineModelAvailability.forEach((modelSlug, isAvailable) {
      if (isAvailable) {
        final key = readKey(modelSlugNotName: modelSlug);
        if (key.isNotEmpty) {
          result[modelSlug] = key;
        }
      }
    });

    return result;
  }
}
