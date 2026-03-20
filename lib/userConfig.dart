import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CONFIG extends ChangeNotifier {
  String get model => _model;
  String get modelSlug => _modelSlug;
  String _model = '';
  String _modelSlug = '';
  final apiKeyBox = GetStorage('api-keys');
  final preferencesBox = GetStorage('preferences');
  bool get shouldSendOnEnter => _shouldSendOnEnter;
  bool _shouldSendOnEnter = false;
  double get fontScale => _fontScale;
  double _fontScale = 1.0;
  loadPreferences() {
    String modelName = preferencesBox.read('preferredModel');
    _shouldSendOnEnter = preferencesBox.read('sendOnEnter');
    _model = modelName;
    _modelSlug = onlineModels[model] ?? '';
    _fontScale = preferencesBox.read('fontScale') ?? 1.0;
  }

  setToSendonEnter() {
    _shouldSendOnEnter = true;
    preferencesBox.write('sendOnEnter', true);
    notifyListeners();
  }

  setNotToSendOnEnter() {
    _shouldSendOnEnter = false;
    preferencesBox.write('sendOnEnter', false);
    notifyListeners();
  }

  setPreferredModel({required String modelName}) {
    preferencesBox.write('preferredModel', modelName);
    _model = modelName;
    _modelSlug = onlineModels[modelName] ?? '';
  }

  setFontScale(double scale) {
    _fontScale = scale;
    preferencesBox.write('fontScale', scale);
    notifyListeners();
  }

  getPreferreModel() {
    if (_model.length > 1) {
      Map<String, String> model = {'model': _model, 'model_slug': _modelSlug};
      return model;
    } else {
      String modelName = preferencesBox.read('preferredModel');
      Map<String, String> model = {
        'model': modelName,
        'model_slug': onlineModels[modelName]!
      };
      return model;
    }
  }
}
