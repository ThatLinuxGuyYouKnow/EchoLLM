import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';
import 'package:echo_llm/state_management/apikeyModalState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EnterApiKeyModal extends StatefulWidget {
  final String modelName;
  final String modelSlug;

  const EnterApiKeyModal(
      {super.key, required this.modelName, required this.modelSlug});

  @override
  State<EnterApiKeyModal> createState() => _EnterApiKeyModalState();
}

class _EnterApiKeyModalState extends State<EnterApiKeyModal> {
  @override
  Widget build(BuildContext context) {
    final modalState = Provider.of<ApikeyModalState>(context);
    final focusNode = FocusNode();
    final apikey = ApiKeyHelper();
    final rawApiKey = TextEditingController();

    return Focus(
      autofocus: true,
      focusNode: focusNode,
      onKey: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.escape &&
            event is KeyDownEvent) {
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
                'Enter your API key for ${widget.modelName}',
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
                controller: rawApiKey,
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
                ModalButton(
                  isEnabled: rawApiKey.text.length > 5,
                  buttonText: 'Save',
                  onPressed: () async {
                    final successfulSave = await apikey.storeKey(
                        modelSlugNotName: widget.modelSlug,
                        apiKey: rawApiKey.text.trim());
                    if (successfulSave) {
                      Provider.of<ApikeyModalState>(context, listen: false)
                          .setModalToHidden();
                    }
                  },
                ),
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
  final Function() onPressed;
  final bool isEnabled;
  const ModalButton(
      {required this.buttonText,
      super.key,
      required this.onPressed,
      required this.isEnabled});

  @override
  State<ModalButton> createState() => _ModalButtonState();
}

class _ModalButtonState extends State<ModalButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          height: 40,
          width: 110,
          decoration: BoxDecoration(
            color: widget.isEnabled
                ? const Color(0xFF4C83D1)
                : const Color.fromARGB(255, 15, 21, 29),
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
      ),
    );
  }
}
