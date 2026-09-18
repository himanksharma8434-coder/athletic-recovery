import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';

class BentoTelemetryPods extends StatelessWidget {
  final double? dayStrain;
  final double? sleepHours;
  final double? baselineSleepHours;
  final SleepStageBreakdown? sleepStages;

  const BentoTelemetryPods({
    super.key,
    this.dayStrain,
    this.sleepHours,
    this.baselineSleepHours,
    this.sleepStages,
  });

  @override
  Widget build(BuildContext context) {
    final hasStrain = dayStrain != null && dayStrain! > 0.0;
    final strain = dayStrain ?? 0.0;
    final strainPercent = (strain / 21.0).clamp(0.0, 1.0);

    final hasSleep = sleepHours != null && sleepHours! > 0.0;
    final sleep = sleepHours ?? 0.0;
    final sleepH = sleep.floor();
    final sleepM = ((sleep - sleepH) * 60).round();

    // Calculate real sleep performance vs baseline (e.g. 7-8h or user baseline)
    final baselineH = baselineSleepHours ?? 8.0;
    final sleepPerf = hasSleep && baselineH > 0
        ? ((sleep / baselineH) * 100).clamp(0, 150).round()
        : null;

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
                      hasStrain ? strain.toStringAsFixed(1) : '--',
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
                  hasStrain
                      ? (strain >= 14
                          ? 'HIGH LOAD'
                          : strain >= 8
                              ? 'MODERATE LOAD'
                              : 'LIGHT LOAD')
                      : 'NO LOAD RECORDED',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: hasStrain
                        ? RecovaColors.kineticAmberGold
                        : RecovaColors.textMuted,
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
                  children: [
                    Row(
                      children: const [
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
                      sleepPerf != null ? '$sleepPerf% PERF' : '--',
                      style: const TextStyle(
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
                      hasSleep ? '${sleepH}h' : '--',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.5,
                        color: RecovaColors.textPrimary,
                      ),
                    ),
                    if (hasSleep) ...[
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
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  hasSleep
                      ? (sleep >= baselineH
                          ? 'BASELINE MET'
                          : 'SLEEP DEFICIT')
                      : 'AWAITING SLEEP LOG',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: hasSleep
                        ? (sleep >= baselineH
                            ? RecovaColors.recoveryEmerald
                            : RecovaColors.kineticAmberGold)
                        : RecovaColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                // Real Stage breakdown or single bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox(
                    height: 4,
                    child: (sleepStages != null && sleepStages!.hasStageData)
                        ? Row(
                            children: [
                              if (sleepStages!.deepMinutes > 0)
                                Expanded(
                                  flex: sleepStages!.deepMinutes,
                                  child: Container(
                                      color: RecovaColors.restorativeAzure),
                                ),
                              if (sleepStages!.remMinutes > 0)
                                Expanded(
                                  flex: sleepStages!.remMinutes,
                                  child: Container(
                                      color: RecovaColors.neuralViolet),
                                ),
                              if (sleepStages!.lightMinutes > 0)
                                Expanded(
                                  flex: sleepStages!.lightMinutes,
                                  child: Container(
                                      color:
                                          Colors.white.withValues(alpha: 0.25)),
                                ),
                              if (sleepStages!.awakeMinutes > 0)
                                Expanded(
                                  flex: sleepStages!.awakeMinutes,
                                  child: Container(
                                      color: RecovaColors.stressCrimson
                                          .withValues(alpha: 0.6)),
                                ),
                            ],
                          )
                        : Container(
                            color: hasSleep
                                ? RecovaColors.restorativeAzure
                                : Colors.white.withValues(alpha: 0.08),
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
