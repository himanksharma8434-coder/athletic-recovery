import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

/// Signature Biometric Recovery Gauge
/// Concentric rings with ambient glow drop-shadow, bold % readout,
/// vital pulsing indicator, and semantic status badge.
class RadialScoreGauge extends StatefulWidget {
  final double? score;
  final double size;

  const RadialScoreGauge({
    super.key,
    required this.score,
    this.size = 200,
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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient radial blur glow
          Container(
            width: widget.size * 0.75,
            height: widget.size * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: tier.color.withValues(alpha: 0.18),
                  blurRadius: 36,
                  spreadRadius: 8,
                ),
              ],
            ),
          ),

          // Custom Painter for concentric track and arc
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _GaugePainter(
              score: effectiveScore,
              color: tier.color,
            ),
          ),

          // Inner Content: Recovery %, Label, Status Badge
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'RECOVERY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
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
                      fontSize: widget.size * 0.26,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -1.5,
                      color: RecovaColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '%',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: tier.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Status Pill with Pulsing Vital Dot
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: tier.containerColor,
                      border: Border.all(color: tier.borderColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: tier.color
                                .withValues(alpha: _pulseAnimation.value),
                            boxShadow: [
                              BoxShadow(
                                color: tier.color.withValues(
                                    alpha: _pulseAnimation.value * 0.6),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tier.statusSubtitle,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: tier.color,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;

    // Track Background ring
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, bgPaint);

    // Subtle tick circle (dots/dashes)
    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const totalTicks = 48;
    for (int i = 0; i < totalTicks; i++) {
      final angle = (i * 2 * pi) / totalTicks;
      final innerX = center.dx + (radius - 8) * cos(angle);
      final innerY = center.dy + (radius - 8) * sin(angle);
      final outerX = center.dx + (radius - 4) * cos(angle);
      final outerY = center.dy + (radius - 4) * sin(angle);
      canvas.drawLine(Offset(innerX, innerY), Offset(outerX, outerY), tickPaint);
    }

    // Active Arc with Glow
    if (score > 0) {
      final sweepAngle = (score / 100) * 2 * pi;

      // Glow shadow paint
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );

      // Primary crisp arc
      final activePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
