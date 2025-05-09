import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/widgets/modelSelector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  DarkAppBar({super.key});
  Widget build(BuildContext context) {
    final sidebar = Provider.of<Sidebarstate>(context);
    final bool isonMainScreen =
        Provider.of<Screenstate>(context).isOnMainScreen;
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isonMainScreen ? Modelselector() : SizedBox.shrink(),
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
                  style:
                      IconButton.styleFrom(backgroundColor: Color(0xFF1E2733)),
                  onPressed: () {
                    sidebar.expand();
                  },
                  icon: Icon(
                    Icons.trip_origin,
                    color: Colors.white,
                    weight: 0.1,
                  ))
              : SizedBox.shrink(),
          SizedBox(
            width: 20,
          ),
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
