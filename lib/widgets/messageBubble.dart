import 'dart:async';

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
    final modelBubbleColor = const Color(0xFF2A3441);
    final userBubbleColor = const Color(0xFF427BBF);

    final textColor = Colors.white.withOpacity(0.95);
    final baseTextStyle = TextStyle(
      fontFamily: GoogleFonts.ubuntu().fontFamily,
      color: textColor,
      fontSize: 15,
      height: 1.4,
    );

    //
    final MarkdownStyleSheet markdownStyleSheet = MarkdownStyleSheet.fromTheme(
      ThemeData(
        textTheme: TextTheme(
          bodyMedium: baseTextStyle,
        ),
      ),
    ).copyWith(
      p: baseTextStyle,
      strong: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
      em: baseTextStyle.copyWith(fontStyle: FontStyle.italic),
      a: baseTextStyle.copyWith(
        color: const Color(0xFF60A5FA),
        decoration: TextDecoration.underline,
        decorationColor: const Color(0xFF60A5FA).withOpacity(0.7),
      ),
      h1: baseTextStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF60A5FA).withOpacity(0.8)),
      h2: baseTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF60A5FA).withOpacity(0.7)),
      h3: baseTextStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF60A5FA).withOpacity(0.6)),
      listBullet: baseTextStyle.copyWith(color: textColor.withOpacity(0.8)),
      listIndent: 12.0,
      codeblockDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[700]!, width: 0.5),
      ),
      code: baseTextStyle.copyWith(
        fontFamily: GoogleFonts.sourceCodePro().fontFamily,
        backgroundColor: Colors.black.withOpacity(0.25),
        color: Colors.orangeAccent[100],
        fontSize: 14,
      ),
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ]),
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
            : SelectableText(
                messageText,
                style: baseTextStyle,
              ),
      ),
    );
  }
}

class BufferingMessageBubble extends StatefulWidget {
  const BufferingMessageBubble({super.key});

  @override
  State<BufferingMessageBubble> createState() => _BufferingMessageBubbleState();
}

class _BufferingMessageBubbleState extends State<BufferingMessageBubble> {
  final int _numberOfDots = 3;

  int _currentDot = 0;

  Timer? _timer;

  final Color _activeDotColor = Colors.white.withOpacity(0.9);

  final Color _inactiveDotColor = Colors.white.withOpacity(0.4);

  final double _dotSize = 10.0;

  final Duration _animationSpeed = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();

    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(_animationSpeed, (timer) {
      if (!mounted) {
        timer.cancel();

        return;
      }

      setState(() {
        _currentDot = (_currentDot + 1) % _numberOfDots;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: _animationSpeed.inMilliseconds ~/ 2),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      width: _dotSize,
      height: _dotSize,
      decoration: BoxDecoration(
        color: index == _currentDot ? _activeDotColor : _inactiveDotColor,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = const Color(0xFF2A3441);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        constraints: const BoxConstraints(
          maxWidth: 100,
          minHeight: 50,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_numberOfDots, (index) => _buildDot(index)),
        ),
      ),
    );
  }
}
