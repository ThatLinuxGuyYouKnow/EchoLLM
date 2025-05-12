import 'package:echo_llm/screens/modelScreen.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomSideBar extends StatelessWidget {
  CustomSideBar({super.key});
  Widget build(BuildContext context) {
    final sidebar = Provider.of<Sidebarstate>(context);
    final messageState = Provider.of<Messagestreamstate>(context);
    final setScreenTo = Provider.of<Screenstate>(context);
    final isOnChatScreen = Provider.of<Screenstate>(context).isOnMainScreen;
    return Material(
      child: AnimatedContainer(
        color: Color(0xFF1E2733),
        duration: Duration(seconds: 2),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  IconButton.filled(
                      tooltip: 'Collpse SideBar',
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.3)),
                      onPressed: () {
                        sidebar.collapse();
                      },
                      icon: Icon(
                        Icons.hide_source,
                        color: Colors.white,
                      ))
                ],
              ),
              isOnChatScreen
                  ? DrawerTile(
                      tileTitle: 'New Chat',
                      tileIcon: Icons.add,
                      onTilePressed: () {
                        messageState.clear();
                      },
                    )
                  : SizedBox.shrink(),
              DrawerTile(
                tileTitle: 'Settings',
                tileIcon: Icons.precision_manufacturing,
                onTilePressed: () {
                  setScreenTo.settingsScreen();
                },
              ),
              DrawerTile(
                tileTitle: 'Models',
                tileIcon: Icons.smart_toy,
                onTilePressed: () {
                  setScreenTo.modelScreen();
                },
              ),
              DrawerTile(
                tileTitle: 'Keys',
                tileIcon: Icons.key,
                onTilePressed: () {},
              ),
              SizedBox(
                height: 70,
              ),
              isOnChatScreen
                  ? SizedBox.shrink()
                  : SpecialDrawerTile(
                      tileTitle: 'Back to chat',
                      tileIcon: Icons.arrow_back_ios,
                      onTilePressed: () {
                        setScreenTo.chatScreen();
                      })
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatefulWidget {
  final String tileTitle;
  final IconData tileIcon;
  final Function() onTilePressed;
  DrawerTile(
      {super.key,
      required this.tileTitle,
      required this.tileIcon,
      required this.onTilePressed});

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
          onTap: () {
            widget.onTilePressed();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(isHovered ? 0.7 : 0.2),
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
                  Icon(
                    widget.tileIcon,
                    color: Colors.white,
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

class SpecialDrawerTile extends StatefulWidget {
  final String tileTitle;
  final IconData tileIcon;
  final Function() onTilePressed;
  SpecialDrawerTile(
      {super.key,
      required this.tileTitle,
      required this.tileIcon,
      required this.onTilePressed});

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
          onTap: () {
            widget.onTilePressed();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(isHovered ? 0.2 : 0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.tileIcon,
                    color: Colors.white,
                  ),
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
