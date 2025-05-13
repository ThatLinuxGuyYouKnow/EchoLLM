import 'package:echo_llm/dataHandlers/heyHelper.dart';

final keyHandler = ApiKeyHelper();

Map<String, bool> onlineModelAvailability = {
  "gemini-2.5-pro":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.5-pro').length > 1,
  "gemini-2.5-flash":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.5-flash').length > 1,
  "gemini-2.0-flash":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.0-flash').length > 1,
  "gemini-2.0-flash-lite":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.0-flash-lite').length > 1,
  "gpt-4.1":
      keyHandler.readKey(modelSlugNotName: 'gemini-2.0-flash-lite').length > 1,
};
