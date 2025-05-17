import 'package:echo_llm/dataHandlers/heyHelper.dart';
import 'package:echo_llm/mappings/modelSlugMappings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final apikey = ApiKeyHelper();

  final Color _cardBackgroundColor = const Color(
      0xFF1E2733); // Using sidebar color for cards or Color(0xFF1C1C1E)
  final TextStyle _keyNameStyle = GoogleFonts.ubuntu(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500);
  final TextStyle _keyDetailStyle =
      GoogleFonts.ubuntu(color: Colors.grey[400], fontSize: 13);
  final TextStyle _maskedKeyStyle = GoogleFonts.ubuntu(
      color: Colors.grey[500], fontSize: 14, fontStyle: FontStyle.italic);

/*   void _addOrUpdateKey(ApiKey key) {
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
 */

  String _maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return apiKey;
    return '${apiKey.substring(0, 5)}...${apiKey.substring(apiKey.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final ModelKeyMap = apikey.getAvailableModelKeyMap();
    final modelKeyEntries = ModelKeyMap.entries.toList();
    String _deriveServiceName(String modelSlug) {
      final reversed = {for (var e in onlineModels.entries) e.value: e.key};
      return reversed[modelSlug] ?? "Unknown Service";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: ModelKeyMap.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: modelKeyEntries.length,
              itemBuilder: (context, index) {
                final entry = modelKeyEntries[index];
                final apiKey = ApiKey(
                  id: entry.key,
                  name: entry.key, // You can customize this later
                  serviceName: _deriveServiceName(entry.key), // Optional helper
                  modelName: entry.key,
                  keyValue: entry.value,
                );
                return _buildApiKeyCard(apiKey);
              }),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A37), // A softer dark tone for contrast
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Model + Service Header
          Row(
            children: [
              const Icon(Icons.api_rounded, color: Colors.cyanAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${apiKey.serviceName} - ${apiKey.modelName}',
                  style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Masked key & copy button
          Row(
            children: [
              const Icon(Icons.vpn_key_rounded, color: Colors.grey, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _maskApiKey(apiKey.keyValue),
                  style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    color: Colors.grey[300],
                    fontStyle: FontStyle.italic,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_outlined, color: Colors.white70),
                tooltip: 'Copy API Key',
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
          Divider(color: Colors.grey[800], thickness: 1),
          const SizedBox(height: 10),

          // Footer with actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: Icon(Icons.edit_outlined,
                    color: Colors.amberAccent[200], size: 18),
                label: Text('Edit',
                    style: GoogleFonts.ubuntu(color: Colors.amberAccent[200])),
                onPressed: () {
                  // TODO: edit logic
                },
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
