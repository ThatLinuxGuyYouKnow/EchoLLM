import 'dart:convert';
import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:http/http.dart' as http;

class Claudehelper {
  final String modelSlug;
  final String apiKey;

  Claudehelper({required this.modelSlug, required this.apiKey});

  // ──────────────── Non-streaming (fallback) ────────────────

  Future<String?> getResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async {
    final messages = [
      ...history.map((entry) {
        final role =
            (entry['role'] == 'model') ? 'assistant' : entry['role'];
        return {'role': role, 'content': entry['content']};
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

  // ──────────────── Streaming ────────────────

  /// Yields text chunks from Anthropic's streaming messages API.
  Stream<String> streamResponse({
    required String prompt,
    required List<Map<String, String>> history,
  }) async* {
    final messages = [
      ...history.map((entry) {
        final role =
            (entry['role'] == 'model') ? 'assistant' : entry['role'];
        return {'role': role, 'content': entry['content']};
      }),
      {'role': 'user', 'content': prompt},
    ];

    final request =
        http.Request('POST', Uri.parse('https://api.anthropic.com/v1/messages'))
          ..headers.addAll({
            'anthropic-version': '2023-06-01',
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
          })
          ..body = jsonEncode({
            'model': modelSlug,
            'messages': messages,
            'max_tokens': 4096,
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
        buffer = lines.removeLast(); // keep potential partial line

        for (final line in lines) {
          if (!line.startsWith('data:')) continue;
          final jsonStr = line.substring(5).trim();
          if (jsonStr.isEmpty) continue;
          try {
            final data = jsonDecode(jsonStr) as Map<String, dynamic>;
            // Anthropic event types we care about: 'content_block_delta'
            if (data['type'] == 'content_block_delta') {
              final delta = data['delta'];
              if (delta?['type'] == 'text_delta') {
                final text = delta['text'] as String?;
                if (text != null && text.isNotEmpty) yield text;
              }
            }
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
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['content'] as List?;
      if (content == null || content.isEmpty) {
        throw Exception('No content found in response');
      }
      return (content.first as Map<String, dynamic>)['text'] as String?;
    } else {
      _handleStatusError(response.statusCode, response.body);
      return null;
    }
  }

  void _handleStatusError(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        MessengerService().showToast('Bad request – check your input',
            type: ToastMessageType.error);
        break;
      case 429:
        MessengerService()
            .showToast('Rate limit – try again later', type: ToastMessageType.error);
        break;
      case 401:
      case 403:
        MessengerService().showToast('Invalid API key for Claude',
            type: ToastMessageType.error);
        break;
      case 413:
        MessengerService().showToast('Chat too long – start a new chat',
            type: ToastMessageType.error);
        break;
      case 500:
      case 504:
        MessengerService().showToast('Server error – try shortening your prompt',
            type: ToastMessageType.error);
        break;
      case 529:
        MessengerService().showToast(
            "Anthropic's API is overloaded – try again later",
            type: ToastMessageType.error);
        break;
      default:
        MessengerService().showToast('Claude error: $statusCode',
            type: ToastMessageType.error);
    }
  }
}
