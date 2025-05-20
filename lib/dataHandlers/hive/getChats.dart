import 'package:echo_llm/models/chats.dart';
import 'package:hive/hive.dart';

Future<List<MapEntry<String, String>>> getChatLabelsAndIds() async {
  final chatBox = await Hive.openBox<Chat>('chats');

  return chatBox.values
      .map((chat) => MapEntry(chat.id, chat.chatTitle))
      .toList();
}
