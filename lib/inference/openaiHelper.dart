import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Openaihelper {
  final String apikey;
  final String modelSlug;
  final BuildContext context;
  Openaihelper(
      {required this.apikey, required this.modelSlug, required this.context});

  getResponse({required String prompt, required String history}) async {
    final response = await http.post(
        Uri.parse('https://api.openai.com/v1/responses'),
        headers: {'Content-type': 'application/json'},
        body: {});
  }
}
