import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/widgets/sidebar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Collapsedsidebar extends StatelessWidget {
  Widget build(BuildContext context) {
    final sidebarstate = Provider.of<Sidebarstate>(context);
    return AnimatedContainer(
      color: Color(0xFF1E2733),
      duration: Duration(seconds: 1),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MinimalCollapseIcon(
                  onPressed: () => sidebarstate.expand(),
                  isCollapsed: sidebarstate.isCollapsed,
                ),
              ],
            ),
            NewChatCollapsedTile(),
            SizedBox(
              height: 20,
            ),
            SettingsCollapsedTile()
          ],
        ),
      ),
    );
  }
}

class NewChatCollapsedTile extends StatefulWidget {
  @override
  State<NewChatCollapsedTile> createState() => _NewChatCollapsedTileState();
}

class _NewChatCollapsedTileState extends State<NewChatCollapsedTile> {
  bool isHovered = false;

  Widget build(BuildContext context) {
    final messageState = Provider.of<Messagestreamstate>(context);
    final screenState = Provider.of<Screenstate>(context);
    return GestureDetector(
      onTap: () => screenState.isOnMainScreen
          ? messageState.clear()
          : screenState.chatScreen(),
      child: MouseRegion(
        onEnter: (event) => setState(() {
          isHovered = true;
        }),
        onExit: (event) => setState(() {
          isHovered = false;
        }),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF4A90E2).withOpacity(isHovered ? 1 : 0.7)),
          child: Center(
            child: Icon(
              screenState.isOnMainScreen ? Icons.add : Icons.chat_bubble,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsCollapsedTile extends StatefulWidget {
  @override
  State<SettingsCollapsedTile> createState() => _SettingsCollapsedTileState();
}

class _SettingsCollapsedTileState extends State<SettingsCollapsedTile> {
  bool isHovered = false;
  Widget build(BuildContext context) {
    final screenState = Provider.of<Screenstate>(context);
    return GestureDetector(
      onTap: () => screenState.settingsScreen(),
      child: MouseRegion(
        onEnter: (event) => setState(() {
          isHovered = true;
        }),
        onExit: (event) => setState(() {
          isHovered = false;
        }),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black..withOpacity(isHovered ? 0.7 : 0.1)),
          child: Center(
            child: Icon(
              Icons.precision_manufacturing,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
