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

  getResponse({required String prompt, required List history}) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/responses'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        'input': [
          ...history.map((entry) => {
                'role': entry['role'],
                'parts': [
                  {'text': entry['content']}
                ]
              }),
          {
            'role': 'user',
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );
    return _handleResponse(response);
  }

  String? _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = data['content'] as List?;

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

      case 403:
        showCustomToast(
          context,
          message: "Invalid API key for Gemini",
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
