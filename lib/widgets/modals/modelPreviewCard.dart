import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModelPreviewCard extends StatelessWidget {
  // These will be provided by the parent widget
  final String modelName;
  final String subtitle;
  final String description;
  final String knowledgeCutoff;
  final String contextWindow;
  final String speed;
  final String inputCost;
  final String params;
  final bool isNew;
  final Widget? brandingImage;
  final Widget? backgroundImage;
  final VoidCallback? onSelectModel;
  final VoidCallback? onCompare;
  final VoidCallback? onClose;

  const ModelPreviewCard({
    super.key,
    required this.modelName,
    this.subtitle = '',
    this.description = '',
    this.knowledgeCutoff = '',
    this.contextWindow = '',
    this.speed = '',
    this.inputCost = '',
    this.params = '',
    this.isNew = false,
    this.brandingImage,
    this.backgroundImage,
    this.onSelectModel,
    this.onCompare,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 460,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1E2733),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background gradient/image area
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 180,
                child: backgroundImage ??
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1A2744),
                            const Color(0xFF0D1520),
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: _BackgroundPatternPainter(),
                      ),
                    ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header row with branding and close button
                    _buildHeader(),
                    const SizedBox(height: 24),
                    // Model name with NEW badge
                    _buildModelName(),
                    const SizedBox(height: 8),
                    // Subtitle and knowledge cutoff
                    _buildSubtitleRow(),
                    const SizedBox(height: 16),
                    // Description
                    _buildDescription(),
                    const SizedBox(height: 24),
                    // Stats row
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    // Action buttons
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Branding area - will be replaced with actual image
        brandingImage ??
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'GOOGLE',
                    style: GoogleFonts.roboto(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'GOOGLE DEEPMIND',
                  style: GoogleFonts.roboto(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
        // Close button
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModelName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          modelName,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        if (isNew) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Text(
              'NEW',
              style: GoogleFonts.inter(
                color: const Color(0xFF60A5FA),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubtitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            subtitle,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if (knowledgeCutoff.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'KNOWLEDGE CUTOFF',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                knowledgeCutoff,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: GoogleFonts.inter(
        color: Colors.white.withOpacity(0.5),
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1E2733),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: _buildStatItem(
                  'CONTEXT\nWINDOW', contextWindow, Icons.view_in_ar_outlined)),
          _buildDivider(),
          Expanded(
              child: _buildStatItem('SPEED', speed, Icons.flash_on_outlined)),
          _buildDivider(),
          Expanded(
              child:
                  _buildStatItem('INPUT COST', inputCost, Icons.attach_money)),
          _buildDivider(),
          Expanded(child: _buildStatItem('PARAMS', params, Icons.functions)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.4),
              size: 14,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value.isEmpty ? '-' : value,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFF1E2733),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Select Model button
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: onSelectModel,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF3B82F6),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select Model',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Compare button
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: onCompare,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2733),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF2D3748),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  'Compare',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the abstract background pattern
class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          const Color(0xFF2563EB).withOpacity(0.15),
          const Color(0xFF1E40AF).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw some abstract circles/patterns
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.5),
      80,
      paint,
    );

    final paint2 = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          const Color(0xFF3B82F6).withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      60,
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
