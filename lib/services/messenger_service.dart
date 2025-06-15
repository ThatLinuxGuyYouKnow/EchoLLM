import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MessengerService {
  void showToast(String message,
      {ToastMessageType type = ToastMessageType.passive}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      showCustomToast(context, message: message, type: type);
    }
  }
}
