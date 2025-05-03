import 'package:flutter/material.dart';

class Messagestreamstate extends ChangeNotifier {
  List get messages => _messages;
  List<Map<int, String>> _messages = [];

  addMessage({required String message}) {
    int message_index =
        _messages.isNotEmpty ? _messages.last.keys.first + 1 : 1;

    _messages.add({message_index: message});
    notifyListeners();
  }
}
