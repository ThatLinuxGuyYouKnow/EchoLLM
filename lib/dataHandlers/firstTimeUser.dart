import 'package:get_storage/get_storage.dart';

storeUserFirstTimeEntry() async {
  final box = GetStorage('preferences');
  print('attempting to store entry');

  try {
    box.write('isUserNew', false);
    print('stored user entry');
  } catch (error) {
    print(error.toString());
  }
  ;
}

bool isFirstTimeUser() {
  final box = GetStorage('preferences');
  return true;
}
