import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/widgets/modelSelector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  DarkAppBar({super.key});
  Widget build(BuildContext context) {
    final sidebar = Provider.of<Sidebarstate>(context);
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Modelselector(),
        )
      ],
      backgroundColor: Colors.black,
      title: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          sidebar.isCollapsed
              ? IconButton.filled(
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.3)),
                  onPressed: () {
                    sidebar.expand();
                  },
                  icon: Icon(
                    Icons.visibility,
                    color: Colors.white,
                  ))
              : SizedBox.shrink(),
          Text(
            'EchoLLM',
            style: GoogleFonts.ubuntu(color: Colors.cyan),
          ),
          Image.asset(
            'assets/logo.png',
            height: 40,
          )
        ],
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(70);
}
