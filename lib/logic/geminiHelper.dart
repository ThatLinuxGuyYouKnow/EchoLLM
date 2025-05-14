import 'package:http/http.dart' as http;

class Geminihelper {
  String modelSlug;
  String apiKey;
  Geminihelper({required this.modelSlug, required this.apiKey});
  getResponse() {
    return http.get(Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/${modelSlug}:generateContent?key=${apiKey}'));
  }
}
