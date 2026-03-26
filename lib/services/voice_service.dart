import 'dart:async';

class VoiceService {
  bool _isReady = false;
  bool _isRecording = false;

  bool get isReady => _isReady;
  bool get isRecording => _isRecording;

  final StreamController<String> _partialResultController =
      StreamController<String>.broadcast();
  Stream<String> get partialResultStream => _partialResultController.stream;

  final StreamController<String> _finalResultController =
      StreamController<String>.broadcast();
  Stream<String> get finalResultStream => _finalResultController.stream;

  Future<void> initializeModel() async {
    _isReady = false;
  }

  Future<void> startRecording() async {}

  Future<void> stopRecording() async {}

  void dispose() {
    _partialResultController.close();
    _finalResultController.close();
  }
}
