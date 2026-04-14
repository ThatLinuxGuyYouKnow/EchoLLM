import 'package:get_storage/get_storage.dart';

storeUserFirstTimeEntry() async {
  final box = GetStorage('preferences');

  try {
    box.write('isUserNew', false);
  } catch (error) {}
}

bool isFirstTimeUser() {
  final box = GetStorage('preferences');
  return box.read('isUserNew') ?? true;
}
