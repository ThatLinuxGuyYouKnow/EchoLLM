import 'package:echo_llm/state_management/messageStreamState.dart';

import 'package:echo_llm/widgets/messageBubble.dart';
import 'package:echo_llm/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messagelistwidget extends StatelessWidget {
  final TextEditingController rawChat = TextEditingController();
  Widget build(BuildContext context) {
    final messageStream =
        Provider.of<Messagestreamstate>(context, listen: true).messages;
    final messageState = Provider.of<Messagestreamstate>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhoneScreen = screenWidth <= 900;

    return Stack(
      children: [
        Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isPhoneScreen ? 400 : screenWidth / 2.5,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 200,
              ),
              itemCount:
                  messageStream.length + (messageState.isProcessing ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < messageStream.length) {
                  final messageMap = messageStream[index];
                  final messageIndex = messageMap.keys.first;
                  final messageText = messageMap[messageIndex]!;

                  return MessageBubble(
                    messageText: messageText,
                    isModelResponse: messageIndex % 2 != 0,
                  );
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: BufferingMessageBubble(),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ChatTextField(chatController: rawChat),
            ),
          ),
        ),
      ],
    );
  }
}
