import 'package:flutter/material.dart';

class ApikeyModalState extends ChangeNotifier {
  bool get displayModal => _displayModal;
  bool _displayModal = false;

  String get modelName => _modelName;
  String _modelName = '';
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
}
