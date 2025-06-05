import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildFirstTimeUserPrompt() {
  return Dialog(
    backgroundColor: const Color(0xFF1E2733),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
    ),
    child: ListTile(
      title: Text(
        'First Time ?',
        style: GoogleFonts.ubuntu(color: Colors.white),
      ),
      subtitle: Text(
          "You'll need to enter at least one API key to get started with EchoLLM"),
    ),
  );
}
