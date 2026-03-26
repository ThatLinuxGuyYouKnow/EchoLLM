import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vosk_flutter/vosk_flutter.dart';
import 'dart:convert';

class VoiceService {
  final VoskFlutterPlugin _vosk = VoskFlutterPlugin.instance();
  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;
  
  bool _isInitializing = false;
  bool _isReady = false;
  bool _isRecording = false;

  bool get isReady => _isReady;
  bool get isRecording => _isRecording;

  final StreamController<String> _partialResultController = StreamController<String>.broadcast();
  Stream<String> get partialResultStream => _partialResultController.stream;

  final StreamController<String> _finalResultController = StreamController<String>.broadcast();
  Stream<String> get finalResultStream => _finalResultController.stream;

  Future<void> initializeModel() async {
    if (_isInitializing || _isReady) return;
    _isInitializing = true;
    
    // Check permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      _isInitializing = false;
      return;
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      // Assuming zip contains folder 'vosk-model-small-en-us-0.15/'
      final modelPath = '${appDir.path}/vosk-model-small-en-us-0.15';
      
      final modelDir = Directory(modelPath);
      if (!await modelDir.exists()) {
        print('Unzipping Vosk model...');
        final zipByteData = await rootBundle.load('assets/models/vosk-model-small-en-us-0.15.zip');
        final zipBytes = zipByteData.buffer.asUint8List();
        
        final archive = ZipDecoder().decodeBytes(zipBytes);
        for (final file in archive) {
          final filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            File('${appDir.path}/$filename')
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else {
            Directory('${appDir.path}/$filename').createSync(recursive: true);
          }
        }
        print('Unzipped Vosk model.');
      }

      print('Loading Vosk model...');
      _model = await _vosk.createModel(modelPath);
      _recognizer = await _vosk.createRecognizer(
        model: _model!, 
        sampleRate: 16000,
      );
      _isReady = true;
      print('Vosk model loaded successfully.');
    } catch (e) {
      print('Error initializing Vosk: $e');
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> startRecording() async {
    if (!_isReady || _recognizer == null) {
      await initializeModel();
      if (!_isReady || _recognizer == null) return;
    }
    if (_isRecording) return;

    try {
      _speechService = await _vosk.initSpeechService(_recognizer!);
      _speechService!.onPartial().listen((event) {
        try {
          final map = jsonDecode(event) as Map<String, dynamic>;
          final text = map['partial'] as String?;
          if (text != null && text.isNotEmpty) {
            _partialResultController.add(text);
          }
        } catch (_) {}
      });
      _speechService!.onResult().listen((event) {
        try {
          final map = jsonDecode(event) as Map<String, dynamic>;
          final text = map['text'] as String?;
          if (text != null && text.isNotEmpty) {
            _finalResultController.add(text);
          }
        } catch (_) {}
      });
      await _speechService!.start();
      _isRecording = true;
    } catch (e) {
      print('Error starting Vosk recording: $e');
    }
  }

  Future<void> stopRecording() async {
    if (!_isRecording || _speechService == null) return;
    
    try {
      await _speechService!.stop();
      await _speechService!.dispose();
      _speechService = null;
    } catch (e) {
      print('Error stopping Vosk recording: $e');
    } finally {
      _isRecording = false;
    }
  }

  void dispose() {
    _partialResultController.close();
    _finalResultController.close();
    _recognizer?.dispose();
    _model?.dispose();
  }
}
