import 'package:echo_llm/models/chats.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

storeUserFirstTimeEntry() async {
  final box = GetStorage('preferences');
  box.write('isUserNew', false);
}

bool isFirstTimeUser() {
  final box = GetStorage('preferences');
  return box.read('isUserNew') ?? true;
}
