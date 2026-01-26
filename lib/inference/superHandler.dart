import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';
import 'package:echo_llm/inference/geminiHelper.dart';
import 'package:echo_llm/inference/openaiHelper.dart';
import 'package:echo_llm/inference/x-ai_helper.dart';
import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';

import 'package:echo_llm/userConfig.dart';
import 'package:echo_llm/widgets/toastMessage.dart';

class InferenceSuperClass {
  final List<Map<int, String>> conversationHistory;
  final Messagestreamstate messageState;
  final CONFIG config;

  InferenceSuperClass({
    required this.conversationHistory,
    required this.messageState,
    required this.config,
  });

  Future<String?> runInference(String prompt) async {
    final MessengerService _messenger = MessengerService();
    try {
      final String modelSlug = config.modelSlug;
      final apikey = ApiKeyHelper();

      final List<Map<String, String>> formattedHistory = [];
      for (var entry in conversationHistory) {
        final key = entry.keys.first;
        final role = key % 2 == 0 ? "user" : "model";
        formattedHistory.add({
          "role": role,
          "content": entry[key]!,
        });
      }

      final modelType = ModelDataService().getModelType(modelSlug);
      final apiKey = apikey.readKey(modelSlugNotName: modelSlug);
      String modelResponse = '';
      if (apiKey.isEmpty) {
        _messenger.showToast(
          "API key not found for ${config.model}",
          type: ToastMessageType.error,
        );
        return null;
      }

      switch (modelType) {
        case 'gemini':
          final gemini = Geminihelper(
            modelSlug: modelSlug,
            apiKey: apiKey,
          );
          modelResponse = await gemini.getResponse(
                prompt: prompt,
                history: formattedHistory,
              ) ??
              '';
          if (modelResponse.isEmpty) {
            messageState.deleteUserLastMessage();
          }
          print(modelResponse);
          return modelResponse;

        case 'openai':
          final openai = Openaihelper(
            apikey: apiKey,
            modelSlug: modelSlug,
          );
          modelResponse = await openai.getResponse(
                  prompt: prompt, history: formattedHistory) ??
              '';
          if (modelResponse.isEmpty) {
            messageState.deleteUserLastMessage();
          }
          return modelResponse;
        case 'x-ai':
          final xai = XaiHelper(
            apiKey: apiKey,
            modelSlug: modelSlug,
          );
          modelResponse = await xai.getResponse(prompt: prompt) ?? '';
          if (modelResponse.isEmpty) {
            messageState.deleteUserLastMessage();
          }
          return modelResponse;
        default:
          throw Exception('Unknown model type: $modelType');
      }
    } catch (e) {
      print('error' + e.toString());
      messageState.deleteUserLastMessage();
      _messenger.showToast('Unexpected Error Ocurred, do you have internet ?',
          type: ToastMessageType.error);
      return null;
    }
  }
}
