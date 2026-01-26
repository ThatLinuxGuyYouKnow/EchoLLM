import 'dart:convert';

import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Claudehelper {
  final String modelSlug;
  final String apiKey;

  Claudehelper({required this.modelSlug, required this.apiKey});

  Future<String?> getResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async {
    final messages = [
      ...history.map((entry) => {
            'role': entry['role'],
            'content': entry['content'],
          }),
      {'role': 'user', 'content': prompt}
    ];

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'model': modelSlug,
        'messages': messages,
        'max_tokens': 4096,
      }),
    );
    return _handleResponse(response);
  }

  String? _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['content'] as List?;

      if (content == null || content.isEmpty) {
        throw Exception('No content found in response');
      }

      final firstContent = content.first as Map<String, dynamic>;
      return firstContent['text'] as String?;
    } else {
      switch (response.statusCode) {
        case 400:
          MessengerService().showToast(
            "Bad request - check your input",
            type: ToastMessageType.error,
          );
          break;
        case 429:
          MessengerService().showToast(
            "Rate Limit, try again later",
            type: ToastMessageType.error,
          );
          break;
        case 401:
        case 403:
          MessengerService().showToast(
            "Invalid API key for Claude",
            type: ToastMessageType.error,
          );
          break;
        case 413:
          MessengerService().showToast(
            "Chat too long, You should start a new chat",
            type: ToastMessageType.error,
          );
          break;
        case 500:
        case 504:
          MessengerService().showToast(
            "Server error - try shortening your prompt",
            type: ToastMessageType.error,
          );
          break;
        case 529:
          MessengerService().showToast(
            "Error: Anthropic’s API is temporarily overloaded, try again later",
            type: ToastMessageType.error,
          );
          break;
        default:
          MessengerService().showToast(
            'Unexpected error: ${response.statusCode}',
            type: ToastMessageType.error,
          );
      }
      return null;
    }
  }
}
