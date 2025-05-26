import 'package:echo_llm/dataHandlers/heyHelper.dart';
import 'package:echo_llm/logic/geminiHelper.dart';
import 'package:echo_llm/mappings/modelClassMapping.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';

import 'package:echo_llm/userConfig.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InferenceSuperClass {
  final BuildContext context;
  final List<Map<int, String>> conversationHistory;

  InferenceSuperClass({
    required this.context,
    required this.conversationHistory,
  });

  Future<String?> runInference(String prompt) async {
    final messageState =
        Provider.of<Messagestreamstate>(context, listen: false);
    try {
      final CONFIG config = Provider.of<CONFIG>(context, listen: false);
      final String modelSlug = config.modelSlug;
      final apikey = ApiKeyHelper();

      // Build proper conversation context
      final List<Map<String, String>> formattedHistory = [];
      for (var entry in conversationHistory) {
        final key = entry.keys.first;
        final role = key % 2 == 0 ? "user" : "model";
        formattedHistory.add({
          "role": role,
          "content": entry[key]!,
        });
      }
      print('attemping inference');

      final modelType = modelClassMapping[modelSlug];
      final apiKey = apikey.readKey(modelSlugNotName: modelSlug);

      if (apiKey.isEmpty) {
        showCustomToast(
          context,
          message: "API key not found for ${config.model}",
          type: ToastMessageType.error,
        );
        return null;
      }

      switch (modelType) {
        case 'gemini':
          final gemini = Geminihelper(
            modelSlug: modelSlug,
            apiKey: apiKey,
            context: context,
          );
          return await gemini.getResponse(
            prompt: prompt,
            history: formattedHistory,
          );

        case 'openai':
          // Implement OpenAI helper
          // final openai = OpenAIhelper(...);
          // return await openai.getResponse(prompt);
          throw UnimplementedError('OpenAI support not yet implemented');

        case 'x-ai':
          // Implement X-AI helper
          throw UnimplementedError('X-AI support not yet implemented');

        default:
          throw Exception('Unknown model type: $modelType');
      }
    } catch (e) {
      messageState.deleteUserLastMessage();
      showCustomToast(context, message: 'Error $e');
      return null;
    }
  }
}
