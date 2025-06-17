import 'dart:convert';

import 'package:http/http.dart' as http;

class Claudehelper {
  final String modelSlug;
  final String apiKey;
  Claudehelper({required this.modelSlug, required this.apiKey});

  getResponse(
      {required String userPrmopt,
      required List<Map<String, String>> messageHistory}) async {
    final messages = [
      ...messageHistory.map((entry) => {
            'role': entry['role'],
            'content': entry['content'],
          }),
      {'role': 'user', 'content': userPrmopt}
    ];

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        "anthropic-version: 2023-06-01"
            'Content-Type': 'application/json',
        'x-api-key': '$apiKey',
      },
      body: jsonEncode({
        'model': modelSlug,
        'messages': messages,
      }),
    );
    return _handleResponse(response);
  }
}
