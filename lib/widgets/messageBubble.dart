import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final modelBubbleColor = Color(0xFF2A3441); // Dark blue-grey
    final userBubbleColor =
        Color(0xFF3B4B59); // Slightly lighter/different dark blue-grey
    final textColor = Colors.white.withOpacity(0.9);

    return Align(
      alignment: isModelResponse ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        decoration: BoxDecoration(
          color: isModelResponse ? modelBubbleColor : userBubbleColor,
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
        ),
        child: Text(
          messageText,
          style: TextStyle(
            fontFamily: GoogleFonts.ubuntu().fontFamily,
            color: textColor,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
