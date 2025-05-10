import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterApiKeyModal extends StatelessWidget {
  final String modelName;

  const EnterApiKeyModal({super.key, required this.modelName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 600,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2733),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter your API key for $modelName',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 26, 31, 37),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: TextField(
                style: TextStyle(color: Colors.grey[50]),
                cursorColor: Colors.white70,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: InputBorder.none,
                  hintText: 'Paste your API key here...',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
