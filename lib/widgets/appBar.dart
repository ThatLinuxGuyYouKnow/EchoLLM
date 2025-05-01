import 'package:flutter/material.dart';

class DarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  DarkAppBar({super.key});
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        'EchoLLM',
        style: TextStyle(color: Colors.cyan),
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(50);
}
