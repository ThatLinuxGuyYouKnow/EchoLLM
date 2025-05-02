import 'package:echo_llm/state_management/textfieldState.dart';
import 'package:echo_llm/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController chatController;
  const ChatTextField({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    final textfieldState = Provider.of<Textfieldstate>(context);
    bool isExpanded = textfieldState.isExpanded;
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: isExpanded ? 400 : 150,
        ),
        width: double.infinity * .75,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
              top: BorderSide(
                  color: isExpanded ? Colors.transparent : Colors.cyan)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2733),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Focus(
                    onFocusChange: (isFocused) {
                      if (textfieldState.isExpanded && !isFocused) {
                        textfieldState.minimize();
                      }
                    },
                    autofocus: true,
                    child: TextField(
                      scrollPadding: EdgeInsets.only(top: isExpanded ? 20 : 0),
                      controller: chatController,
                      maxLines: isExpanded ? 8 : 3,
                      minLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        hintStyle:
                            const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      onChanged: (text) {
                        if (text.length > 200 && !isExpanded) {
                          textfieldState.expand();
                        } else if (text.length < 50 &&
                            textfieldState.isExpanded) {
                          textfieldState.minimize();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ChatButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
