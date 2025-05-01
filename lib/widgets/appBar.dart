import 'package:echo_llm/widgets/modelSelector.dart';
import 'package:flutter/material.dart';

class DarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  DarkAppBar({super.key});
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Modelselector(),
        )
      ],
      backgroundColor: Colors.black,
      title: Text(
        'EchoLLM',
        style: TextStyle(color: Colors.cyan),
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(70);
}
