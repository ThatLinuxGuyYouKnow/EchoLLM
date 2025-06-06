import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildFirstTimeUserPrompt(
    {required Function() onPositiveButtonPressed,
    required Function() onNegativeButtonPressed}) {
  return Dialog(
    backgroundColor: const Color(0xFF1E2733),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      height: 190,
      width: 500,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'First Time?',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "You'll need to enter at least one API key to get started with EchoLLM",
              style: GoogleFonts.ubuntu(
                color: Colors.grey[400],
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    onNegativeButtonPressed();
                  },
                  child: Text(
                    "I'll do it later",
                    style: GoogleFonts.ubuntu(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C83D1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    onPositiveButtonPressed();
                  },
                  child: Text(
                    'Got it!',
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
