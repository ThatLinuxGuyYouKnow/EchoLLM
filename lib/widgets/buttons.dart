import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
  final Function() whenPressed;
  ChatButton({super.key, required this.whenPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      width: 40,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          whenPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4C83D1),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Icon(
          Icons.send,
          color: Colors.black54,
          size: 20,
        ),
      ),
    );
  }
}
