import 'package:echo_llm/screens/keyManagementScreen.dart';

import 'package:echo_llm/screens/modelScreen.dart';
import 'package:echo_llm/screens/settingsScreen.dart';
import 'package:echo_llm/screens/welcomeScreen.dart';
import 'package:echo_llm/widgets/messageListWidget.dart';
import 'package:flutter/material.dart';

class Screenstate extends ChangeNotifier {
  Widget get currentScreen => _currentScreen;
  Widget _currentScreen = WelcomeScreen();
  bool get isOnWelcomeScreen => _currentScreen is WelcomeScreen;
  bool get isOnMainScreen => _currentScreen is Messagelistwidget;
  bool get isOnSettingsScreen => _currentScreen is SettingsScreen;
  modelScreen() {
    _currentScreen = ModelScreen();
    notifyListeners();
  }

  chatScreen() {
    _currentScreen = Messagelistwidget();
    notifyListeners();
  }

  settingsScreen() {
    _currentScreen = SettingsScreen();
    notifyListeners();
  }

  keyManagementScreen() {
    _currentScreen = KeyManagementScreen();
    notifyListeners();
  }
}
