import 'dart:async';
import 'dart:convert';
import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:http/http.dart' as http;

class Geminihelper {
  final String modelSlug;
  final String apiKey;

  Geminihelper({
    required this.modelSlug,
    required this.apiKey,
  });

  // ──────────────── Non-streaming (fallback) ────────────────

  Future<String?> getResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$modelSlug:generateContent',
      ),
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode(_buildBody(prompt, history)),
    );
    return _handleResponse(response);
  }

  // ──────────────── Streaming ────────────────

  /// Yields text chunks as they arrive via server-sent events.
  Stream<String> streamResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async* {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$modelSlug:streamGenerateContent?alt=sse',
    );

    final request = http.Request('POST', uri)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      })
      ..body = jsonEncode(_buildBody(prompt, history));

    try {
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode != 200) {
        final body = await streamedResponse.stream.bytesToString();
        _handleStatusError(streamedResponse.statusCode, body);
        return;
      }

      await for (final chunk
          in streamedResponse.stream.transform(utf8.decoder)) {
        for (final line in chunk.split('\n')) {
          if (!line.startsWith('data:')) continue;
          final jsonStr = line.substring(5).trim();
          if (jsonStr.isEmpty) continue;
          try {
            final data = jsonDecode(jsonStr) as Map<String, dynamic>;
            final candidates = data['candidates'] as List?;
            if (candidates == null || candidates.isEmpty) continue;
            final parts =
                (candidates.first['content']?['parts'] as List?) ?? [];
            for (final part in parts) {
              final text = part['text'] as String?;
              if (text != null && text.isNotEmpty) yield text;
            }
          } catch (_) {
            // malformed chunk – skip
          }
        }
      }
    } catch (e) {
      MessengerService().showToast(
        'Network error: ${e.toString()}',
        type: ToastMessageType.error,
      );
    }
  }

  // ──────────────── Helpers ────────────────

  Map<String, dynamic> _buildBody(
      String prompt, List<Map<String, String>> history) {
    return {
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
    };
  }

  String? _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = data['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          throw Exception('No response candidates found');
        }
        final content =
            candidates.first['content'] as Map<String, dynamic>;
        final parts = (content['parts'] as List?) ?? [];
        if (parts.isEmpty) throw Exception('No content parts found');
        return parts.first['text'] as String?;

      case 400:
        MessengerService()
            .showToast('Bad request – check your input', type: ToastMessageType.error);
        return null;
      case 403:
        MessengerService()
            .showToast('Invalid API key for Gemini', type: ToastMessageType.error);
        return null;
      case 500:
      case 504:
        MessengerService().showToast('Server error – try shortening your prompt',
            type: ToastMessageType.error);
        return null;
      default:
        MessengerService().showToast('Unexpected error: ${response.statusCode}',
            type: ToastMessageType.error);
        return null;
    }
  }

  void _handleStatusError(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        MessengerService()
            .showToast('Bad request – check your input', type: ToastMessageType.error);
        break;
      case 403:
        MessengerService()
            .showToast('Invalid API key for Gemini', type: ToastMessageType.error);
        break;
      default:
        MessengerService().showToast('Gemini error: $statusCode',
            type: ToastMessageType.error);
    }
  }
}
