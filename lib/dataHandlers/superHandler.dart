import 'package:echo_llm/dataHandlers/heyHelper.dart';
import 'package:echo_llm/logic/geminiHelper.dart';
import 'package:echo_llm/mappings/modelClassMapping.dart';
import 'package:echo_llm/userConfig.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InferenceSuperClass {
  final BuildContext context;
  InferenceSuperClass({required this.context});

  Future<String?> runInference(String prompt) async {
    try {
      final CONFIG config = Provider.of<CONFIG>(context, listen: false);
      final String model = config.model;
      final String modelSlug = config.modelSlug;
      final apikey = ApiKeyHelper();

      final modelType = modelClassMapping[modelSlug];
      final apiKey = apikey.readKey(modelSlugNotName: modelSlug);
      print('model' + model);
      print('apikey' + apiKey);
      print(prompt + "prppppppppppppppppp");
      if (apiKey.isEmpty) {
        showCustomToast(
          context,
          message: "API key not found for $model",
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
          return await gemini.getResponse(prompt: prompt);

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
      showCustomToast(
        context,
        message: 'Inference error: ${e.toString()}',
        type: ToastMessageType.error,
        duration: const Duration(seconds: 5),
      );
      return null;
    }
  }
}
