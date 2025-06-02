import 'dart:convert';

import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Openaihelper {
  final String apikey;
  final String modelSlug;
  final BuildContext context;
  Openaihelper(
      {required this.apikey, required this.modelSlug, required this.context});

  Future<String?> getResponse(
      {required String prompt,
      required List<Map<String, dynamic>> history}) async {
    final messages = [
      ...history.map((entry) => {
            'role': entry['role'],
            'content': entry['content'],
          }),
      {'role': 'user', 'content': prompt}
    ];

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apikey',
      },
      body: jsonEncode({
        'model': modelSlug,
        'messages': messages,
      }),
    );
    return _handleResponse(response);
  }

  Future<String?> _handleResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'] as List?;

        if (choices == null || choices.isEmpty) {
          throw Exception('No response choices found');
        }

        final firstChoice = choices.first as Map<String, dynamic>;
        final message = firstChoice['message'] as Map<String, dynamic>;
        return message['content'] as String?;

      case 400:
        debugPrint(
            'OpenAI API Error: ${response.statusCode}\n${response.body}');
        showCustomToast(
          context,
          message: "Bad request ${response.body} - check your input please",
          type: ToastMessageType.error,
        );
        return null;

      case 401:
        debugPrint(
            'OpenAI API Error: ${response.statusCode}\n${response.body}');
        showCustomToast(
          context,
          message: "Invalid API key for OpenAI",
          type: ToastMessageType.error,
        );
        return null;

      case 429:
        debugPrint(
            'OpenAI API Error: ${response.statusCode}\n${response.body}');
        showCustomToast(
          context,
          message: "Rate limit exceeded",
          type: ToastMessageType.error,
        );
        return null;

      case 500:
      case 503:
      case 504:
        debugPrint(
            'OpenAI API Error: ${response.statusCode}\n${response.body}');
        showCustomToast(
          context,
          message: "Server error - try again later",
          type: ToastMessageType.error,
        );
        return null;

      default:
        debugPrint(
            'OpenAI API Error: ${response.statusCode}\n${response.body}');
        showCustomToast(
          context,
          message: 'API Error: ${response.statusCode}',
          type: ToastMessageType.error,
        );
        return null;
    }
  }
}
