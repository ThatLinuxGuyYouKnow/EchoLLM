import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sendOnEnter = true;
  bool _enableStreaming = false;
  String _selectedTheme = 'Dark'; // Example theme state

  // Define consistent styling
  final TextStyle _settingTitleStyle = GoogleFonts.ubuntu(
    color: Colors.white,
    fontSize: 16,
  );
  final TextStyle _settingSubtitleStyle = GoogleFonts.ubuntu(
    color: Colors.grey[500],
    fontSize: 13,
  );
  final Color _cardBackgroundColor =
      const Color(0xFF1C1C1E); // Dark card background
  final Color _iconColor = Colors.grey[400]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildSectionTitle('Chat Interface'),
          _buildSettingsCard(
            children: [
              _buildSwitchListTile(
                title: 'Send on Enter',
                subtitle: 'Press Enter key to send messages',
                icon: Icons.keyboard_return,
                value: _sendOnEnter,
                onChanged: (value) {
                  setState(() {
                    _sendOnEnter = value;
                  });
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Navigate to API key management...')),
                  );
                },
              ),
              _buildDivider(),
              _buildNavigationListTile(
                title: 'Log Out',
                icon: Icons.logout,
                iconColor: Colors.red[400], // Different color for emphasis
                textColor: Colors.red[400],
                onTap: () {
                  // Implement log out logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logging out...')),
                  );
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
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
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
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 150),
      child: Card(
        color: _cardBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          // side: BorderSide(color: Colors.grey[800]!, width: 0.5), // Optional subtle border
        ),
        child: Column(
          children: children,
        ),
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
}
