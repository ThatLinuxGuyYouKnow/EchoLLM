import 'package:echo_llm/state_management/textfieldState.dart';
import 'package:echo_llm/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController chatController;
  const ChatTextField({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    final sizeProvider = Provider.of<Textfieldstate>(context);

    return Container(
      height: sizeProvider.isExpanded ? 400 : 100,
      width: double.infinity * .75,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.cyan)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E2733),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: (text) {
                    if (text.length > 100) sizeProvider.expand();
                  },
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type a message',
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                    hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ChatButton(),
          ],
        ),
      ),
    );
  }
}
