import 'dart:async';

import 'package:echo_llm/dataHandlers/hive/getChats.dart';
import 'package:echo_llm/logic/convertMessageState.dart';
import 'package:echo_llm/models/chats.dart';

import 'package:echo_llm/screens/settingsScreen.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';

import 'package:echo_llm/state_management/screenState.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

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
              // Updated colors for better visual appeal
              gradient: isHovered
                  ? LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isHovered ? null : Color(0xFF4A90E2).withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'New Chat',
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight:
                          isHovered ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: isHovered ? 22 : 20,
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

// New ChatTile widget for individual chat items
class ChatTile extends StatefulWidget {
  final MapEntry<String, String> chatEntry;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.chatEntry,
    required this.onTap,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => isHovered = true),
      onExit: (event) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: isHovered
              ? Color(0xFF4A90E2).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isHovered
              ? Border.all(color: Color(0xFF4A90E2).withOpacity(0.3), width: 1)
              : null,
        ),
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          title: Text(
            widget.chatEntry.value,
            style: GoogleFonts.ubuntu(
              color: isHovered ? Color(0xFF4A90E2) : Colors.white,
              fontWeight: isHovered ? FontWeight.w500 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          leading: Icon(
            Icons.chat_bubble_outline,
            color: isHovered ? Color(0xFF4A90E2) : Colors.white70,
            size: 18,
          ),
          onTap: widget.onTap,
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
  late final Box<Chat> chatBox;
  late final StreamSubscription<BoxEvent> chatBoxListener;

  @override
  void initState() {
    super.initState();
    initHiveListener();
  }

  Future<void> initHiveListener() async {
    chatBox = await Hive.openBox<Chat>('chats');

    // Load existing chat metadata
    loadChatTitles();

    // We Watch for changes here
    chatBoxListener = chatBox.watch().listen((event) {
      loadChatTitles();
    });
  }

  @override
  void dispose() {
    chatBoxListener.cancel();
    super.dispose();
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
              isOnChatScreen
                  ? NewChatTile(
                      onTilePressed: () => messageState.clear(),
                    )
                  : SpecialDrawerTile(
                      tileTitle: 'Back to chat',
                      tileIcon: Icons.arrow_back_ios,
                      onTilePressed: () => screenState.chatScreen(),
                      isActive: isOnChatScreen,
                    ),
              DrawerTile(
                tileTitle: 'Settings',
                tileIcon: Icons.precision_manufacturing,
                onTilePressed: () => screenState.settingsScreen(),
                isActive: screenState.currentScreen is SettingsScreen,
              ),
              if (screenState.isOnMainScreen && chatMetadata.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: Text(
                    'PREVIOUS CHATS',
                    style: GoogleFonts.ubuntu(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: chatMetadata.length,
                    itemBuilder: (context, index) {
                      final entry = chatMetadata[index];
                      return ChatTile(
                        chatEntry: entry,
                        onTap: () async {
                          final messageState = Provider.of<Messagestreamstate>(
                              context,
                              listen: false);
                          messageState.setCurrentChatID(entry.key);

                          final chatBox = await Hive.openBox<Chat>('chats');
                          final selectedChat = chatBox.get(entry.key);

                          if (selectedChat != null) {
                            final restoredMessages =
                                convertHiveMessagesToIndexed(
                                    selectedChat.messages);
                            messageState.setMessages(
                                newMessageList: restoredMessages);
                            screenState.chatScreen();
                          }

                          debugPrint('Tapped on chat with ID: ${entry.key}');
                        },
                      );
                    },
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
