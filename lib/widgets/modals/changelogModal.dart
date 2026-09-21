import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

const String _changelogVersion = '1.1.0';

bool shouldShowChangelog() {
  final prefs = GetStorage('preferences');
  final lastShownVersion = prefs.read<String>('changelog_version');
  return lastShownVersion != _changelogVersion;
}

void markChangelogShown() {
  final prefs = GetStorage('preferences');
  prefs.write('changelog_version', _changelogVersion);
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;
  final bool isBreaking;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    this.isBreaking = false,
  });
}

void showChangelogModal(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final features = [
    _FeatureItem(
      icon: Icons.light_mode_outlined,
      title: 'Light Mode',
      description:
          'A brand new light theme! Switch between Dark, Light, or System Default from Settings.',
    ),
    _FeatureItem(
      icon: Icons.text_fields,
      title: 'Adjustable Text Size',
      description:
          'Scale chat text to your preference — smaller for dense reading, larger for comfort.',
    ),
    _FeatureItem(
      icon: Icons.vpn_key_outlined,
      title: 'Improved API Key Storage',
      description:
          'API keys are now stored securely using platform-native encrypted storage.',
    ),
    _FeatureItem(
      icon: Icons.warning_amber_outlined,
      title: 'Breaking Change: API Keys Reset',
      description:
          'Due to the migration to Flutter Secure Storage, previously stored API keys are no longer accessible. Please re-enter your keys in Settings.',
      isBreaking: true,
    ),
    _FeatureItem(
      icon: Icons.mic_outlined,
      title: 'Voice Input (Speech-to-Text)',
      description:
          'Tap the mic button in the chat bar to dictate messages. The speech model downloads on first use and runs fully offline.',
    ),
  ];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      return Dialog(
        backgroundColor: isDark ? const Color(0xFF1E2733) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF4A90E2),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What\'s New in EchoLLM',
                            style: GoogleFonts.ubuntu(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Version $_changelogVersion',
                            style: GoogleFonts.ubuntu(
                              color: isDark ? Colors.grey[500] : Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: feature.isBreaking
                                ? (isDark
                                    ? Colors.orange.withOpacity(0.08)
                                    : Colors.orange.withOpacity(0.06))
                                : (isDark
                                    ? const Color(0xFF2A3441)
                                    : const Color(0xFFF5F7FA)),
                            borderRadius: BorderRadius.circular(10),
                            border: feature.isBreaking
                                ? Border.all(
                                    color: Colors.orange.withOpacity(0.4),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                feature.icon,
                                color: feature.isBreaking
                                    ? Colors.orange
                                    : const Color(0xFF4A90E2),
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          feature.title,
                                          style: GoogleFonts.ubuntu(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (feature.isBreaking) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'ACTION REQUIRED',
                                              style: GoogleFonts.ubuntu(
                                                color: Colors.orange,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      feature.description,
                                      style: GoogleFonts.ubuntu(
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C83D1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      markChangelogShown();
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'Got it!',
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}