import 'package:flutter/material.dart';
import 'package:echo_llm/services/stt_service.dart';

class SttState extends ChangeNotifier {
  final SttService _sttService = SttService();
  bool _isListening = false;

  bool get isListening => _isListening;
  SttService get sttService => _sttService;

  Future<String> transcribe() async {
    _isListening = true;
    notifyListeners();

    final result = await _sttService.transcribe();

    _isListening = false;
    notifyListeners();
    return result;
  }

  Future<void> downloadModel() async {
    _sttService.addListener(_onDownloadProgress);
    await _sttService.downloadModel();
    _sttService.removeListener(_onDownloadProgress);
  }

  void _onDownloadProgress() {
    if (_sttService.isModelReady) {
      notifyListeners();
    }
  }
}