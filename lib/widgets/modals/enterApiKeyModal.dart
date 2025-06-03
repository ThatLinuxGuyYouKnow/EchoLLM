import 'package:echo_llm/dataHandlers/hive/ApikeyHelper.dart';
import 'package:echo_llm/widgets/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterApiKeyModal extends StatefulWidget {
  final String modelName;
  final String modelSlug;

  const EnterApiKeyModal({
    super.key,
    required this.modelName,
    required this.modelSlug,
  });

  @override
  State<EnterApiKeyModal> createState() => _EnterApiKeyModalState();
}

class _EnterApiKeyModalState extends State<EnterApiKeyModal> {
  final TextEditingController _apiKeyController = TextEditingController();
  final ApiKeyHelper _apiKeyHelper = ApiKeyHelper();
  bool _isSaving = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E2733),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your API key for ${widget.modelName}',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              obscuringCharacter: '•',
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2A3441),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Paste your API key here...',
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
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveApiKey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C83D1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
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
    );
  }

  Future<void> _saveApiKey() async {
    if (_apiKeyController.text.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final successfulSave = await _apiKeyHelper.storeKey(
        modelSlugNotName: widget.modelSlug,
        apiKey: _apiKeyController.text.trim(),
      );

      if (mounted) {
        if (successfulSave) {
          showCustomToast(
            context,
            message: 'Saved Key for ${widget.modelName}',
            type: ToastMessageType.success,
          );
          Navigator.pop(context);
        } else {
          showCustomToast(
            context,
            message: 'Failed to save key for ${widget.modelName}',
            type: ToastMessageType.error,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
