import 'package:echo_llm/widgets/textfield.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            Center(
                child: Icon(
              Icons.bolt,
              color: Colors.cyanAccent,
              size: 60,
            )),
          ],
        ),
      ),
      bottomSheet: ChatTextField(),
    );
  }
}
