import 'package:echo_llm/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
