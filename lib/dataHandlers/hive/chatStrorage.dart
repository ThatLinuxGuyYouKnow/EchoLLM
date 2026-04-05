import 'dart:math';

import 'package:echo_llm/dataHandlers/hive/hiveManager.dart';
import 'package:echo_llm/models/chats.dart';

saveChatLocally(
    {required List<Message> messages,
    required String chatTitle,
    required String existingChatID}) async {
  final dateTimeRighNow = DateTime.now();
  final randomPart = List.generate(3, (_) => Random().nextInt(1000)).join('');
  final chatID = dateTimeRighNow.toString() + randomPart;
  final chat = Chat()
    ..chatTitle = chatTitle
    ..id = existingChatID.isNotEmpty ? existingChatID : chatID
    ..lastModified = dateTimeRighNow
    ..messages = messages;
  final chatBox = HiveManager.getChatBox();

  try {
    chatBox.put(chat.id, chat);
    return chat.id;
  } catch (Error) {
    return false;
  }
}
