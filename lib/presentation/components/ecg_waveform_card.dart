import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

class EcgWaveformCard extends StatelessWidget {
  final double? restingHr;

  const EcgWaveformCard({
    super.key,
    this.restingHr,
  });

  @override
  Widget build(BuildContext context) {
    final hr = restingHr?.toInt() ?? 62;

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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: RecovaColors.recoveryEmerald,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '25 HZ SENSOR',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                      color: RecovaColors.textTertiary,
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
                    child: const Icon(Icons.favorite_outline,
                        size: 16, color: RecovaColors.recoveryEmerald),
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
                            '$hr',
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
                      const Text(
                        'RESTING VASCULAR',
                        style: TextStyle(
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
                  painter: _EcgSparklinePainter(),
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
                    child: const Icon(Icons.air,
                        size: 16, color: RecovaColors.restorativeAzure),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '14.2',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              color: RecovaColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
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
                        'RESPIRATION CYCLE',
                        style: TextStyle(
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
                  color: RecovaColors.recoveryEmeraldContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RecovaColors.recoveryEmeraldBorder),
                ),
                child: const Text(
                  'IN RANGE',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: RecovaColors.recoveryEmerald,
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
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = RecovaColors.recoveryEmerald
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final midY = size.height / 2;

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
