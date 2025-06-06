import 'package:echo_llm/dataHandlers/firstTimeUser.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget apiKeyReminder({required BuildContext context}) {
  return Dialog(
    backgroundColor: const Color(0xFF1E2733),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
      side: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
    ),
    elevation: 10,
    child: Container(
      padding: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_active_outlined,
                color: Color(0xFF4C83D1),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Reminder',
                style: GoogleFonts.ubuntu(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'You can set an API key anytime from Settings',
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
              color: Colors.grey[300],
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Go to Settings → Manage API Keys',
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
              color: Colors.blueGrey[200],
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              storeUserFirstTimeEntry();
              Navigator.pop(context); // This closes the current dialog
              print('oiiiiiiiiii');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C83D1),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              shadowColor: Colors.blue.withOpacity(0.4),
            ),
            child: Text(
              'Got It!',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
