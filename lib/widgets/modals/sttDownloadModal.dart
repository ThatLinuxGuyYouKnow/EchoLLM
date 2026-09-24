import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:echo_llm/state_management/sttState.dart';

Widget buildSttDownloadDialog({
  required BuildContext context,
  required VoidCallback onDownloadComplete,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Dialog(
    backgroundColor: isDark ? const Color(0xFF1E2733) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mic, color: const Color(0xFF4A90E2), size: 24),
              const SizedBox(width: 10),
              Text(
                'Voice Input',
                style: GoogleFonts.ubuntu(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'To use voice input, EchoLLM needs to download a speech recognition model (~68 MB). This model runs entirely offline — your voice data never leaves your device.',
            style: GoogleFonts.ubuntu(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _DownloadProgressDialog(onComplete: onDownloadComplete),
        ],
      ),
    ),
  );
}

class _DownloadProgressDialog extends StatefulWidget {
  final VoidCallback onComplete;
  const _DownloadProgressDialog({required this.onComplete});

  @override
  State<_DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  bool _isDownloading = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_isDownloading) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.ubuntu(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C83D1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: _startDownload,
                child: Text(
                  'Download',
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          LinearProgressIndicator(
            value: _progress > 0 ? _progress : null,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
          ),
          const SizedBox(height: 12),
          Text(
            _progress >= 1.0
                ? 'Unpacking model...'
                : 'Downloading... ${(_progress * 100).toInt()}%',
            style: GoogleFonts.ubuntu(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _startDownload() async {
    setState(() => _isDownloading = true);

    final sttState = Provider.of<SttState>(context, listen: false);
    sttServiceListener() {
      final service = sttState.sttService;
      if (mounted) {
        setState(() {
          _progress = service.downloadProgress;
        });
      }
      if (service.isModelReady) {
        sttState.sttService.removeListener(sttServiceListener);
        if (mounted) {
          widget.onComplete();
          Navigator.pop(context);
        }
      }
    }

    sttState.sttService.addListener(sttServiceListener);
    await sttState.downloadModel();
  }
}