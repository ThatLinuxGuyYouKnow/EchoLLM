import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String messageText;
  final bool isModelResponse;

  const MessageBubble({
    super.key,
    required this.messageText,
    required this.isModelResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isModelResponse ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
        decoration: BoxDecoration(
          color: isModelResponse
              ? Colors.tealAccent.shade100
              : Colors.teal.shade400,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isModelResponse
                ? const Radius.circular(0)
                : const Radius.circular(16),
            bottomRight: isModelResponse
                ? const Radius.circular(16)
                : const Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Text(
          messageText,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
