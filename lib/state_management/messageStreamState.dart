import 'package:flutter/material.dart';

class Messagestreamstate extends ChangeNotifier {
  List<Map<int, String>> _messages = [];
  bool _isProcessing = false;

  List<Map<int, String>> get messages => _messages;
  bool get isProcessing => _isProcessing;

  addMessage({required String message}) {
    int messageIndex = _messages.isNotEmpty ? _messages.last.keys.first + 1 : 0;
    _messages.add({messageIndex: message});
    notifyListeners();
  }

  setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }

  clear() {
    _messages.clear();
    notifyListeners();
  }
}
