import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/widgets/appBar.dart';
import 'package:echo_llm/widgets/messageBubble.dart';
import 'package:echo_llm/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final TextEditingController rawChat = TextEditingController();

  Widget build(BuildContext context) {
    final messageStream = Provider.of<Messagestreamstate>(context).messages;
    return Scaffold(
      appBar: DarkAppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                itemCount: messageStream.length,
                itemBuilder: (context, index) {
                  final messageMap = messageStream[index];
                  final messageIndex = messageMap.keys.first;
                  final messageText = messageMap[messageIndex]!;

                  final isModel = messageIndex % 2 != 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: MessageBubble(
                      messageText: messageText,
                      isModelResponse: isModel,
                    ),
                  );
                }),
          ],
        ),
      ),
      bottomSheet: ChatTextField(
        chatController: rawChat,
      ),
    );
  }
}
