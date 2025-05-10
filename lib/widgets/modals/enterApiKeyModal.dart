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
        if (event.logicalKey == LogicalKeyboardKey.escape &&
            event is RawKeyDownEvent) {
          modalState.setModalToHidden();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2733),
          borderRadius: BorderRadius.circular(12),
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
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 31, 37),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: TextStyle(color: Colors.grey[50]),
                cursorColor: Colors.white70,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  border: InputBorder.none,
                  hintText: 'Paste your API key here...',
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Spacer(),
                ModalButton(buttonText: 'Save'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ModalButton extends StatefulWidget {
  final String buttonText;
  const ModalButton({required this.buttonText, super.key});

  @override
  State<ModalButton> createState() => _ModalButtonState();
}

class _ModalButtonState extends State<ModalButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        height: 40,
        width: 110,
        decoration: BoxDecoration(
          color: isHovered
              ? const Color(0xFF4C83D1)
              : const Color(0xFF3F72AF), // subtle hover shade
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            widget.buttonText,
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
