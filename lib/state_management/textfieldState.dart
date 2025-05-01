import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Textfieldstate extends ChangeNotifier {
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  expand() {
    _isExpanded = true;
    notifyListeners();
  }

  minimize() {
    _isExpanded = false;
    notifyListeners();
  }
}
