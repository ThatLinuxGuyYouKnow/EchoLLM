import 'dart:ui';

import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/widgets/appBar.dart';
import 'package:echo_llm/widgets/messageBubble.dart';
import 'package:echo_llm/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController rawChat = TextEditingController();

  bool userIsInteractingWith = true;

  Widget build(BuildContext context) {
    final messageStream =
        Provider.of<Messagestreamstate>(context, listen: true).messages;
    return Scaffold(
      appBar: DarkAppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 600, vertical: 20),
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 600, vertical: 12),
                child: ChatTextField(chatController: rawChat),
              ),
            )
          ],
        ),
      ),
    );
  }
}
