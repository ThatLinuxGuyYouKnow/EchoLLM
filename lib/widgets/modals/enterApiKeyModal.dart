import 'package:echo_llm/mappings/providerConfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:echo_llm/state_management/keysState.dart';

/// Prompt for a provider's API key. One key unlocks every model from that
/// provider. [modelName] optionally names the model that triggered the
/// prompt (e.g. from a model tile).
Widget EnterApiKeyModal({
  required String providerId,
  String? modelName,
  required BuildContext context,
}) {
  final provider = providerById(providerId);
  final displayName = provider?.displayName ?? providerId;
  final hint = provider?.keyHint ?? 'API key';
  final keyUrl = provider?.keyUrl ?? '';
  final TextEditingController apiKeyController = TextEditingController();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Dialog(
    backgroundColor:
        isDark ? const Color(0xFF1E2733) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
    ),
    child: Container(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your $displayName API key',
              style: GoogleFonts.ubuntu(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              modelName != null && modelName.isNotEmpty
                  ? 'Needed for $modelName. One key unlocks all $displayName models.'
                  : 'One key unlocks all $displayName models.',
              style: GoogleFonts.ubuntu(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 13,
              ),
            ),
            if (keyUrl.isNotEmpty) ...[
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(keyUrl),
                    mode: LaunchMode.externalApplication),
                child: Text(
                  'Get a key: $keyUrl',
                  style: GoogleFonts.ubuntu(
                    color: const Color(0xFF4C83D1),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: apiKeyController,
              obscureText: true,
              obscuringCharacter: '•',
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF2A3441)
                    : const Color(0xFFF0F2F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.ubuntu(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C83D1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    // Use Provider to add key (one key per provider).
                    Provider.of<KeysState>(context, listen: false)
                        .addProviderKey(
                            providerId: providerId,
                            key: apiKeyController.text.trim());
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save Key',
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
