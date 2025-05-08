import 'package:echo_llm/screens/mainScreen.dart';
import 'package:echo_llm/screens/modelScreen.dart';
import 'package:flutter/material.dart';

class Screenstate extends ChangeNotifier {
  Widget get currentScreen => _currentScreen;
  Widget _currentScreen = MainScreen();

  modelScreen() {
    _currentScreen = ModelScreen();
  }
}
