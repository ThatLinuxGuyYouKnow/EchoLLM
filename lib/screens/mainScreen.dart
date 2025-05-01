import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Center(child: Icon(Icons.bolt)),
          Container(
            color: Colors.black,
          )
        ],
      )),
    );
  }
}
