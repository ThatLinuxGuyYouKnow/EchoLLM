import 'package:echo_llm/models/chats.dart';

List<Message> convertIndexedMessagesToHive(List<Map<int, String>> messages) {
  return List.generate(messages.length, (index) {
    final entry = messages[index].entries.first;
    final content = entry.value;

    return Message()
      ..id = DateTime.now().millisecondsSinceEpoch.toString() + index.toString()
      ..content = content
      ..role = index % 2 == 0 ? 'user' : 'assistant'
      ..timestamp = DateTime.now()
      ..metadata = {};
  });
}

List<Map<int, String>> convertHiveMessagesToIndexed(
    List<Message> hiveMessages) {
  final List<Map<int, String>> result = [];

  for (int i = 0; i < hiveMessages.length; i++) {
    result.add({i: hiveMessages[i].content});
  }

  return result;
}
