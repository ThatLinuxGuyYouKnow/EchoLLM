import 'dart:convert';

import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Claudehelper {
  final String modelSlug;
  final String apiKey;
  final BuildContext context;
  Claudehelper(this.context, {required this.modelSlug, required this.apiKey});

  getResponse(
      {required String userPrmopt,
      required List<Map<String, String>> messageHistory}) async {
    final messages = [
      ...messageHistory.map((entry) => {
            'role': entry['role'],
            'content': entry['content'],
          }),
      {'role': 'user', 'content': userPrmopt}
    ];

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        "anthropic-version: 2023-06-01"
            'Content-Type': 'application/json',
        'x-api-key': '$apiKey',
      },
      body: jsonEncode({
        'model': modelSlug,
        'messages': messages,
      }),
    );
    return _handleResponse(response);
  }

  String? _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = data['candidates'] as List?;

        if (candidates == null || candidates.isEmpty) {
          throw Exception('No response candidates found');
        }

        final firstCandidate = candidates.first as Map<String, dynamic>;
        final content = firstCandidate['content'] as Map<String, dynamic>;
        final parts = content['parts'] as List;

        if (parts.isEmpty) {
          throw Exception('No content parts found');
        }

        return parts.first['text'] as String?;

      case 400:
        showCustomToast(
          context,
          message: "Bad request - check your input",
          type: ToastMessageType.error,
        );
        return null;
      case 429:
        showCustomToast(
          context,
          message: "Rate Limit, try again later",
          type: ToastMessageType.error,
        );
        return null;

      case 403:
      case 401:
        showCustomToast(
          context,
          message: "Invalid API key for Claude",
          type: ToastMessageType.error,
        );
        return null;

      case 413:
        showCustomToast(
          context,
          message: "Chat too long, You should start a new chat",
          type: ToastMessageType.error,
        );
        return null;
      case 500:
      case 504:
        showCustomToast(
          context,
          message: "Server error - try shortening your prompt",
          type: ToastMessageType.error,
        );
        return null;
      case 529:
        showCustomToast(
          context,
          message:
              "Error: Anthropic’s API is temporarily overloaded, try again later",
          type: ToastMessageType.error,
        );
        return null;
      default:
        showCustomToast(
          context,
          message: 'Unexpected error: ${response.statusCode}',
          type: ToastMessageType.error,
        );
        return null;
    }
  }
}
