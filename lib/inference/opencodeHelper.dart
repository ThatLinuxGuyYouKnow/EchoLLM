import 'dart:convert';
import 'dart:math';
import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:http/http.dart' as http;

/// Inference helper for the **OpenCode Go** provider.
///
/// OpenCode Go ($10/mo subscription, API key from the OpenCode Zen console)
/// serves curated open coding models behind three OpenAI/Anthropic-compatible
/// endpoints (see https://opencode.ai/docs/go/#endpoints):
///
/// * `POST https://opencode.ai/zen/go/v1/chat/completions` — most models
///   (OpenAI-compatible, `@ai-sdk/openai-compatible`)
/// * `POST https://opencode.ai/zen/go/v1/responses` — grok-4.6, gpt-5.6-luna
///   and Muse Spark models (OpenAI Responses API, `@ai-sdk/openai`)
/// * `POST https://opencode.ai/zen/go/v1/messages` — MiniMax and Qwen models
///   (Anthropic-compatible, `@ai-sdk/anthropic`)
///
/// Per https://opencode.ai/docs/go/#where-can-i-use-it, every request:
///  1. sends typical chat/agent traffic,
///  2. identifies this client with its own `User-Agent` (`EchoLLM/<version>`)
///     instead of a generic SDK/HTTP-library name, and
///  3. sends a stable `x-opencode-session` id per conversation so Go can
///     optimise routing and prompt caching.
class OpencodeHelper {
  final String apiKey;

  /// Upstream model id Go expects (from the catalog's `api_id`).
  final String modelId;

  /// Stable id for the current conversation (e.g. the local chat id).
  /// When empty, an ephemeral id is generated for this helper instance.
  final String sessionId;

  /// Base URL of the Go gateway. Overridable for tests.
  final String baseUrl;

  OpencodeHelper({
    required this.apiKey,
    required this.modelId,
    this.sessionId = '',
    this.baseUrl = _defaultBaseUrl,
  });

  static const String _defaultBaseUrl = 'https://opencode.ai/zen/go/v1';
  static const String _userAgent = 'EchoLLM/1.0';

  // ──────────────── Endpoint routing ────────────────

  /// Models served through the OpenAI Responses API.
  static const Set<String> _responsesModels = {
    'grok-4.6',
    'gpt-5.6-luna',
    'muse-spark-1.3-contributor',
    'muse-spark-1.2-contributor',
  };

  /// Models served through the Anthropic-compatible Messages API.
  static const Set<String> _messagesModels = {
    'minimax-m3',
    'minimax-m2.7',
    'minimax-m2.5',
    'qwen3.8-max',
    'qwen3.8-flash',
    'qwen3.7-max',
    'qwen3.7-plus',
    'qwen3.6-plus',
  };

  /// The model id Go expects. Kept tolerant of legacy locally-suffixed
  /// slugs (e.g. `grok-4.6-go`) from catalog payloads predating `api_id`.
  String get _goModelId {
    var id = modelId;
    if (id.endsWith('-go')) {
      final base = id.substring(0, id.length - 3);
      if (_responsesModels.contains(base)) return base;
    }
    return id;
  }

  bool get _isResponses => _responsesModels.contains(_goModelId);
  bool get _isMessages => _messagesModels.contains(_goModelId);

  String get _endpointPath {
    if (_isResponses) return '/responses';
    if (_isMessages) return '/messages';
    return '/chat/completions';
  }

  String _effectiveSessionId() {
    if (sessionId.isNotEmpty) return sessionId;
    return 'echollm-${DateTime.now().microsecondsSinceEpoch}-'
        '${Random().nextInt(1 << 32)}';
  }

  Map<String, String> _headers({bool anthropic = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
      // Required by OpenCode Go: identify this client (not a generic SDK).
      'User-Agent': _userAgent,
      // Required by OpenCode Go: stable id per conversation.
      'x-opencode-session': _effectiveSessionId(),
    };
    if (anthropic) {
      headers['anthropic-version'] = '2023-06-01';
      headers['x-api-key'] = apiKey;
    }
    return headers;
  }

  List<Map<String, String>> _chatMessages(
      String prompt, List<Map<String, dynamic>> history) {
    return [
      ...history.map((e) => {
            'role': e['role'] == 'model' ? 'assistant' : e['role'].toString(),
            'content': e['content'].toString(),
          }),
      {'role': 'user', 'content': prompt},
    ];
  }

  // ──────────────── Non-streaming (fallback) ────────────────

