import 'dart:convert';
import 'dart:io';

import 'package:echo_llm/inference/opencodeHelper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Spins up a stub OpenCode Go gateway on loopback.
Future<HttpServer> _stub({
  required void Function(HttpRequest req, String body) handler,
}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((req) async {
    final body = await utf8.decoder.bind(req).join();
    handler(req, body);
  });
  return server;
}

void main() {
  test('chat/completions routing, headers and SSE parsing', () async {
    String? path;
    String? model;
    final seen = <String, String>{};
    final server = await _stub(handler: (req, body) {
      path = req.uri.path;
      final json = jsonDecode(body) as Map<String, dynamic>;
      model = json['model'] as String?;
      seen['authorization'] = req.headers.value('authorization') ?? '';
      seen['user-agent'] = req.headers.value('user-agent') ?? '';
      seen['session'] = req.headers.value('x-opencode-session') ?? '';
      req.response.headers.contentType = ContentType('text', 'event-stream');
      req.response.write(
          'data: {"choices":[{"delta":{"content":"Hel"}}]}\n\n'
          'data: {"choices":[{"delta":{"content":"lo"}}]}\n\n'
          'data: [DONE]\n\n');
      req.response.close();
    });

    final helper = OpencodeHelper(
      apiKey: 'test-key',
      modelId: 'kimi-k2.7-code',
      sessionId: 'session-123',
      baseUrl: 'http://127.0.0.1:${server.port}',
    );
    final text = await helper.streamResponse(prompt: 'hi', history: []).join();
    await server.close(force: true);

    expect(path, '/chat/completions');
    expect(model, 'kimi-k2.7-code');
    expect(seen['authorization'], 'Bearer test-key');
    expect(seen['user-agent'], 'EchoLLM/1.0');
    expect(seen['session'], 'session-123');
    expect(text, 'Hello');
  });

  test('responses endpoint with -go slug stripped', () async {
    String? path;
    String? model;
    final server = await _stub(handler: (req, body) {
      path = req.uri.path;
      model = (jsonDecode(body) as Map<String, dynamic>)['model'] as String?;
      req.response.headers.contentType = ContentType('text', 'event-stream');
      req.response.write(
          'data: {"type":"response.output_text.delta","delta":"Hi "}\n\n'
          'data: {"type":"response.output_text.delta","delta":"there"}\n\n'
          'data: {"type":"response.completed"}\n\n');
      req.response.close();
    });

    final helper = OpencodeHelper(
      apiKey: 'k',
      modelId: 'grok-4.6-go',
      baseUrl: 'http://127.0.0.1:${server.port}',
    );
    final text = await helper.streamResponse(prompt: 'hi', history: []).join();
    await server.close(force: true);

    expect(path, '/responses');
    expect(model, 'grok-4.6');
    expect(text, 'Hi there');
  });

  test('messages endpoint, anthropic headers and non-stream parse', () async {
    String? path;
    String? model;
    final seen = <String, String>{};
    final server = await _stub(handler: (req, body) {
      path = req.uri.path;
      final json = jsonDecode(body) as Map<String, dynamic>;
      model = json['model'] as String?;
      seen['x-api-key'] = req.headers.value('x-api-key') ?? '';
      seen['anthropic-version'] = req.headers.value('anthropic-version') ?? '';
      req.response.headers.contentType = ContentType.json;
      req.response.write(jsonEncode({
        'content': [
          {'type': 'text', 'text': 'Yo'}
        ]
      }));
      req.response.close();
    });

    final helper = OpencodeHelper(
      apiKey: 'k',
      modelId: 'qwen3.7-plus',
      baseUrl: 'http://127.0.0.1:${server.port}',
    );
    final text = await helper.getResponse(prompt: 'hi', history: []);
    await server.close(force: true);

    expect(path, '/messages');
    expect(model, 'qwen3.7-plus');
    expect(seen['x-api-key'], 'k');
    expect(seen['anthropic-version'], isNotEmpty);
    expect(text, 'Yo');
  });
}
