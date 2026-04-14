import 'package:echo_llm/dataHandlers/hive/hiveManager.dart';

Future<List<MapEntry<String, String>>> getChatLabelsAndIds() async {
  final chatBox = HiveManager.getChatBox();

  return chatBox.values
      .map((chat) => MapEntry(chat.id, chat.chatTitle))
      .toList();
}
