import 'package:http/http.dart' as http;

class Geminihelper {
  getResponse() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }
}
