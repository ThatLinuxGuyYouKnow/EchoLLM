import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';
import 'package:echo_llm/inference/claudeHelper.dart';
import 'package:echo_llm/inference/geminiHelper.dart';
import 'package:echo_llm/inference/opencodeHelper.dart';
import 'package:echo_llm/inference/openaiHelper.dart';
import 'package:echo_llm/inference/x-ai_helper.dart';
import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:echo_llm/mappings/providerConfig.dart';
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

  /// The legacy non-streaming inference method.
  Future<String?> runInference(String prompt) async {
    final MessengerService _messenger = MessengerService();
    try {
      final String modelSlug = config.modelSlug;
      final apikeyHelper = ApiKeyHelper();

      final List<Map<String, String>> formattedHistory = _formatHistory();

      final modelService = ModelDataService();
      final providerId = modelService.getProviderId(modelSlug);
      final apiModelId = modelService.getApiId(modelSlug);
      final apiKey =
          await apikeyHelper.readProviderKey(providerId: providerId);

      if (apiKey.isEmpty) {
        _messenger.showToast(
          "API key not found for ${config.model}",
          type: ToastMessageType.error,
        );
        return null;
      }

      switch (providerId) {
        case ProviderIds.google:
          final gemini = Geminihelper(modelSlug: apiModelId, apiKey: apiKey);
          return await gemini.getResponse(
              prompt: prompt, history: formattedHistory);
        case ProviderIds.openai:
          final openai = Openaihelper(apikey: apiKey, modelSlug: apiModelId);
          return await openai.getResponse(
              prompt: prompt, history: formattedHistory);
        case ProviderIds.xai:
          final xai = XaiHelper(apiKey: apiKey, modelSlug: apiModelId);
          return await xai.getResponse(
              prompt: prompt, history: formattedHistory);
        case ProviderIds.anthropic:
          final claude = Claudehelper(modelSlug: apiModelId, apiKey: apiKey);
          return await claude.getResponse(
              prompt: prompt, history: formattedHistory);
        case ProviderIds.opencodeGo:
          final opencode = OpencodeHelper(
            modelId: apiModelId,
            apiKey: apiKey,
            sessionId: messageState.chatID,
          );
          return await opencode.getResponse(
              prompt: prompt, history: formattedHistory);
        default:
          throw Exception('Unknown provider: $providerId');
      }
    } catch (e) {
      messageState.deleteUserLastMessage();
      _messenger.showToast('Unexpected Error Occurred',
          type: ToastMessageType.error);
      return null;
    }
  }

  /// New streaming inference method.
  /// Updates [messageState] token-by-token and returns the full response string at the end.
  Future<String?> runStreamInference(String prompt) async {
    final MessengerService _messenger = MessengerService();
    try {
      final String modelSlug = config.modelSlug;
      final apikeyHelper = ApiKeyHelper();

      final List<Map<String, String>> formattedHistory = _formatHistory();
      final modelService = ModelDataService();
      final providerId = modelService.getProviderId(modelSlug);
      final apiModelId = modelService.getApiId(modelSlug);
      final apiKey =
          await apikeyHelper.readProviderKey(providerId: providerId);

      if (apiKey.isEmpty) {
        _messenger.showToast(
          "API key not found for ${config.model}",
          type: ToastMessageType.error,
        );
        return null;
      }

      final int streamMsgIndex = messageState.beginStreamingMessage();
      Stream<String> tokenStream;

      switch (providerId) {
        case ProviderIds.google:
          tokenStream = Geminihelper(modelSlug: apiModelId, apiKey: apiKey)
              .streamResponse(prompt: prompt, history: formattedHistory);
          break;
        case ProviderIds.openai:
          tokenStream = Openaihelper(apikey: apiKey, modelSlug: apiModelId)
              .streamResponse(prompt: prompt, history: formattedHistory);
          break;
        case ProviderIds.xai:
          tokenStream = XaiHelper(apiKey: apiKey, modelSlug: apiModelId)
              .streamResponse(prompt: prompt, history: formattedHistory);
          break;
        case ProviderIds.anthropic:
          tokenStream = Claudehelper(modelSlug: apiModelId, apiKey: apiKey)
              .streamResponse(prompt: prompt, history: formattedHistory);
          break;
        case ProviderIds.opencodeGo:
          tokenStream = OpencodeHelper(
            modelId: apiModelId,
            apiKey: apiKey,
            sessionId: messageState.chatID,
          ).streamResponse(prompt: prompt, history: formattedHistory);
          break;
        default:
          messageState.cancelStreamingMessage(streamMsgIndex);
          throw Exception('Unknown provider: $providerId');
      }

      await for (final token in tokenStream) {
        messageState.appendStreamToken(streamMsgIndex, token);
      }

      return messageState.finishStreamingMessage(streamMsgIndex);
    } catch (e) {
      // In case of error, we don't have a specific index to cancel unless we store it,
      // but the super class knows the state.
      messageState.setProcessing(false);
      _messenger.showToast('Streaming Error Occurred',
          type: ToastMessageType.error);
      return null;
    }
  }

  List<Map<String, String>> _formatHistory() {
    final List<Map<String, String>> formattedHistory = [];
    for (var entry in conversationHistory) {
      final key = entry.keys.first;
      final role = key % 2 == 0 ? "user" : "model";
      formattedHistory.add({
        "role": role,
        "content": entry[key]!,
      });
    }
    return formattedHistory;
  }
}
