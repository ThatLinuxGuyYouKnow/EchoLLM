import 'package:flutter/material.dart';

class Textfieldstate extends ChangeNotifier {
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;
  bool get isVisible => _isVisible;
  bool _isVisible = true;
  makeVisible() {
    _isVisible = true;
    notifyListeners();
  }

  makeInvisible() {
    _isVisible = false;
    notifyListeners();
  }

  expand() {
    _isExpanded = true;
    notifyListeners();
  }

  minimize() {
    _isExpanded = false;
    notifyListeners();
  }
}
