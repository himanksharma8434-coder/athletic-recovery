import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

/// Signature Biometric Recovery Gauge
/// Concentric rings with ambient glow drop-shadow, bold % readout,
/// vital pulsing indicator, and semantic status badge.
class RadialScoreGauge extends StatefulWidget {
  final double? score;
  final double size;
  final VoidCallback? onTap;

  const RadialScoreGauge({
    super.key,
    required this.score,
    this.size = 200,
    this.onTap,
  });

  @override
  State<RadialScoreGauge> createState() => _RadialScoreGaugeState();
}

class _RadialScoreGaugeState extends State<RadialScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveScore = widget.score ?? 0;
    final tier = RecoveryTier.fromScore(widget.score);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
          // Background ambient subtle radial depth (No neon bloom)
          Container(
            width: widget.size * 0.72,
            height: widget.size * 0.72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0D0E11),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Custom Painter for Nothing NDot concentric dotted track and arc
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _NothingGaugePainter(
              score: effectiveScore,
              accentColor: tier == RecoveryTier.suppressed
                  ? RecovaColors.nothingRed
                  : RecovaColors.monochromeWhite,
            ),
          ),

          // Inner Content: Recovery %, Label, Status Badge
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'RECOVERY',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.4,
                  color: RecovaColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    widget.score != null ? '${effectiveScore.toInt()}' : '--',
                    style: TextStyle(
                      fontSize: widget.size * 0.25,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -1.5,
                      color: RecovaColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Text(
                    '%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: RecovaColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Nothing X Status Pill with Signature Indicator Dot
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  final dotColor = tier == RecoveryTier.suppressed
                      ? RecovaColors.nothingRed
                      : (widget.score != null
                          ? RecovaColors.monochromeWhite
                          : RecovaColors.textTertiary);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: RecovaColors.surfaceElevation1,
                      border: Border.all(color: RecovaColors.borderSubtle),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotColor.withValues(alpha: _pulseAnimation.value),
                            boxShadow: [
                              BoxShadow(
                                color: dotColor.withValues(
                                    alpha: _pulseAnimation.value * 0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tier.statusSubtitle,
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: RecovaColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (widget.onTap != null) ...[
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'HOW IT\'S CALCULATED',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 9,
                        color: RecovaColors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
    );
  }
}

class _NothingGaugePainter extends CustomPainter {
  final double score;
  final Color accentColor;

  _NothingGaugePainter({required this.score, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;

    // 1. Subtle hairline background circular track
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, bgPaint);

    // 2. Nothing OS NDot Dotted Matrix Ring (60 circular dot ticks)
    const totalDots = 60;
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < totalDots; i++) {
      final angle = (i * 2 * pi) / totalDots - (pi / 2);
      final dotX = center.dx + radius * cos(angle);
      final dotY = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(dotX, dotY), 1.2, dotPaint);
    }

    // 3. Active Score Progress: Dotted and Solid Arc Highlight
    if (score > 0) {
      final activeDotsCount = ((score / 100) * totalDots).round();

      // Highlight active NDots with pure white / accent
      final activeDotPaint = Paint()
        ..color = accentColor
        ..style = PaintingStyle.fill;

      for (int i = 0; i < activeDotsCount; i++) {
        final angle = (i * 2 * pi) / totalDots - (pi / 2);
        final dotX = center.dx + radius * cos(angle);
        final dotY = center.dy + radius * sin(angle);
        canvas.drawCircle(Offset(dotX, dotY), 2.2, activeDotPaint);
      }

      // Smooth inner hairline arc for continuous visual clarity
      final sweepAngle = (score / 100) * 2 * pi;
      final innerArcPaint = Paint()
        ..color = accentColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 6),
        -pi / 2,
        sweepAngle,
        false,
        innerArcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NothingGaugePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.accentColor != accentColor;
  }
}