  Future<String?> getResponse({
    required String prompt,
    required List<Map<String, dynamic>> history,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$_endpointPath');
      final Map<String, dynamic> body;
      if (_isResponses) {
        body = {
          'model': _goModelId,
          'input': _chatMessages(prompt, history),
        };
      } else if (_isMessages) {
        body = {
          'model': _goModelId,
          'max_tokens': 4096,
          'messages': _mergeConsecutiveRoles(_chatMessages(prompt, history)),
        };
      } else {
        body = {
          'model': _goModelId,
          'messages': _chatMessages(prompt, history),
        };
      }

      final response = await http.post(
        uri,
        headers: _headers(anthropic: _isMessages),
        body: jsonEncode(body),
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

  /// Yields text delta chunks from whichever Go endpoint serves this model.
  Stream<String> streamResponse({
    required String prompt,
    required List<Map<String, dynamic>> history,
  }) async* {
    final uri = Uri.parse('$baseUrl$_endpointPath');
    final Map<String, dynamic> body;
    if (_isResponses) {
      body = {
        'model': _goModelId,
        'input': _chatMessages(prompt, history),
        'stream': true,
      };
    } else if (_isMessages) {
      body = {
        'model': _goModelId,
        'max_tokens': 4096,
        'messages': _mergeConsecutiveRoles(_chatMessages(prompt, history)),
        'stream': true,
      };
    } else {
      body = {
        'model': _goModelId,
        'messages': _chatMessages(prompt, history),
        'stream': true,
      };
    }

    final request = http.Request('POST', uri)
      ..headers.addAll(_headers(anthropic: _isMessages))
      ..body = jsonEncode(body);

    try {
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode != 200) {
        final bodyStr = await streamedResponse.stream.bytesToString();
        _handleStatusError(streamedResponse.statusCode, bodyStr);
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
          if (jsonStr == '[DONE]' || jsonStr.isEmpty) continue;
          try {
            final data = jsonDecode(jsonStr) as Map<String, dynamic>;
            final text = _extractStreamText(data);
            if (text != null && text.isNotEmpty) yield text;
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

  /// Extract a text delta from one SSE data event, whatever Go endpoint it
  /// came from. Terminal `*_done` / `*_completed` events are ignored so text
  /// yielded via deltas is never duplicated.
  String? _extractStreamText(Map<String, dynamic> data) {
    if (_isResponses) {
      // OpenAI Responses API: response.output_text.delta carries {delta}.
      final type = data['type']?.toString() ?? '';
      if (type == 'response.output_text.delta') {
        return data['delta']?.toString();
      }
      return null;
    }
    if (_isMessages) {
      // Anthropic Messages API: content_block_delta with text_delta.
      if (data['type'] == 'content_block_delta') {
        final delta = data['delta'];
        if (delta?['type'] == 'text_delta') {
          return delta['text']?.toString();
        }
      }
      return null;
    }
    // OpenAI Chat Completions: choices[0].delta.content.
    return data['choices']?[0]?['delta']?['content']?.toString();
  }

  // ──────────────── Helpers ────────────────

  String? _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (_isResponses) return _extractResponsesText(data);
      if (_isMessages) {
        final content = data['content'] as List?;
        if (content == null || content.isEmpty) {
          throw Exception('No content found in response');
        }
        return (content.first as Map<String, dynamic>)['text'] as String?;
      }
      final choices = data['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        throw Exception('No response choices found');
      }
      final message = choices.first['message'] as Map<String, dynamic>;
      return message['content'] as String?;
    }
    _handleStatusError(response.statusCode, response.body);
    return null;
  }

  /// Pull assistant text out of a non-streaming Responses API payload.
  /// Handles both the `output_text` convenience field and the full
  /// `output` item list.
  String? _extractResponsesText(Map<String, dynamic> data) {
    final convenience = data['output_text'];
    if (convenience is String && convenience.isNotEmpty) return convenience;
    if (convenience is List && convenience.isNotEmpty) {
      return convenience.map((e) => e.toString()).join('');
    }
    final output = data['output'] as List?;
    if (output == null) return null;
    final buffer = StringBuffer();
    for (final item in output) {
      if (item is! Map<String, dynamic>) continue;
      if (item['type'] == 'message') {
        final content = item['content'] as List?;
        for (final block in content ?? []) {
          if (block is Map<String, dynamic>) {
            final blockType = block['type']?.toString() ?? '';
            if (blockType == 'output_text' || blockType == 'text') {
              buffer.write(block['text']?.toString() ?? '');
            }
          } else if (block is String) {
            buffer.write(block);
          }
        }
      }
    }
    final text = buffer.toString();
    return text.isEmpty ? null : text;
  }

  /// The Messages API requires alternating user/assistant turns starting
  /// with a user turn; merge any consecutive same-role messages.
  List<Map<String, String>> _mergeConsecutiveRoles(
      List<Map<String, String>> messages) {
    final merged = <Map<String, String>>[];
    for (final msg in messages) {
      if (merged.isNotEmpty && merged.last['role'] == msg['role']) {
        merged.last = {
          'role': merged.last['role']!,
          'content': '${merged.last['content']}\n\n${msg['content']}',
        };
      } else {
        merged.add(Map<String, String>.from(msg));
      }
    }
    if (merged.isNotEmpty && merged.first['role'] != 'user') {
      merged.insert(0, {'role': 'user', 'content': '(start of conversation)'});
    }
    return merged;
  }

  void _handleStatusError(int statusCode, String body) {
    switch (statusCode) {
      case 400:
        MessengerService().showToast(
          'Bad request – check your input',
          type: ToastMessageType.error,
        );
        break;
      case 401:
      case 403:
        MessengerService().showToast(
          'Invalid API key for OpenCode Go – check your Zen console key',
          type: ToastMessageType.error,
        );
        break;
      case 402:
        MessengerService().showToast(
          'OpenCode Go usage limit reached – check your console',
          type: ToastMessageType.error,
        );
        break;
      case 429:
        MessengerService().showToast(
          'Rate limit exceeded – try again later',
          type: ToastMessageType.error,
        );
        break;
      default:
        MessengerService().showToast(
          'OpenCode Go error: $statusCode',
          type: ToastMessageType.error,
        );
    }
  }
}
