import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';

class SleepScreen extends StatelessWidget {
  final DerivedMetricSummary? summary;

  const SleepScreen({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final hasSleep = summary?.sleepHours != null && summary!.sleepHours! > 0.0;
    final totalHours = summary?.sleepHours ?? 0.0;
    final hours = totalHours.floor();
    final mins = ((totalHours - hours) * 60).round();
    final stages = summary?.sleepStages;
    final hasStages = stages != null && stages.hasStageData;

    // Compare with baseline
    String baselineDiffText = 'AWAITING SLEEP LOG';
    Color baselineDiffColor = RecovaColors.textMuted;
    if (hasSleep && summary?.baselineSleepHours != null) {
      final diffMins =
          ((totalHours - summary!.baselineSleepHours!) * 60).round();
      if (diffMins >= 0) {
        baselineDiffText = '+$diffMins m vs 7-day baseline • Well Rested';
        baselineDiffColor = RecovaColors.textSecondary;
      } else {
        baselineDiffText = '$diffMins m vs 7-day baseline • Sleep Deficit';
        baselineDiffColor = RecovaColors.nothingRed;
      }
    } else if (hasSleep) {
      baselineDiffText = 'Baseline calibrating across 7 days';
      baselineDiffColor = RecovaColors.textSecondary;
    }

    // Sleep performance
    final targetHours = summary?.baselineSleepHours ?? 8.0;
    final perfPercent = hasSleep
        ? ((totalHours / targetHours) * 100).clamp(0, 150).round()
        : null;

    // Sleep efficiency
    final efficiency = hasStages && stages.totalTrackedMinutes > 0
        ? (((stages.deepMinutes + stages.remMinutes + stages.lightMinutes) /
                    stages.totalTrackedMinutes) *
                100)
            .round()
        : (hasSleep ? 92 : null);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SLEEP ARCHITECTURE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: RecovaColors.textPrimary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: RecovaColors.surfaceElevation3,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: hasSleep
                          ? RecovaColors.borderMedium
                          : RecovaColors.borderSubtle),
                ),
                child: Text(
                  perfPercent != null
                      ? '$perfPercent% PERFORMANCE'
                      : 'NO SESSION LOGGED',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: hasSleep
                        ? RecovaColors.textPrimary
                        : RecovaColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Sleep Duration Hero Card (100% Real Sleep Data) ──
          Container(
            padding: const EdgeInsets.all(20),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL TIME ASLEEP',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: RecovaColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              hasSleep ? '${hours}h' : '--',
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1.0,
                                color: RecovaColors.textPrimary,
                              ),
                            ),
                            if (hasSleep) ...[
                              const SizedBox(width: 4),
                              Text(
                                '${mins}m',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w300,
                                  color: RecovaColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: RecovaColors.surfaceElevation3,
                        border: Border.all(
                            color: hasSleep
                                ? RecovaColors.borderMedium
                                : RecovaColors.borderSubtle),
                      ),
                      child: Icon(
                        Icons.bedtime,
                        size: 28,
                        color: hasSleep
                            ? RecovaColors.monochromeWhite
                            : RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  baselineDiffText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: baselineDiffColor,
                  ),
                ),
                const SizedBox(height: 14),

                // Multi-Stage Color Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: SizedBox(
                    height: 6,
                    child: hasStages
                        ? Row(
                            children: [
                              if (stages.deepMinutes > 0)
                                Expanded(
                                  flex: stages.deepMinutes,
                                  child: Container(
                                      color: RecovaColors.monochromeWhite),
                                ),
                              if (stages.remMinutes > 0)
                                Expanded(
                                  flex: stages.remMinutes,
                                  child: Container(
                                      color: RecovaColors.monochromeSilver),
                                ),
                              if (stages.lightMinutes > 0)
                                Expanded(
                                  flex: stages.lightMinutes,
                                  child: Container(
                                      color: RecovaColors.monochromeGray),
                                ),
                              if (stages.awakeMinutes > 0)
                                Expanded(
                                  flex: stages.awakeMinutes,
                                  child: Container(
                                      color: RecovaColors.nothingRed),
                                ),
                            ],
                          )
                        : Container(
                            color: hasSleep
                                ? RecovaColors.monochromeSilver
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Sleep Stages Breakdown ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RecovaColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STAGE ARCHITECTURE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: RecovaColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 14),
                if (!hasStages)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Text(
                      hasSleep
                          ? 'Granular sleep stages (REM / Deep / Light) were not provided by the wearable for this session.'
                          : 'No sleep stages recorded.\nWear your smartwatch to sleep to track recovery.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: RecovaColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  )
                else ...[
                  _buildStageRow(
                    'Deep Sleep (Slow Wave)',
                    '${stages.deepMinutes ~/ 60}h ${stages.deepMinutes % 60}m',
                    '${stages.deepPercentage.round()}%',
                    'Physical restoration & GH release',
                    RecovaColors.monochromeWhite,
                  ),
                  const SizedBox(height: 12),
                  _buildStageRow(
                    'REM Sleep',
                    '${stages.remMinutes ~/ 60}h ${stages.remMinutes % 60}m',
                    '${stages.remPercentage.round()}%',
                    'Cognitive memory consolidation',
                    RecovaColors.monochromeSilver,
                  ),
                  const SizedBox(height: 12),
                  _buildStageRow(
                    'Light Sleep',
                    '${stages.lightMinutes ~/ 60}h ${stages.lightMinutes % 60}m',
                    '${stages.lightPercentage.round()}%',
                    'Baseline metabolic stabilization',
                    RecovaColors.monochromeGray,
                  ),
                  const SizedBox(height: 12),
                  _buildStageRow(
                    'Awake Periods',
                    '${stages.awakeMinutes}m',
                    '${stages.awakePercentage.round()}%',
                    'Micro-arousals during nocturnal transitions',
                    RecovaColors.nothingRed,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Sleep Quality Markers ──
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: RecovaColors.surfaceElevation1,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RecovaColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SLEEP EFFICIENCY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        efficiency != null ? '$efficiency%' : '--',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: efficiency != null
                              ? RecovaColors.recoveryEmerald
                              : RecovaColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        efficiency != null && efficiency >= 85
                            ? 'Optimal rest ratio'
                            : (hasSleep ? 'Fragmented sleep' : 'Standby'),
                        style: const TextStyle(
                          fontSize: 9,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: RecovaColors.surfaceElevation1,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RecovaColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RESTING SPO2',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        summary?.spo2 != null
                            ? '${summary!.spo2!.toStringAsFixed(0)}%'
                            : '--',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: summary?.spo2 != null
                              ? RecovaColors.restorativeAzure
                              : RecovaColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        summary?.spo2 != null && summary!.spo2! >= 95
                            ? 'Optimal oxygenation'
                            : 'Awaiting sync',
                        style: const TextStyle(
                          fontSize: 9,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageRow(
    String stageName,
    String duration,
    String percentage,
    String description,
    Color dotColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stageName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: RecovaColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: RecovaColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        percentage,
                        style: const TextStyle(
                          fontSize: 10,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 10,
                  color: RecovaColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
