import 'package:get_storage/get_storage.dart';

class ApiKeyHelper {
  storeKey({required String modelSlugNotName, required String apiKey}) async {
    final box = GetStorage();
    try {
      box.write(modelSlugNotName, apiKey);
      return true;
    } catch (error) {
      return false;
    }
  }

  String readKey({required String modelSlugNotName}) {
    final box = GetStorage();
    final key = box.read(modelSlugNotName);
    return key ?? '';
  }
}
