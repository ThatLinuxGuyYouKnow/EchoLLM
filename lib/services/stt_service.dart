import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vosk_flutter/vosk_flutter.dart';
import 'package:record/record.dart';

class SttService extends ChangeNotifier {
  static const String _modelUrl =
      'https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip';
  static const String _preferencesKey = 'stt_model_downloaded';

  final VoskFlutterPlugin _vosk = VoskFlutterPlugin.instance();
  final AudioRecorder _recorder = AudioRecorder();
  final GetStorage _prefs = GetStorage('preferences');

  bool _isModelReady = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _modelPath;

  bool get isModelReady => _isModelReady;
  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;

  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;
  StreamSubscription? _resultSubscription;
  StreamSubscription? _partialSubscription;

  Future<String> _getModelDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/models';
  }

  Future<bool> isModelDownloaded() async {
    try {
      final modelLoader = ModelLoader(modelStorage: await _getModelDirectory());
      return await modelLoader
          .isModelAlreadyLoaded('vosk-model-small-en-us-0.15');
    } catch (_) {
      return false;
    }
  }

  Future<void> downloadModel() async {
    if (_isDownloading || _isModelReady) return;

    _isDownloading = true;
    _downloadProgress = 0.0;
    notifyListeners();

    try {
      final modelLoader =
          ModelLoader(modelStorage: await _getModelDirectory());
      _modelPath = await modelLoader.loadFromNetwork(_modelUrl);
      _isModelReady = true;
      _prefs.write(_preferencesKey, true);
    } catch (e) {
      _isModelReady = false;
      try {
        final stillLoaded = await isModelDownloaded();
        if (stillLoaded) {
          final modelLoader =
              ModelLoader(modelStorage: await _getModelDirectory());
          _modelPath = await modelLoader
              .modelPath('vosk-model-small-en-us-0.15');
          _isModelReady = true;
        }
      } catch (_) {}
    } finally {
      _isDownloading = false;
      _downloadProgress = 1.0;
      notifyListeners();
    }
  }

  Future<void> _ensureModelInitialized() async {
    if (_recognizer != null) return;

    if (!_isModelReady) {
      if (!await isModelDownloaded()) {
        await downloadModel();
      } else {
        final modelLoader =
            ModelLoader(modelStorage: await _getModelDirectory());
        _modelPath = await modelLoader
            .modelPath('vosk-model-small-en-us-0.15');
        _isModelReady = true;
      }
    }

    if (!_isModelReady || _modelPath == null) return;

    try {
      _model = await _vosk.createModel(_modelPath!);
      _recognizer = await _vosk.createRecognizer(
        model: _model!,
        sampleRate: 16000,
      );
    } catch (e) {
      _recognizer = null;
    }
  }

  Future<String> transcribe() async {
    if (!await _recorder.hasPermission()) {
      return '';
    }

    await _ensureModelInitialized();
    if (_recognizer == null) return '';

    try {
      if (Platform.isAndroid) {
        return await _transcribeAndroid();
      } else {
        return await _transcribeDesktop();
      }
    } catch (e) {
      return '';
    }
  }

  Future<String> _transcribeAndroid() async {
    final completer = Completer<String>();

    _speechService = await _vosk.initSpeechService(_recognizer!);
    _partialSubscription =
        _speechService!.onPartial().listen((_) {});
    _resultSubscription = _speechService!.onResult().listen((result) {
      final text = _extractTextFromJson(result);
      if (!completer.isCompleted && text.isNotEmpty) {
        completer.complete(text);
      }
    });

    await _speechService!.start();

    final result = await completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => '',
    );

    await _speechService!.stop();
    _resultSubscription?.cancel();
    _partialSubscription?.cancel();

    return result;
  }

  Future<String> _transcribeDesktop() async {
    final appDir = await getApplicationSupportDirectory();
    final recordingPath = '${appDir.path}/stt_temp.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: recordingPath,
    );

    await Future.delayed(const Duration(seconds: 5));

    await _recorder.stop();

    final file = File(recordingPath);
    if (!await file.exists()) return '';

    try {
      final bytes = await file.readAsBytes();
      await _recognizer!.acceptWaveformBytes(bytes);
      final jsonResult = await _recognizer!.getFinalResult();
      final result = _extractTextFromJson(jsonResult);

      await _recognizer!.reset();
      return result;
    } catch (_) {
      return '';
    } finally {
      try {
        await file.delete();
      } catch (_) {}
    }
  }

  String _extractTextFromJson(String jsonResult) {
    try {
      final textMatch =
          RegExp(r'"text"\s*:\s*"([^"]*)"').firstMatch(jsonResult);
      if (textMatch != null) {
        return textMatch.group(1)?.trim() ?? '';
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  @override
  void dispose() {
    _resultSubscription?.cancel();
    _partialSubscription?.cancel();
    _recorder.dispose();
    _model?.dispose();
    _recognizer?.dispose();
    super.dispose();
  }
}