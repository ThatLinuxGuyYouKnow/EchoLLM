import 'package:echo_llm/dataHandlers/heyHelper.dart';
import 'package:echo_llm/logic/geminiHelper.dart';
import 'package:echo_llm/mappings/modelClassMapping.dart';
import 'package:echo_llm/userConfig.dart';
import 'package:flutter/material.dart';

class InferenceSuperClass {
  final CONFIG config = CONFIG();
  BuildContext context;
  InferenceSuperClass({required this.context});
  runInference() {
    final String model = config.model;
    final String modelSlug = config.modelSlug;
    final apikey = ApiKeyHelper();
    if (modelClassMapping[model] == 'gemini') {
      final ApiKey = apikey.readKey(modelSlugNotName: modelSlug);
      final gemini =
          Geminihelper(modelSlug: modelSlug, apiKey: ApiKey, context: context);
      return gemini.getResponse();
    }
    if (modelClassMapping[model] == 'openai') {}
  }
}
