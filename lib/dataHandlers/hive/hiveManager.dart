import 'package:echo_llm/models/chats.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveManager {
  static const String _chatBoxName = 'chats';

  static late Box<Chat> chatBox;

  static Future<void> init() async {
    Hive.registerAdapter(ChatAdapter());
    Hive.registerAdapter(MessageAdapter());
    chatBox = await Hive.openBox<Chat>(_chatBoxName);
  }

  static Box<Chat> getChatBox() => chatBox;
}
