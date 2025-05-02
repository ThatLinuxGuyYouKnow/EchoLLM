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
    return ColoredBox(
      color: Colors.black,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Container(
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: isExpanded ? 400 : 150,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                  top: BorderSide(
                      color: isExpanded
                          ? Colors.transparent
                          : Colors.cyan.withOpacity(0.8)))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isExpanded ? Colors.cyan : Colors.transparent),
                      color: const Color(0xFF1E2733),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Focus(
                      onFocusChange: (isFocused) {
                        if (textfieldState.isExpanded && !isFocused) {
                          //text field has expanded but the user has moved out of its focus and is interacting with something else
                          textfieldState.minimize();
                        }
                      },
                      autofocus: true,
                      child: TextField(
                        maxLines: null,
                        minLines: null,
                        expands: isExpanded,
                        scrollPadding:
                            EdgeInsets.only(top: isExpanded ? 20 : 0),
                        controller: chatController,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10),
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
      ),
    );
  }
}
