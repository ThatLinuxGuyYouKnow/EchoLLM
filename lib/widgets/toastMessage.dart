import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Enum to define SnackBar types more clearly
enum ToastMessageType { passive, success, error }

void showCustomToast(
  BuildContext context, {
  required String message,
  ToastMessageType type = ToastMessageType.passive,
  Duration duration = const Duration(seconds: 3),
}) {
  Color backgroundColor;
  Color textColor = Colors.white.withOpacity(0.95);
  IconData? leadingIconData;
  Color? iconColor;

  switch (type) {
    case ToastMessageType.success:
      backgroundColor = const Color(0xFF2E7D32);
      leadingIconData = Icons.check_circle_outline;
      iconColor = Colors.greenAccent[100];
      break;
    case ToastMessageType.error:
      backgroundColor = const Color(0xFFC62828);
      leadingIconData = Icons.error_outline_rounded;
      iconColor = Colors.redAccent[100];
      break;
    case ToastMessageType.passive:
      backgroundColor = const Color(0xFF2A3441);
      leadingIconData = Icons.info_outline_rounded;
      iconColor = Colors.cyanAccent[100];
      break;
  }
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Row(
          children: [
            Icon(leadingIconData, color: iconColor ?? textColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.ubuntu(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      elevation: 4.0,
    ),
  );
}
