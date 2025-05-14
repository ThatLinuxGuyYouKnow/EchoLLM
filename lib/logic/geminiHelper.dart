import 'dart:convert';
import 'dart:js_interop';

import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:http/http.dart' as http;

class Geminihelper {
  String modelSlug;
  String apiKey;
  Geminihelper({required this.modelSlug, required this.apiKey});
  getResponse() async {
    var response = await http.get(Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/${modelSlug}:generateContent?key=${apiKey}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      String modelResponse =
          data['candidates'][0]['content']['parts'][0]['text'];
      if (modelResponse.length > 1) {
        return modelResponse;
      }
    } else if (response.statusCode == 403) {
      return Toastmessage(
          toastMessage:
              "Could'nt reach Gemini, your api key liekly isnt valid");
    }
  }
}
