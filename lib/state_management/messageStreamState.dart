import 'package:flutter/material.dart';

class Messagestreamstate extends ChangeNotifier {
  List<Map<int, String>> _messages = [];
  bool _isProcessing = false;
  bool _isStreaming = false;

  List<Map<int, String>> get messages => _messages;
  bool get isProcessing => _isProcessing;
  bool get isStreaming => _isStreaming;

  String get chatID => _chatID;
  String _chatID = '';

  addMessage({required String message}) {
    int messageIndex =
        _messages.isNotEmpty ? _messages.last.keys.first + 1 : 0;
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

  deleteUserLastMessage() {
    if (_messages.isNotEmpty) {
      _messages.removeLast();
    }
  }

  // ──────────────── Streaming helpers ────────────────

  /// Start a new empty assistant message at the end of the list and return
  /// its index so tokens can be appended to it.
  int beginStreamingMessage() {
    int messageIndex =
        _messages.isNotEmpty ? _messages.last.keys.first + 1 : 0;
    _messages.add({messageIndex: ''});
    _isStreaming = true;
    _isProcessing = true;
    notifyListeners();
    return messageIndex;
  }

  /// Append a token chunk to the streaming message identified by [index].
  void appendStreamToken(int index, String token) {
    final msgIdx = _messages.indexWhere((m) => m.containsKey(index));
    if (msgIdx == -1) return;
    final current = _messages[msgIdx][index] ?? '';
    _messages[msgIdx] = {index: current + token};
    notifyListeners();
  }

  /// Finalise streaming – mark as done and return the full accumulated text.
  String finishStreamingMessage(int index) {
    _isStreaming = false;
    _isProcessing = false;
    final msgIdx = _messages.indexWhere((m) => m.containsKey(index));
    if (msgIdx == -1) return '';
    final text = _messages[msgIdx][index] ?? '';
    notifyListeners();
    return text;
  }

  /// Remove the streaming placeholder if an error occurred.
  void cancelStreamingMessage(int index) {
    _messages.removeWhere((m) => m.containsKey(index));
    _isStreaming = false;
    _isProcessing = false;
    notifyListeners();
  }
}
