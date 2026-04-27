import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyHelper {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> storeKey(
      {required String modelSlugNotName, required String apiKey}) async {
    try {
      await _storage.write(key: modelSlugNotName, value: apiKey);
    } catch (_) {}
  }

  Future<String> readKey({required String modelSlugNotName}) async {
    try {
      return await _storage.read(key: modelSlugNotName) ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<Map<String, String>> getAvailableModelKeyMap() async {
    final result = <String, String>{};
    final uniqueSlugs = onlineModels.values.toSet();

    for (var modelSlug in uniqueSlugs) {
      final key = await readKey(modelSlugNotName: modelSlug);
      if (key.isNotEmpty) {
        result[modelSlug] = key;
      }
    }

    return result;
  }
}

Future<void> deleteKeyForModel({required String modelSlug}) async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  await storage.delete(key: modelSlug);
}
