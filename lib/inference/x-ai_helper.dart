import 'dart:convert';
import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:http/http.dart' as http;

class XaiHelper {
  final String apiKey;
  final String modelSlug;

  XaiHelper({
    required this.apiKey,
    required this.modelSlug,
  });

  // ──────────────── Non-streaming (fallback) ────────────────

  Future<String?> getResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async {
    try {
      final messages = [
        ...history.map((entry) => {
              'role': entry['role'] == 'model' ? 'assistant' : entry['role'],
              'content': entry['content'],
            }),
        {'role': 'user', 'content': prompt},
      ];

      final response = await http.post(
        Uri.parse('https://api.x.ai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': modelSlug,
          'messages': messages,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      MessengerService().showToast(
        'Network error: ${e.toString()}',
        type: ToastMessageType.error,
      );
      return null;
    }
  }

  // ──────────────── Streaming ────────────────

  /// Yields text delta chunks – xAI uses the same SSE format as OpenAI.
  Stream<String> streamResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async* {
    final messages = [
      ...history.map((entry) => {
            'role': entry['role'] == 'model' ? 'assistant' : entry['role'],
            'content': entry['content'],
          }),
      {'role': 'user', 'content': prompt},
    ];

    final request =
        http.Request('POST', Uri.parse('https://api.x.ai/v1/chat/completions'))
          ..headers.addAll({
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          })
          ..body = jsonEncode({
            'model': modelSlug,
            'messages': messages,
            'stream': true,
          });

    try {
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode != 200) {
        final body = await streamedResponse.stream.bytesToString();
        _handleStatusError(streamedResponse.statusCode, body);
        return;
      }

      String buffer = '';
      await for (final chunk
          in streamedResponse.stream.transform(utf8.decoder)) {
        buffer += chunk;
        final lines = buffer.split('\n');
        buffer = lines.removeLast();

        for (final line in lines) {
          if (!line.startsWith('data:')) continue;
          final jsonStr = line.substring(5).trim();
          if (jsonStr == '[DONE]' || jsonStr.isEmpty) continue;
          try {
            final data = jsonDecode(jsonStr) as Map<String, dynamic>;
            final delta =
                data['choices']?[0]?['delta']?['content'] as String?;
            if (delta != null && delta.isNotEmpty) yield delta;
          } catch (_) {}
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

  String? _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic>? choices = data['choices'];
        if (choices == null || choices.isEmpty) {
          throw Exception('No choices returned in response');
        }
        final String? content = choices.first['message']?['content'];
        if (content == null || content.isEmpty) {
          throw Exception('Message content is empty');
        }
        return content;

      case 400:
        MessengerService().showToast(
          'Invalid API Key for ${onlineModels.entries.firstWhere(
                (entry) => entry.value == modelSlug,
                orElse: () => const MapEntry('Unknown Model', ''),
              ).key}',
          type: ToastMessageType.error,
        );
        return null;
      case 401:
      case 403:
        MessengerService().showToast(
          'Authentication failed – invalid API key',
          type: ToastMessageType.error,
        );
        return null;
      case 500:
      case 502:
      case 503:
      case 504:
        MessengerService().showToast(
          'Server error – please try again later',
          type: ToastMessageType.error,
        );
        return null;
      default:
        return null;
    }
  }

  void _handleStatusError(int statusCode, String body) {
    switch (statusCode) {
      case 401:
      case 403:
        MessengerService().showToast('Invalid API key for xAI',
            type: ToastMessageType.error);
        break;
      default:
        MessengerService().showToast('xAI error: $statusCode',
            type: ToastMessageType.error);
    }
  }
}
