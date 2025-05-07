import 'package:flutter/material.dart';

class Sidebarstate extends ChangeNotifier {
  bool get isCollapsed => _isCollapsed;
  bool _isCollapsed = false;

  collapse() {
    _isCollapsed = true;
    notifyListeners();
  }

  expand() {
    _isCollapsed = false;
    notifyListeners();
  }
}
