import 'dart:math';

import 'package:echo_llm/models/chats.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

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
  final chatBox = await Hive.openBox<Chat>('chats');

  try {
    chatBox.put(chat.id, chat);

    return chat.id;
  } catch (Error) {
    return false;
  }
}
