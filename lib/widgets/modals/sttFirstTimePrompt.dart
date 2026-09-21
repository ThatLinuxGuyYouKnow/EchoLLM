import 'dart:async';
import 'package:echo_llm/services/stt_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

const _sttOfferKey = 'stt_offer_shown';

bool _hasShownSttOffer() {
  return GetStorage('preferences').read<bool>(_sttOfferKey) ?? false;
}

void markSttOfferShown() {
  GetStorage('preferences').write(_sttOfferKey, true);
}

void maybeShowSttOffer(BuildContext context) {
  if (_hasShownSttOffer()) return;

  final isDark = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: isDark ? const Color(0xFF1E2733) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.mic, color: Color(0xFF4A90E2), size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  'Voice Input Available',
                  style: GoogleFonts.ubuntu(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'EchoLLM now supports offline speech-to-text. '
              'It uses a 68\u00A0MB model that runs entirely on your device — '
              'no internet needed for transcription.',
              style: GoogleFonts.ubuntu(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You can download it now or later from the mic button in the chat bar.',
              style: GoogleFonts.ubuntu(
                color: isDark ? Colors.grey[500] : Colors.grey[500],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            _SttOfferDownloadRow(),
          ],
        ),
      ),
    ),
  );
}

class _SttOfferDownloadRow extends StatefulWidget {
  @override
  State<_SttOfferDownloadRow> createState() => _SttOfferDownloadRowState();
}

class _SttOfferDownloadRowState extends State<_SttOfferDownloadRow> {
  bool _downloading = false;
  double _progress = 0.0;
  SttService? _service;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_downloading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: _progress > 0 ? _progress : null,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
          ),
          const SizedBox(height: 10),
          Text(
            'Downloading model...',
            style: GoogleFonts.ubuntu(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            markSttOfferShown();
            Navigator.pop(context);
          },
          child: Text(
            'Maybe Later',
            style: GoogleFonts.ubuntu(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: _startDownload,
          child: Text(
            'Download (68\u00A0MB)',
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startDownload() async {
    setState(() => _downloading = true);

    _service = SttService();
    _service!.addListener(_onProgress);
    await _service!.downloadModel();
    _service!.removeListener(_onProgress);
    _service = null;

    markSttOfferShown();
    if (mounted) Navigator.pop(context);
  }

  void _onProgress() {
    if (_service != null && mounted) {
      setState(() {
        _progress = _service!.downloadProgress;
      });
    }
  }
}