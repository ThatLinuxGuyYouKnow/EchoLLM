import 'dart:convert';
import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Geminihelper {
  final String modelSlug;
  final String apiKey;

  Geminihelper({
    required this.modelSlug,
    required this.apiKey,
  });

  Future<String?> getResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$modelSlug:generateContent?key=$apiKey',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
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
        final candidates = data['candidates'] as List?;

        if (candidates == null || candidates.isEmpty) {
          throw Exception('No response candidates found');
        }

        final firstCandidate = candidates.first as Map<String, dynamic>;
        final content = firstCandidate['content'] as Map<String, dynamic>;
        final parts = (content['parts'] as List?) ?? [];

        if (parts.isEmpty) {
          throw Exception('No content parts found');
        }

        return parts.first['text'] as String?;

      case 400:
        debugPrint('Error 400: Bad request - ${response.body}');
        MessengerService().showToast(
          "Bad request - check your input",
          type: ToastMessageType.error,
        );
        return null;

      case 403:
        debugPrint('Error 403: Forbidden - ${response.body}');
        MessengerService().showToast(
          "Invalid API key for Gemini",
          type: ToastMessageType.error,
        );
        return null;

      case 500:
      case 504:
        debugPrint(
            'Error ${response.statusCode}: Server error - ${response.body}');
        MessengerService().showToast(
          "Server error - try shortening your prompt",
          type: ToastMessageType.error,
        );
        return null;

      default:
        debugPrint(
            'Error ${response.statusCode}: Unexpected error - ${response.body}');
        MessengerService().showToast(
          'Unexpected error: ${response.statusCode}',
          type: ToastMessageType.error,
        );
        return null;
    }
  }
}
