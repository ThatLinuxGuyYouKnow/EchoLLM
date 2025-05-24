import 'package:echo_llm/dataHandlers/hive/getChats.dart';
import 'package:echo_llm/logic/convertMessageState.dart';
import 'package:echo_llm/models/chats.dart';
import 'package:echo_llm/screens/keyManagementScreen.dart';
import 'package:echo_llm/screens/modelScreen.dart';
import 'package:echo_llm/screens/settingsScreen.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';

import 'package:echo_llm/state_management/screenState.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
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

class NewChatTile extends StatefulWidget {
  NewChatTile({super.key, required this.onTilePressed});

  final Function() onTilePressed;

  @override
  State<NewChatTile> createState() => _NewChatTileState();
}

class _NewChatTileState extends State<NewChatTile> {
  bool isHovered = false;

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
                isHovered ? 0.7 : 0.4,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  Text(
                    'New Chat',
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

class CustomSideBar extends StatefulWidget {
  const CustomSideBar({super.key});

  @override
  State<CustomSideBar> createState() => _CustomSideBarState();
}

class _CustomSideBarState extends State<CustomSideBar> {
  List<MapEntry<String, String>> chatMetadata = [];

  @override
  void initState() {
    super.initState();
    loadChatTitles();
  }

  Future<void> loadChatTitles() async {
    final entries = await getChatLabelsAndIds();
    setState(() {
      chatMetadata = entries;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenState = Provider.of<Screenstate>(context);
    final isOnChatScreen = screenState.isOnMainScreen;
    final messageState = Provider.of<Messagestreamstate>(context);
    return Material(
      child: AnimatedContainer(
        color: const Color(0xFF1E2733),
        duration: const Duration(seconds: 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewChatTile(
                onTilePressed: () => messageState.clear(),
              ),
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
              const Divider(color: Colors.white30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Saved Chats',
                  style: GoogleFonts.ubuntu(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...chatMetadata.map((entry) => ListTile(
                    dense: true,
                    title: Text(
                      entry.value,
                      style: GoogleFonts.ubuntu(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: const Icon(Icons.chat, color: Colors.white),
                    onTap: () async {
                      final messageState = Provider.of<Messagestreamstate>(
                          context,
                          listen: false);
                      messageState.setCurrentChatID(entry.key);

                      final chatBox = await Hive.openBox<Chat>('chats');
                      final selectedChat = chatBox.get(entry.key);

                      if (selectedChat != null) {
                        final restoredMessages =
                            convertHiveMessagesToIndexed(selectedChat.messages);
                        messageState.setMessages(
                            newMessageList: restoredMessages);
                        screenState.chatScreen();
                      }

                      debugPrint('Tapped on chat with ID: ${entry.key}');
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
