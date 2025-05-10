import 'package:echo_llm/state_management/apikeyModalState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EnterApiKeyModal extends StatelessWidget {
  final String modelName;

  const EnterApiKeyModal({super.key, required this.modelName});

  @override
  Widget build(BuildContext context) {
    final modalState = Provider.of<ApikeyModalState>(context);
    final focusNode = FocusNode();

    return Focus(
      autofocus: true,
      focusNode: focusNode,
      onKey: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.escape ||
            event.runtimeType.toString() == 'KeyDownEvent') {
          modalState.setModalToHidden();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Container(
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
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 31, 37),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(color: Colors.grey[50]),
                  cursorColor: Colors.white70,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: InputBorder.none,
                    hintText: 'Paste your API key here...',
                    hintStyle: const TextStyle(color: Colors.white38),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
