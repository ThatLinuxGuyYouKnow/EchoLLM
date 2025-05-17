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

  final Color _cardBackgroundColor = Color(0xFF1C1C1E);

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
                  name: entry.key,
                  serviceName: _deriveServiceName(entry.key),
                  modelName: entry.key,
                  keyValue: entry.value,
                );
                return _buildApiKeyCard(apikey: apiKey);
              }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Color.fromARGB(255, 37, 52, 71),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add New Key',
          style: GoogleFonts.ubuntu(
              color: Colors.white, fontWeight: FontWeight.w600),
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

  Widget _buildApiKeyCard({required ApiKey apikey}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 150),
      child: Card(
        color: _cardBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          // side: BorderSide(color: Colors.grey[800]!, width: 0.5), // Optional subtle border
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
          child: ListTile(
            trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            leading: Icon(
              Icons.key_outlined,
              color: Colors.white,
            ),
            title: Text(apikey.serviceName,
                style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 15)),
            subtitle: Text(_maskApiKey(apikey.keyValue)),
          ),
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
