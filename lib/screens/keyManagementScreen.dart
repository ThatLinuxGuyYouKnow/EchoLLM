import 'package:echo_llm/mappings/modelDataService.dart';
import 'package:echo_llm/widgets/modals/addNewKeyModal.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:echo_llm/state_management/keysState.dart';

class ApiKey {
  final String id;
  String name;
  String serviceName;
  String modelSlug;
  String keyValue;

  ApiKey({
    required this.id,
    required this.name,
    required this.serviceName,
    required this.modelSlug,
    required this.keyValue,
  });
}

class KeyManagementScreen extends StatefulWidget {
  const KeyManagementScreen({super.key});

  @override
  State<KeyManagementScreen> createState() => _KeyManagementScreenState();
}

class _KeyManagementScreenState extends State<KeyManagementScreen> {
  bool _isFabHovered = false;

  String _maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return apiKey;
    return '${apiKey.substring(0, 5)}...${apiKey.substring(apiKey.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<KeysState>(
      builder: (context, keysState, child) {
        final modelKeyMap = keysState.modelKeys;
        final modelKeyEntries = modelKeyMap.entries.toList();

        String _deriveServiceName(String modelSlug) {
          final reversed = {for (var e in onlineModels.entries) e.value: e.key};
          return reversed[modelSlug] ?? "Unknown Service";
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: modelKeyMap.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: modelKeyEntries.length,
                  itemBuilder: (context, index) {
                    final entry = modelKeyEntries[index];
                    final apiKey = ApiKey(
                      id: entry.key,
                      name: entry.key,
                      serviceName: _deriveServiceName(entry.key),
                      modelSlug: entry.key,
                      keyValue: entry.value,
                    );
                    return _buildApiKeyCard(apikey: apiKey);
                  }),
          floatingActionButton: MouseRegion(
            onEnter: (_) => setState(() => _isFabHovered = true),
            onExit: (_) => setState(() => _isFabHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: const Color(0xFF4C83D1)
                    .withOpacity(_isFabHovered ? 1.0 : 0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: _isFabHovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4C83D1).withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddNewKeyModal(
                        isNewUser: false,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: _isFabHovered ? 22 : 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add New Key',
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: _isFabHovered ? 15 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.vpn_key_off_outlined,
              size: 80,
              color: isDark ? Colors.grey[700] : Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            'No API Keys Found',
            style: GoogleFonts.ubuntu(
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first API key to get started.',
            style: GoogleFonts.ubuntu(
                color: isDark ? Colors.grey[600] : Colors.grey[500],
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyCard({required ApiKey apikey}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 150),
      child: Card(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
          child: ListTile(
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert,
                  color: isDark ? Colors.white : Colors.black87),
              color: isDark ? const Color(0xFF2A2A2E) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    break;
                  case 'delete':
                    _showDeleteConfirmation(context, apikey);
                    break;
                  case 'copy':
                    Clipboard.setData(ClipboardData(text: apikey.keyValue));
                    showCustomToast(context,
                        message: 'API key copied to clipboard',
                        type: ToastMessageType.passive,
                        duration: Duration(seconds: 1));
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'copy',
                  child: Row(
                    children: [
                      Icon(Icons.copy,
                          size: 18,
                          color: isDark ? Colors.white : Colors.black87),
                      const SizedBox(width: 10),
                      Text('Copy',
                          style: GoogleFonts.ubuntu(
                              color: isDark ? Colors.white : Colors.black87)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete_outline,
                          size: 18, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Text('Delete',
                          style: GoogleFonts.ubuntu(
                              color: isDark ? Colors.white : Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            leading: Icon(
              Icons.key_outlined,
              color: isDark ? Colors.white : Colors.black87,
            ),
            title: Text(apikey.serviceName,
                style: GoogleFonts.ubuntu(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 15)),
            subtitle: Text(
              _maskApiKey(apikey.keyValue),
              style: GoogleFonts.ubuntu(
                  color: isDark ? Colors.grey : Colors.grey[600]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, ApiKey apiKey) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modelName = apiKey.serviceName;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF2A3441) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10),
          ),
          title: Text('Delete API Key?',
              style: GoogleFonts.ubuntu(
                  color: isDark ? Colors.white : Colors.black87)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete the key for $modelName?',
                    style: GoogleFonts.ubuntu(
                        color: isDark ? Colors.grey[300] : Colors.grey[700])),
                Text('This action cannot be undone.',
                    style: GoogleFonts.ubuntu(
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                        fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: GoogleFonts.ubuntu(
                      color: isDark ? Colors.grey[400] : Colors.grey[600])),
              onPressed: () {
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
                try {
                  Provider.of<KeysState>(context, listen: false)
                      .deleteKey(modelSlug: apiKey.modelSlug);
                  showCustomToast(context,
                      message: 'Deleted Key for $modelName');
                } catch (error) {
                  showCustomToast(context,
                      message:
                          'An error occured while tring to delete this key',
                      type: ToastMessageType.error);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
