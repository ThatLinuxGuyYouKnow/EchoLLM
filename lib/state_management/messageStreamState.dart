import 'package:flutter/material.dart';

class Messagestreamstate extends ChangeNotifier {
  List<Map<int, String>> _messages = [];
  bool _isProcessing = false;

  List<Map<int, String>> get messages => _messages;
  bool get isProcessing => _isProcessing;

  String get chatID => _chatID;
  String _chatID = '';
  addMessage({required String message}) {
    int messageIndex = _messages.isNotEmpty ? _messages.last.keys.first + 1 : 0;
    _messages.add({messageIndex: message});
    notifyListeners();
  }

  setMessages({required List<Map<int, String>> newMessageList}) {
    _messages = newMessageList;
  }

  setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }

  clear() {
    _messages.clear();
    notifyListeners();
  }

  setCurrentChatID(String chatid) {
    _chatID = chatid;
    notifyListeners();
  }
}
