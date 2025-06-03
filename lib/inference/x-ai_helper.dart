import 'dart:convert';

import 'package:echo_llm/mappings/modelSlugMappings.dart';
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
        final List<dynamic>? choices = data['choices'];

        if (choices == null || choices.isEmpty) {
          throw Exception('No choices returned in response');
        }

        final Map<String, dynamic>? message = choices.first['message'];
        final String? content = message?['content'];

        if (content == null || content.isEmpty) {
          throw Exception('Message content is empty');
        }

        return content;
      case 400:
        debugPrint(
            'OpenAI API Error: ${response.statusCode}\n${response.body}');
        showCustomToast(
          context,
          message: 'Invalid API Key for ${onlineModels.entries.firstWhere(
                (entry) => entry.value == modelSlug,
                orElse: () => const MapEntry('Unknown Model', ''),
              ).key}',
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
        debugPrint(
            'OpenAI API Error: ${response.statusCode}\n${response.body}');
        showCustomToast(
          context,
          message: 'Server error – please try again later',
          type: ToastMessageType.error,
        );
        return null;

      default:
        debugPrint(
            'OpenAI API Error: ${response.statusCode}\n${response.body}');
        return null;
    }
  }
}
