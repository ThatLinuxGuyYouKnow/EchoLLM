import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/widgets/messageBubble.dart';
import 'package:echo_llm/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messagelistwidget extends StatelessWidget {
  final TextEditingController rawChat = TextEditingController();
  Widget build(BuildContext context) {
    final messageStream =
        Provider.of<Messagestreamstate>(context, listen: true).messages;

    final sidebarIsCollapsed =
        Provider.of<Sidebarstate>(context, listen: true).isCollapsed;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhoneScreen = screenWidth <= 900;

    return Stack(
      children: [
        Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isPhoneScreen ? 400 : screenWidth / 2.5,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: ListView.builder(
              itemCount: messageStream.length,
              itemBuilder: (context, index) {
                final messageMap = messageStream[index];
                final messageIndex = messageMap.keys.first;
                final messageText = messageMap[messageIndex]!;
                final isModel = messageIndex.isEven;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: MessageBubble(
                    messageText: messageText,
                    isModelResponse: messageIndex % 2 == 0,
                  ),
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
