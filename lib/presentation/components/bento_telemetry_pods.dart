import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

class BentoTelemetryPods extends StatelessWidget {
  final double? dayStrain;
  final double? sleepHours;

  const BentoTelemetryPods({
    super.key,
    this.dayStrain,
    this.sleepHours,
  });

  @override
  Widget build(BuildContext context) {
    final strain = dayStrain ?? 9.4;
    final strainPercent = (strain / 21.0).clamp(0.0, 1.0);

    final sleep = sleepHours ?? 7.8;
    final sleepH = sleep.floor();
    final sleepM = ((sleep - sleepH) * 60).round();

    return Row(
      children: [
        // ── Day Strain Pod ──
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RecovaColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.bolt,
                            size: 15, color: RecovaColors.kineticAmberGold),
                        SizedBox(width: 4),
                        Text(
                          'DAY STRAIN',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: RecovaColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'MAX 21',
                      style: TextStyle(
                        fontSize: 8.5,
                        color: RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      strain.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.5,
                        color: RecovaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '/ 21.0',
                      style: TextStyle(
                        fontSize: 11,
                        color: RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  strain >= 14
                      ? 'HIGH LOAD'
                      : strain >= 8
                          ? 'MODERATE LOAD'
                          : 'LIGHT LOAD',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: RecovaColors.kineticAmberGold,
                  ),
                ),
                const SizedBox(height: 12),
                // Progress Bar with target marker
                Stack(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: strainPercent,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              RecovaColors.kineticAmberLight,
                              RecovaColors.kineticAmberGold,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),

        // ── Sleep Architecture Pod ──
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RecovaColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.bedtime,
                            size: 15, color: RecovaColors.restorativeAzure),
                        SizedBox(width: 4),
                        Text(
                          'SLEEP',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: RecovaColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '92% PERF',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        color: RecovaColors.restorativeAzure,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${sleepH}h',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.5,
                        color: RecovaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${sleepM}m',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: RecovaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'DEBT CLEARED',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: RecovaColors.recoveryEmerald,
                  ),
                ),
                const SizedBox(height: 12),
                // Multi-stage bar: Deep, REM, Light
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox(
                    height: 4,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 28, // Deep
                          child: Container(color: RecovaColors.restorativeAzure),
                        ),
                        Expanded(
                          flex: 22, // REM
                          child: Container(
                              color: RecovaColors.restorativeAzure
                                  .withValues(alpha: 0.6)),
                        ),
                        Expanded(
                          flex: 42, // Light
                          child: Container(
                              color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        Expanded(
                          flex: 8, // Awake
                          child: Container(
                              color: RecovaColors.stressCrimson
                                  .withValues(alpha: 0.6)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
