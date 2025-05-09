import 'package:flutter/material.dart';

class ApikeyModalState extends ChangeNotifier {
  bool get displayModal => _displayModal;
  bool _displayModal = false;
  setModalToVisible() {
    _displayModal = true;
    notifyListeners();
  }

  setModalToHidden() {
    _displayModal = false;
    notifyListeners();
  }
}
