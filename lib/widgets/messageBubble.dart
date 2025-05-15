import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final modelBubbleColor = Color(0xFF2A3441);
    final userBubbleColor = Color(0xFF3B4B59);
    final textColor = Colors.white.withOpacity(0.9);
    final baseTextStyle = TextStyle(
      fontFamily: GoogleFonts.ubuntu().fontFamily,
      color: textColor,
      fontSize: 15,
      height: 1.4,
    );

    final MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet.fromTheme(
      ThemeData(
        textTheme: TextTheme(
          bodyMedium: baseTextStyle,
        ),
      ),
    ).copyWith(
      // General text style
      p: baseTextStyle,
      // Bold text
      strong: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
      // Italic text
      em: baseTextStyle.copyWith(fontStyle: FontStyle.italic),
      // Links
      a: baseTextStyle.copyWith(
        color: Colors.cyan[400], // Link color
        decoration: TextDecoration.underline,
        decorationColor: Colors.cyan[400]?.withOpacity(0.7),
      ),
      // Headings
      h1: baseTextStyle.copyWith(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.cyan[200]),
      h2: baseTextStyle.copyWith(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan[300]),
      h3: baseTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      // Lists
      listBullet: baseTextStyle.copyWith(color: textColor.withOpacity(0.8)),
      listIndent: 12.0, // Indentation for list items
      // Code blocks
      codeblockDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), // Background for code blocks
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[700]!, width: 0.5),
      ),
      code: baseTextStyle.copyWith(
        fontFamily:
            GoogleFonts.sourceCodePro().fontFamily, // Monospace font for code

        color: Colors.white, // Text color for code
        fontSize: 14,
      ),
      // Blockquotes
      blockquoteDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        border: Border(left: BorderSide(color: Colors.grey[600]!, width: 4)),
      ),
      blockquotePadding: const EdgeInsets.all(10.0),
    );

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
        child: isModelResponse
            ? MarkdownBody(
                data: messageText,
                styleSheet: markdownStyleSheet,
                selectable: true,
                onTapLink: (text, href, title) async {
                  if (href != null) {
                    final uri = Uri.tryParse(href);
                    if (uri != null && await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      print('Could not launch $href');
                    }
                  }
                },
              )
            : Text(
                messageText,
                style: baseTextStyle,
              ),
      ),
    );
  }
}
