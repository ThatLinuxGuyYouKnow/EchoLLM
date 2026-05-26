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
  final isDark = Theme.of(context).brightness == Brightness.dark;
  Color backgroundColor;
  Color textColor = isDark ? Colors.white.withOpacity(0.95) : Colors.black87;
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
      backgroundColor = isDark ? const Color(0xFF2A3441) : Colors.grey[800]!;
      leadingIconData = Icons.info_outline_rounded;
      iconColor = isDark ? Colors.cyanAccent[100] : Colors.cyan[700];
      break;
  }
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: 600,
      behavior: SnackBarBehavior.floating,
      content: Row(
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
      backgroundColor: backgroundColor,
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
    ),
  );
}
