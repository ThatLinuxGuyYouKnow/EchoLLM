import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/textfieldState.dart';
import 'package:echo_llm/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController chatController;
  const ChatTextField({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    final messageState = Provider.of<Messagestreamstate>(context, listen: true);
    final textfieldState = Provider.of<Textfieldstate>(context);
    bool messageHasBeenEntered = messageState.messages.length > 1;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhoneScreen = screenWidth <= 900;
    bool isExpanded = textfieldState.isExpanded;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFF1E2733),
                blurRadius: 2,
                spreadRadius: 0,
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20)),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 100),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: isExpanded ? 400 : 150,
                ),
                width: isPhoneScreen ? 800 : screenWidth / 3,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isExpanded
                                    ? Colors.cyan
                                    : Colors.transparent),
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
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.normal),
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
                          ChatButton(
                            whenPressed: () {
                              messageState.addMessage(
                                  message: chatController.text.trim());
                              chatController.clear();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
