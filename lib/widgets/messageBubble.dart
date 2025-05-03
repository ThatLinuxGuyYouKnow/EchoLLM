import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String messageText;
  final bool isModelResponse;
  MessageBubble(
      {super.key, required this.messageText, required this.isModelResponse});
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(messageText),
    );
  }
}
