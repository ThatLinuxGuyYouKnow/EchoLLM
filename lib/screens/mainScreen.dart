import 'package:echo_llm/widgets/appBar.dart';
import 'package:echo_llm/widgets/textfield.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final TextEditingController rawChat = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DarkAppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
          ],
        ),
      ),
      bottomSheet: ChatTextField(
        chatController: rawChat,
      ),
    );
  }
}
