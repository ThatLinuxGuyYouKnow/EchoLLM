import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  ChatTextField({super.key});
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 800,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.cyan))),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(),
          )
        ],
      ),
    );
  }
}
