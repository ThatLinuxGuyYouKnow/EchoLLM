import 'package:echo_llm/dataHandlers/hive/chatStrorage.dart';
import 'package:echo_llm/inference/superHandler.dart';
import 'package:echo_llm/logic/convertMessageState.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/textfieldState.dart';
import 'package:echo_llm/userConfig.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhoneScreen = screenWidth <= 900;
    bool isExpanded = textfieldState.isExpanded;
    final modelInference = InferenceSuperClass(
        context: context, conversationHistory: messageState.messages);
    final existingID = messageState.chatID;
    final _shouldSendOnEnter = Provider.of<CONFIG>(context).shouldSendOnEnter;
    final FocusNode textFieldFocusNode = FocusNode();

    Future<void> sendMessage() async {
      final userMessage = chatController.text.trim();
      if (userMessage.isEmpty) return;

      final messageState =
          Provider.of<Messagestreamstate>(context, listen: false);
      final screenState = Provider.of<Screenstate>(context, listen: false);

      // Keep track of whether this is the first message
      final bool isFirstMessage = screenState.isOnWelcomeScreen;

      messageState.addMessage(message: userMessage);
      messageState.setProcessing(true);
      chatController.clear(); // Clear the textfield immediately for better UX
      if (isFirstMessage) {
        screenState.chatScreen();
      }
      final response = await modelInference.runInference(userMessage);

      if (response != null && response.isNotEmpty) {
        messageState.addMessage(message: response);

        final hiveReadyMessages =
            convertIndexedMessagesToHive(messageState.messages);
        final title = titleFromFirstMessage(messageState.messages);

        final chatId = await saveChatLocally(
            existingChatID: existingID,
            messages: hiveReadyMessages,
            chatTitle: title);
        if (existingID.isEmpty) {
          messageState.setCurrentChatID(chatId);
        }
      } else {
        chatController.text = userMessage;
        screenState.welcomeScreen();
      }

      messageState.setProcessing(false);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: textfieldState.isExpanded ? 400 : 150,
          constraints:
              BoxConstraints(minHeight: 150, maxHeight: isExpanded ? 400 : 200),
          width: isPhoneScreen ? 800 : screenWidth / 2.5,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isExpanded
                                  ? Color(0xFF4C83D1)
                                  : Colors.transparent),
                          color: const Color(0xFF1E2733),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Focus(
                                focusNode: textFieldFocusNode,
                                onFocusChange: (isFocused) {
                                  if (textfieldState.isExpanded && !isFocused) {
                                    textfieldState.minimize();
                                  }
                                },
                                autofocus: true,
                                child: TextField(
                                  textInputAction: _shouldSendOnEnter
                                      ? TextInputAction.send
                                      : TextInputAction.newline,
                                  onSubmitted: (string) {
                                    if (_shouldSendOnEnter) {
                                      sendMessage();
                                    } else {}
                                  },
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
                                    contentPadding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 40,
                                        bottom: 10,
                                        top: 10),
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
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E2733),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ChatButton(
                                  whenPressed: sendMessage,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String titleFromFirstMessage(List<Map<int, String>> messages) {
  if (messages.isEmpty) return "Untitled Chat";
  final first = messages.first.values.first;
  return first.length > 30 ? '${first.substring(0, 30)}...' : first;
}
