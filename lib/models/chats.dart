import 'package:hive/hive.dart';

part 'chat.g.dart'; // This file will be generated

@HiveType(typeId: 0)
class Chat extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String chatTitle;

  @HiveField(2)
  late DateTime lastModified;

  @HiveField(3)
  late List<Message> messages;
}

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String content;

  @HiveField(2)
  late String role;

  @HiveField(3)
  late DateTime timestamp;

  @HiveField(4)
  Map<String, dynamic>? metadata;
}
