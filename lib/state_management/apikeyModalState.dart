import 'package:flutter/material.dart';

class ApikeyModalState extends ChangeNotifier {
  bool get displayModal => _displayModal;
  bool _displayModal = false;
  String get modelSlug => _modelSlug;
  String get modelName => _modelName;
  String _modelName = '';
  String _modelSlug = '';
  setModalToVisible() {
    _displayModal = true;
    notifyListeners();
  }

  setModalToHidden() {
    _displayModal = false;
    notifyListeners();
  }

  setModelName({required String modelName}) {
    _modelName = modelName;
  }

  setModelSlug({required String modelSlug}) {
    _modelSlug = modelSlug;
  }
}
