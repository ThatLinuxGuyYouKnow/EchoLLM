import 'package:get_storage/get_storage.dart';

class ApiKeyHelper {
  storeKey({required String modelSlugNotName, required String apiKey}) async {
    final box = GetStorage();
    box.write(modelSlugNotName, apiKey);
  }

  readKey({required String modelSlugNotName}) {
    final box = GetStorage();
    box.read(modelSlugNotName);
  }
}
