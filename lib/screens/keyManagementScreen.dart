import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:echo_llm/widgets/appBar.dart';
import 'package:echo_llm/widgets/modals/enterApiKeyModal.dart';

class ApiKey {
  final String id;
  String name;
  String serviceName;
  String modelName;
  String keyValue;

  ApiKey({
    required this.id,
    required this.name,
    required this.serviceName,
    required this.modelName,
    required this.keyValue,
  });
}

class KeyManagementScreen extends StatefulWidget {
  const KeyManagementScreen({super.key});

  @override
  State<KeyManagementScreen> createState() => _KeyManagementScreenState();
}

class _KeyManagementScreenState extends State<KeyManagementScreen> {
  final List<ApiKey> _apiKeys = [
    ApiKey(
        id: '1',
        name: 'Personal Dev Key',
        serviceName: 'OpenAI',
        modelName: 'GPT-4 Turbo',
        keyValue:
            'sk-abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
    ApiKey(
        id: '2',
        name: 'Project Echo Key',
        serviceName: 'Gemini',
        modelName: 'Gemini 1.5 Pro',
        keyValue: 'ai-anotherlongapikeyvaluegoeshereandcanbequitelongindeed'),
    ApiKey(
        id: '3',
        name: 'Shared Team Key',
        serviceName: 'Anthropic',
        modelName: 'Claude 3 Opus',
        keyValue: 'claude-apikey-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'),
  ];

  final Color _cardBackgroundColor = const Color(
      0xFF1E2733); // Using sidebar color for cards or Color(0xFF1C1C1E)
  final TextStyle _keyNameStyle = GoogleFonts.ubuntu(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);
  final TextStyle _keyDetailStyle =
      GoogleFonts.ubuntu(color: Colors.grey[400], fontSize: 13);
  final TextStyle _maskedKeyStyle = GoogleFonts.ubuntu(
      color: Colors.grey[500], fontSize: 14, fontStyle: FontStyle.italic);

  void _addOrUpdateKey(ApiKey key) {
    // Logic to add or update key in your persistent storage / state
    final index = _apiKeys.indexWhere((k) => k.id == key.id);
    setState(() {
      if (index != -1) {
        _apiKeys[index] = key;
      } else {
        _apiKeys.add(key);
      }
    });
  }

  void _deleteKey(String keyId) {
    // Logic to delete key
    setState(() {
      _apiKeys.removeWhere((key) => key.id == keyId);
    });
  }

  String _maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return apiKey;
    return '${apiKey.substring(0, 5)}...${apiKey.substring(apiKey.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _apiKeys.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _apiKeys.length,
              itemBuilder: (context, index) {
                final apiKey = _apiKeys[index];
                return _buildApiKeyCard(apiKey);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.cyan,
        icon: const Icon(Icons.add, color: Colors.black87),
        label: Text(
          'Add New Key',
          style: GoogleFonts.ubuntu(
              color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.vpn_key_off_outlined, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 20),
          Text(
            'No API Keys Found',
            style: GoogleFonts.ubuntu(color: Colors.grey[500], fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first API key to get started.',
            style: GoogleFonts.ubuntu(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyCard(ApiKey apiKey) {
    return Card(
      color: _cardBackgroundColor,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(apiKey.name, style: _keyNameStyle),
            const SizedBox(height: 4),
            Text('${apiKey.serviceName} - ${apiKey.modelName}',
                style: _keyDetailStyle),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.security, color: Colors.grey[500], size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _maskApiKey(apiKey.keyValue),
                    style: _maskedKeyStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy_outlined,
                      color: Colors.grey[400], size: 20),
                  tooltip: 'Copy Key',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: apiKey.keyValue));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('API Key copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[700]),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.edit_outlined,
                      color: Colors.cyan[600], size: 18),
                  label: Text('Edit',
                      style: GoogleFonts.ubuntu(color: Colors.cyan[600])),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: Icon(Icons.delete_outline,
                      color: Colors.redAccent[100], size: 18),
                  label: Text('Delete',
                      style: GoogleFonts.ubuntu(color: Colors.redAccent[100])),
                  onPressed: () => _showDeleteConfirmation(context, apiKey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, ApiKey apiKey) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A3441), // Dark dialog background
          title: Text('Delete API Key?',
              style: GoogleFonts.ubuntu(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete the key named "${apiKey.name}" for ${apiKey.serviceName}?',
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.8)),
              child: Text('Delete',
                  style: GoogleFonts.ubuntu(color: Colors.white)),
              onPressed: () {
                _deleteKey(apiKey.id);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('API Key "${apiKey.name}" deleted.')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
