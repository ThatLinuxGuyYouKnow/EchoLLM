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
  "gpt-4o": keyHandler.readKey(modelSlugNotName: 'gpt-4o').length > 1,
  "grok-2-1212": keyHandler.readKey(modelSlugNotName: "grok-2-1212").length > 1,
  'grok-3-beta': keyHandler.readKey(modelSlugNotName: 'grok-3-beta').length > 1,
  'grok-3-mini-beta':
      keyHandler.readKey(modelSlugNotName: 'grok-3-mini-beta').length > 1
};
