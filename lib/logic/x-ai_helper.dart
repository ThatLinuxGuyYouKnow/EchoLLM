import 'dart:convert';

import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class XaiHelper {
  String apiKey;
  String modelSlug;
  BuildContext context;

  XaiHelper(
      {required this.apiKey, required this.modelSlug, required this.context});

  Future<String?> getResponse({required String prompt}) async {
    print('prompt hetting to gemini' + prompt);
    try {
      final response = await http.post(
        Uri.parse(
          'https://api.x.ai/v1/chat/completions ',
        ),
        headers: {
          'Content-Type': 'application/json'
              "Authorization: Bearer ${apiKey}"
        },
        body: jsonEncode({
          'messages': [
            {
              'role': [
                {'user': prompt}
              ]
            }
          ]
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      showCustomToast(
        context,
        message: 'Network error: ${e.toString()}',
        type: ToastMessageType.error,
      );
      return null;
    }
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
