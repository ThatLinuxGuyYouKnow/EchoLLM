import 'package:echo_llm/screens/mainScreen.dart';
import 'package:echo_llm/screens/modelScreen.dart';
import 'package:echo_llm/widgets/messageListWidget.dart';
import 'package:flutter/material.dart';

class Screenstate extends ChangeNotifier {
  Widget get currentScreen => _currentScreen;
  Widget _currentScreen = Messagelistwidget();

  modelScreen() {
    _currentScreen = ModelScreen();
    notifyListeners();
  }
}
