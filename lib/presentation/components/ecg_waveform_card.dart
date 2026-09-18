import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

class EcgWaveformCard extends StatelessWidget {
  final double? restingHr;
  final double? respirationRate;

  const EcgWaveformCard({
    super.key,
    this.restingHr,
    this.respirationRate,
  });

  @override
  Widget build(BuildContext context) {
    final hasHr = restingHr != null && restingHr! > 0;
    final hrText = hasHr ? '${restingHr!.toInt()}' : '--';

    final hasRpm = respirationRate != null && respirationRate! > 0;
    final rpmText = hasRpm ? respirationRate!.toStringAsFixed(1) : '--';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RecovaColors.surfaceElevation1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RecovaColors.borderSubtle),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BIOMETRIC TELEMETRY',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: RecovaColors.textTertiary,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasHr
                          ? RecovaColors.recoveryEmerald
                          : RecovaColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    hasHr ? 'HEALTH CONNECT LIVE' : 'SENSOR STANDBY',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                      color: hasHr
                          ? RecovaColors.textTertiary
                          : RecovaColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Vascular HR with Waveform
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: RecovaColors.surfaceElevation3,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: RecovaColors.borderSubtle),
                    ),
                    child: Icon(Icons.favorite_outline,
                        size: 16,
                        color: hasHr
                            ? RecovaColors.recoveryEmerald
                            : RecovaColors.textMuted),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            hrText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              color: RecovaColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'BPM',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: RecovaColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        hasHr ? 'RESTING VASCULAR' : 'NO PULSE LOGGED',
                        style: const TextStyle(
                          fontSize: 8,
                          letterSpacing: 0.8,
                          color: RecovaColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // ECG Sparkline Waveform Painter
              SizedBox(
                width: 110,
                height: 28,
                child: CustomPaint(
                  painter: _EcgSparklinePainter(active: hasHr),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: RecovaColors.borderSubtle),
          const SizedBox(height: 10),

          // Respiration Cycle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: RecovaColors.surfaceElevation3,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: RecovaColors.borderSubtle),
                    ),
                    child: Icon(Icons.air,
                        size: 16,
                        color: hasRpm
                            ? RecovaColors.restorativeAzure
                            : RecovaColors.textMuted),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            rpmText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              color: RecovaColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'RPM',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: RecovaColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        hasRpm ? 'RESPIRATION CYCLE' : 'NO RESPIRATION LOGGED',
                        style: const TextStyle(
                          fontSize: 8,
                          letterSpacing: 0.8,
                          color: RecovaColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasRpm
                      ? RecovaColors.recoveryEmeraldContainer
                      : RecovaColors.surfaceElevation3,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: hasRpm
                          ? RecovaColors.recoveryEmeraldBorder
                          : RecovaColors.borderSubtle),
                ),
                child: Text(
                  hasRpm ? 'IN RANGE' : 'AWAITING SYNC',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: hasRpm
                        ? RecovaColors.recoveryEmerald
                        : RecovaColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EcgSparklinePainter extends CustomPainter {
  final bool active;

  _EcgSparklinePainter({this.active = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = active
          ? RecovaColors.recoveryEmerald
          : Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final midY = size.height / 2;

    if (!active) {
      // Flat line when inactive
      path.moveTo(0, midY);
      path.lineTo(size.width, midY);
      canvas.drawPath(path, paint);
      return;
    }

    path.moveTo(0, midY);
    path.lineTo(size.width * 0.25, midY);
    // P wave
    path.lineTo(size.width * 0.32, midY - 3);
    path.lineTo(size.width * 0.38, midY);
    // Q wave
    path.lineTo(size.width * 0.45, midY + 2);
    // R spike
    path.lineTo(size.width * 0.52, 2);
    // S dip
    path.lineTo(size.width * 0.58, size.height - 2);
    // T wave
    path.lineTo(size.width * 0.65, midY);
    path.lineTo(size.width * 0.75, midY - 4);
    path.lineTo(size.width * 0.82, midY);
    path.lineTo(size.width, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EcgSparklinePainter oldDelegate) =>
      oldDelegate.active != active;
}
