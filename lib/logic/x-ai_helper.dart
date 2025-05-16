import 'dart:convert';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class XaiHelper {
  final String apiKey;
  final String modelSlug;
  final BuildContext context;

  XaiHelper({
    required this.apiKey,
    required this.modelSlug,
    required this.context,
  });

  Future<String?> getResponse({required String prompt}) async {
    try {
      final uri = Uri.parse('https://api.x.ai/v1/chat/completions');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': modelSlug,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
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
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic>? candidates = data['candidates'];
        if (candidates == null || candidates.isEmpty) {
          throw Exception('No response candidates found');
        }
        final first = candidates.first as Map<String, dynamic>;
        final parts = first['content']['parts'] as List<dynamic>?;
        if (parts == null || parts.isEmpty) {
          throw Exception('No content parts found');
        }
        return parts.first['text'] as String?;

      case 400:
        showCustomToast(
          context,
          message: 'Bad request – please check your prompt format',
          type: ToastMessageType.error,
        );
        return null;

      case 401:
      case 403:
        showCustomToast(
          context,
          message: 'Authentication failed – invalid API key',
          type: ToastMessageType.error,
        );
        return null;

      case 500:
      case 502:
      case 503:
      case 504:
        showCustomToast(
          context,
          message: 'Server error – please try again later',
          type: ToastMessageType.error,
        );
        return null;

      default:
        showCustomToast(
          context,
          message: 'Error ${response.statusCode}: ${response.reasonPhrase}',
          type: ToastMessageType.error,
        );
        return null;
    }
  }
}
