import 'dart:convert';

import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Geminihelper {
  String modelSlug;
  String apiKey;
  BuildContext context;
  Geminihelper(
      {required this.modelSlug, required this.apiKey, required this.context});
  getResponse() async {
    var response = await http.get(Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/${modelSlug}:generateContent?key=${apiKey}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      String modelResponse =
          data['candidates'][0]['content']['parts'][0]['text'];
      if (modelResponse.length > 1) {
        return modelResponse;
      }
    } else if (response.statusCode == 403) {
      showCustomToast(
        context,
        message: "Couldn't reach Gemini, your api key likekly isnt valid",
        type: ToastMessageType.error,
        duration: Duration(seconds: 5),
      );
    } else if (response.statusCode == 500 | 504) {
      showCustomToast(
        context,
        message:
            "An error occured while processing your prompt, your chat is likely getting too long",
        type: ToastMessageType.error,
        duration: Duration(seconds: 5),
      );
    } else {
      showCustomToast(context,
          message: 'An error occured',
          type: ToastMessageType.error,
          duration: Duration(seconds: 3));
    }
  }
}
