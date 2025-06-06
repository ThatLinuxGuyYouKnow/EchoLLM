import 'package:echo_llm/models/chats.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

storeUserFirstTimeEntry() async {
  final box = GetStorage('preferences');
  print('attempting to store entry');

  try {
    box.write('isUserNew', false);
    print('stored user entry'); //this never hits
  } catch (error) {
    print(error.toString()); // but neither does this??
  }
  ;
}

bool isFirstTimeUser() {
  final box = GetStorage('preferences');
  return true;
}
