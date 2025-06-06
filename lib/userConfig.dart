import 'package:echo_llm/mappings/modelSlugMappings.dart';
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
  loadPreferences() {
    String modelName = preferencesBox.read('preferredModel');
    _shouldSendOnEnter = preferencesBox.read('sendOnEnter');
    _model = modelName;
    _modelSlug = onlineModels[model] ?? '';
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
