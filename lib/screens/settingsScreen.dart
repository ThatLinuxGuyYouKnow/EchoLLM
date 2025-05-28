import 'package:echo_llm/models/chats.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/userConfig.dart';

import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatefulWidget {
  final String tileTitle;
  final IconData tileIcon;
  final Function() onTilePressed;

  const DrawerTile({
    super.key,
    required this.tileTitle,
    required this.tileIcon,
    required this.onTilePressed,
  });

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: MouseRegion(
        onEnter: (event) => setState(() => isHovered = true),
        onExit: (event) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: widget.onTilePressed,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Color(0xFF1E2733).withOpacity(isHovered ? 1 : 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.tileTitle,
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    widget.tileIcon,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableStreaming = false;
  String _selectedTheme = 'Dark';

  // Define consistent styling
  final TextStyle _settingTitleStyle = GoogleFonts.ubuntu(
    color: Colors.white,
    fontSize: 16,
  );
  final TextStyle _settingSubtitleStyle = GoogleFonts.ubuntu(
    color: Colors.grey[500],
    fontSize: 13,
  );
  final Color _cardBackgroundColor = const Color(0xFF1C1C1E);
  final Color _iconColor = Colors.grey[400]!;

  @override
  Widget build(BuildContext context) {
    final screenState = Provider.of<Screenstate>(context);
    final config = Provider.of<CONFIG>(context);
    final bool shouldSendOnEnter = config.shouldSendOnEnter;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: DrawerTile(
                  tileTitle: 'Models',
                  tileIcon: Icons.smart_toy,
                  onTilePressed: () {
                    screenState.modelScreen();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Chat Interface'),
          _buildSettingsCard(
            children: [
              _buildSwitchListTile(
                title: 'Send on Enter',
                subtitle: 'Press Enter key to send messages',
                icon: Icons.keyboard_return,
                value: shouldSendOnEnter,
                onChanged: (value) {
                  if (value) {
                    config.setToSendonEnter();
                  } else {
                    config.setNotToSendOnEnter();
                  }
                },
              ),
              _buildDivider(),
              _buildSwitchListTile(
                title: 'Stream Responses',
                subtitle: 'Receive model responses as they are generated',
                icon: Icons.stream,
                value: _enableStreaming,
                onChanged: (value) {
                  setState(() {
                    _enableStreaming = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Appearance'),
          _buildSettingsCard(
            children: [
              _buildDropdownListTile(
                title: 'Theme',
                icon: Icons.brightness_6,
                currentValue: _selectedTheme,
                items: ['Dark', 'Light', 'System Default'],
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTheme = newValue;
                    });
                  }
                },
              ),
              _buildDivider(),
              _buildNavigationListTile(
                title: 'Message Bubble Style',
                subtitle: 'Customize the look of chat messages',
                icon: Icons.chat_bubble_outline,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Navigate to bubble style settings...')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Account'),
          _buildSettingsCard(
            children: [
              _buildNavigationListTile(
                title: 'Manage API Keys',
                icon: Icons.vpn_key_outlined,
                onTap: () {
                  screenState.keyManagementScreen();
                },
              ),
              _buildDivider(),
              _buildNavigationListTile(
                title: 'Delete Chat History',
                icon: Icons.delete_forever,
                iconColor: Colors.red[400],
                textColor: Colors.red[400],
                onTap: () {
                  _buildDeleteConfirmationDialog();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 5.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.ubuntu(
          color: Colors.grey[600],
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      color: _cardBackgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // This makes the card size to its content
        children: children,
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: _iconColor),
      title: Text(title, style: _settingTitleStyle),
      subtitle: subtitle != null
          ? Text(subtitle, style: _settingSubtitleStyle)
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color.fromARGB(255, 58, 91, 134),
        activeTrackColor: Color(0xFF1E2733),
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[700],
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
    );
  }

  Widget _buildNavigationListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? _iconColor),
      title: Text(title,
          style: _settingTitleStyle.copyWith(color: textColor ?? Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle, style: _settingSubtitleStyle)
          : null,
      trailing:
          Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }

  Widget _buildDropdownListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required String currentValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: _iconColor),
      title: Text(title, style: _settingTitleStyle),
      subtitle: subtitle != null
          ? Text(subtitle, style: _settingSubtitleStyle)
          : null,
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          dropdownColor: const Color(0xFF2A3441),
          iconEnabledColor: Colors.cyan,
          style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 15),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 0.5,
      thickness: 0.5,
      color: Colors.grey[800],
      indent: 56,
    );
  }

  _buildDeleteConfirmationDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext dialogContext) {
        final messageState = Provider.of<Messagestreamstate>(context);
        return AlertDialog(
          backgroundColor: const Color(0xFF2A3441),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Updated to 10 for consistency
          ),
          title: Text('Delete Chat History?',
              style: GoogleFonts.ubuntu(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete your chat history?',
                    style: GoogleFonts.ubuntu(color: Colors.grey[300])),
                Text('This action cannot be undone.',
                    style: GoogleFonts.ubuntu(
                        color: Colors.grey[400], fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: GoogleFonts.ubuntu(color: Colors.grey[400])),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Delete',
                  style: GoogleFonts.ubuntu(color: Colors.white)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  final chatBox = await Hive.openBox<Chat>('chats');
                  chatBox.clear();
                  messageState.clear();
                  showCustomToast(context,
                      message: 'Deleted your chat history',
                      type: ToastMessageType.success);
                } catch (Error) {
                  showCustomToast(context,
                      message:
                          'Unexpected Error Occured, couldnt delete your chats');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
