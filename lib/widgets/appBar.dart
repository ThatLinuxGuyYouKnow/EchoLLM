import 'package:echo_llm/state_management/screenState.dart';

import 'package:echo_llm/widgets/modelSelector.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  DarkAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final screenState = Provider.of<Screenstate>(context);
    final isOnMainScreen = screenState.isOnMainScreen;
    final isOnWelcomeScreen = screenState.isOnWelcomeScreen;

    return AppBar(
      toolbarHeight: 80,
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.black.withOpacity(0.4),
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 16),
          ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 150,
                maxWidth: 200,
              ),
              child: isOnWelcomeScreen
                  ? SizedBox.shrink()
                  : Image.asset(
                      'assets/logo2.png',
                      fit: BoxFit.contain,
                    )),
        ],
      ),
      actions: [
        if (isOnMainScreen || isOnWelcomeScreen)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Modelselector(),
          ),
      ],
    );
  }
}
