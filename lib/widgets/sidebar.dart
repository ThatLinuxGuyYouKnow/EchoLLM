import 'package:echo_llm/screens/keyManagementScreen.dart';
import 'package:echo_llm/screens/modelScreen.dart';
import 'package:echo_llm/screens/settingsScreen.dart';

import 'package:echo_llm/state_management/screenState.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Update DrawerTile class
class DrawerTile extends StatefulWidget {
  final String tileTitle;
  final IconData tileIcon;
  final Function() onTilePressed;
  final bool isActive;

  DrawerTile({
    super.key,
    required this.tileTitle,
    required this.tileIcon,
    required this.onTilePressed,
    this.isActive = false,
  });

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MouseRegion(
        onHover: (event) {
          isHovered = true;
          setState(() {});
        },
        onExit: (event) {
          isHovered = false;
          setState(() {});
        },
        child: GestureDetector(
          onTap: widget.onTilePressed,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(
                isHovered ? 0.7 : (widget.isActive ? 0.4 : 0.2),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.tileTitle,
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Icon(widget.tileIcon, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Update SpecialDrawerTile class
class SpecialDrawerTile extends StatefulWidget {
  final String tileTitle;
  final IconData tileIcon;
  final Function() onTilePressed;
  final bool isActive;

  SpecialDrawerTile({
    super.key,
    required this.tileTitle,
    required this.tileIcon,
    required this.onTilePressed,
    this.isActive = false,
  });

  @override
  State<SpecialDrawerTile> createState() => _SpecialDrawerTileState();
}

class _SpecialDrawerTileState extends State<SpecialDrawerTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MouseRegion(
        onHover: (event) {
          isHovered = true;
          setState(() {});
        },
        onExit: (event) {
          isHovered = false;
          setState(() {});
        },
        child: GestureDetector(
          onTap: widget.onTilePressed,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(
                isHovered ? 0.7 : (widget.isActive ? 0.4 : 0.2),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(widget.tileIcon, color: Colors.white),
                  Text(
                    widget.tileTitle,
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Update CustomSideBar usage
class CustomSideBar extends StatelessWidget {
  CustomSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenState = Provider.of<Screenstate>(context);
    final isOnChatScreen = screenState.isOnMainScreen;

    return Material(
      child: AnimatedContainer(
        color: const Color(0xFF1E2733),
        duration: const Duration(seconds: 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            children: [
              // ... other elements
              DrawerTile(
                tileTitle: 'Settings',
                tileIcon: Icons.precision_manufacturing,
                onTilePressed: () => screenState.settingsScreen(),
                isActive: screenState.currentScreen is SettingsScreen,
              ),
              DrawerTile(
                tileTitle: 'Models',
                tileIcon: Icons.smart_toy,
                onTilePressed: () => screenState.modelScreen(),
                isActive: screenState.currentScreen is ModelScreen,
              ),
              DrawerTile(
                tileTitle: 'Keys',
                tileIcon: Icons.key,
                onTilePressed: () => screenState.keyManagementScreen(),
                isActive: screenState.currentScreen is KeyManagementScreen,
              ),
              if (!isOnChatScreen)
                SpecialDrawerTile(
                  tileTitle: 'Back to chat',
                  tileIcon: Icons.arrow_back_ios,
                  onTilePressed: () => screenState.chatScreen(),
                  isActive: isOnChatScreen,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
