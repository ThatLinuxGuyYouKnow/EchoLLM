import 'dart:convert';
import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:http/http.dart' as http;

class Openaihelper {
  final String apikey;
  final String modelSlug;
  Openaihelper({required this.apikey, required this.modelSlug});

  // ──────────────── Non-streaming (fallback) ────────────────

  Future<String?> getResponse(
      {required String prompt,
      required List<Map<String, dynamic>> history}) async {
    final messages = [
      ...history.map((entry) => {
            'role': entry['role'],
            'content': entry['content'],
          }),
      {'role': 'user', 'content': prompt}
    ];

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apikey',
      },
      body: jsonEncode({
        'model': modelSlug,
        'messages': messages,
      }),
    );
    return _handleResponse(response);
  }

  // ──────────────── Streaming ────────────────

  /// Yields text delta chunks via OpenAI's SSE stream.
  Stream<String> streamResponse({
    required String prompt,
    required List<Map<String, dynamic>> history,
  }) async* {
    final messages = [
      ...history.map((e) => {'role': e['role'], 'content': e['content']}),
      {'role': 'user', 'content': prompt},
    ];

    final request =
        http.Request('POST', Uri.parse('https://api.openai.com/v1/chat/completions'))
          ..headers.addAll({
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apikey',
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
        // Keep the last (potentially incomplete) line in the buffer.
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

  Future<String?> _handleResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'] as List?;
        if (choices == null || choices.isEmpty) {
          throw Exception('No response choices found');
        }
        final message = choices.first['message'] as Map<String, dynamic>;
        return message['content'] as String?;

      case 400:
        MessengerService().showToast(
          'Bad request ${response.body} – check your input please',
          type: ToastMessageType.error,
        );
        return null;
      case 401:
        MessengerService().showToast('Invalid API key for OpenAI',
            type: ToastMessageType.error);
        return null;
      case 429:
        MessengerService()
            .showToast('Rate limit exceeded', type: ToastMessageType.error);
        return null;
      case 500:
      case 503:
      case 504:
        MessengerService()
            .showToast('Server error – try again later', type: ToastMessageType.error);
        return null;
      default:
        MessengerService().showToast('API Error: ${response.statusCode}',
            type: ToastMessageType.error);
        return null;
    }
  }

  void _handleStatusError(int statusCode, String body) {
    switch (statusCode) {
      case 401:
        MessengerService().showToast('Invalid API key for OpenAI',
            type: ToastMessageType.error);
        break;
      case 429:
        MessengerService()
            .showToast('Rate limit exceeded', type: ToastMessageType.error);
        break;
      default:
        MessengerService().showToast('OpenAI error: $statusCode',
            type: ToastMessageType.error);
    }
  }
}
