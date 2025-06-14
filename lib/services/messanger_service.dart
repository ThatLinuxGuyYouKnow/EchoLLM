import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';

// 1. Create the GlobalKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 2. Create a class to manage showing your toast
class MessengerService {
  void showToast(String message,
      {ToastMessageType type = ToastMessageType.passive}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      showCustomToast(context, message: message, type: type);
    }
  }
}
