import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String messageText;
  final bool isModelResponse;
  MessageBubble(
      {super.key, required this.messageText, required this.isModelResponse});
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isModelResponse ? Colors.tealAccent : Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(messageText),
      ),
    );
  }
}
