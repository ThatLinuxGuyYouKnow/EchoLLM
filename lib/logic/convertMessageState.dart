import 'package:echo_llm/models/chats.dart';

List<Message> convertToHiveMessages(List<Map<String, dynamic>> messages) {
  return messages.map((msgMap) {
    return Message()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..content = msgMap['content'] ?? ''
      ..role = msgMap['role'] ?? 'user'
      ..timestamp = DateTime.now() // You could store actual time per message
      ..metadata = msgMap['metadata'] ?? {};
  }).toList();
}
