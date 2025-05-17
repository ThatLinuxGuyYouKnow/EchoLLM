import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/widgets/modelSelector.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  DarkAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final sidebar = context.watch<Sidebarstate>();
    final isOnMainScreen = context.watch<Screenstate>().isOnMainScreen;

    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.black,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 16),
          if (sidebar.isCollapsed) ...[
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF1E2733),
              ),
              onPressed: sidebar.expand,
              icon: const Icon(
                Icons.trip_origin,
                color: Colors.white,
                weight: 0.1,
              ),
            ),
            const SizedBox(width: 16),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 150,
              maxWidth: 200,
            ),
            child: Image.asset(
              'assets/logo2.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      actions: [
        if (isOnMainScreen)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Modelselector(),
          ),
      ],
    );
  }
}
