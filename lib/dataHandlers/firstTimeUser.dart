import 'package:echo_llm/models/chats.dart';
import 'package:hive_flutter/hive_flutter.dart';

storeUserFirstTimeEntry() async {
  final chatBox = await Hive.openBox<Chat>('chats');
}
