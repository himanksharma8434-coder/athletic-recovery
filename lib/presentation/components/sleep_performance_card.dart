import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';

/// Full-width Nothing OS Bento Card for Sleep Architecture.
/// Replaces the squeezed 2-column pod with a comprehensive restorative breakdown.
class SleepPerformanceCard extends StatelessWidget {
  final double? sleepHours;
  final double? baselineSleepHours;
  final SleepStageBreakdown? sleepStages;
  final List<DistributedSleepSession> sleepSessions;
  final VoidCallback? onTap;

  const SleepPerformanceCard({
    super.key,
    this.sleepHours,
    this.baselineSleepHours,
    this.sleepStages,
    this.sleepSessions = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSleep = sleepHours != null && sleepHours! > 0.0;
    final sleep = sleepHours ?? 0.0;
    final sleepH = sleep.floor();
    final sleepM = ((sleep - sleepH) * 60).round();

    final baselineH = baselineSleepHours ?? 8.0;
    final sleepPerf = hasSleep && baselineH > 0
        ? ((sleep / baselineH) * 100).clamp(0, 150).round()
        : null;

    final stages = sleepStages;
    final hasStages = stages != null && stages.hasStageData;

    String debtText = 'AWAITING SLEEP LOG';
    Color debtColor = RecovaColors.textMuted;
    if (hasSleep) {
      final diffMins = ((sleep - baselineH) * 60).round();
      if (diffMins >= 0) {
        debtText = '+$diffMins m vs 14D baseline • Fully Restored';
        debtColor = RecovaColors.textSecondary;
      } else {
        debtText = '${diffMins.abs()} m sleep debt • Cellular deficit';
        debtColor = RecovaColors.nothingRed;
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RecovaColors.surfaceElevation1,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RecovaColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: const [
                      Icon(Icons.bedtime_outlined,
                          size: 14, color: RecovaColors.textTertiary),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'SLEEP ARCHITECTURE',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: RecovaColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: RecovaColors.surfaceElevation2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RecovaColors.borderSubtle),
                      ),
                      child: Text(
                        sleepPerf != null ? '$sleepPerf% PERFORMANCE' : '--',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          color: RecovaColors.monochromeWhite,
                        ),
                      ),
                    ),
                    if (onTap != null) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: RecovaColors.textTertiary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          const SizedBox(height: 12),

          // ── Big Duration Readout & Delta ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    hasSleep ? '${sleepH}h' : '--',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.8,
                      color: RecovaColors.textPrimary,
                    ),
                  ),
                  if (hasSleep) ...[
                    const SizedBox(width: 4),
                    Text(
                      '${sleepM}m',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: RecovaColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                'TARGET: ${baselineH.toStringAsFixed(1)}h',
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.6,
                  color: RecovaColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // ── Debt / Status Subtitle ──
          Text(
            debtText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              color: debtColor,
            ),
          ),
          if (sleepSessions.length > 1) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: sleepSessions.map((s) {
                final sH = s.durationHours.floor();
                final sM = s.durationMinutes % 60;
                final durStr = sH > 0 ? '${sH}h ${sM}m' : '${sM}m';
                final isNight = s.type == SleepSessionType.nightSleep;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: RecovaColors.surfaceElevation2,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isNight
                          ? RecovaColors.borderSubtle
                          : RecovaColors.nothingRed.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    '${s.title} • $durStr',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: isNight ? RecovaColors.textSecondary : RecovaColors.nothingRed,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 14),

          // ── Monochrome Stage Distribution Bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 4,
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
          const SizedBox(height: 10),

          // ── Stages Legend (Responsive Wrap) ──
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _StageLegendItem(
                dotColor: RecovaColors.monochromeWhite,
                label: 'DEEP',
                value: hasStages ? '${stages.deepMinutes}m' : '--',
              ),
              _StageLegendItem(
                dotColor: RecovaColors.monochromeSilver,
                label: 'REM',
                value: hasStages ? '${stages.remMinutes}m' : '--',
              ),
              _StageLegendItem(
                dotColor: RecovaColors.monochromeGray,
                label: 'LIGHT',
                value: hasStages ? '${stages.lightMinutes}m' : '--',
              ),
              _StageLegendItem(
                dotColor: RecovaColors.nothingRed,
                label: 'AWAKE',
                value: hasStages ? '${stages.awakeMinutes}m' : '--',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}

class _StageLegendItem extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String value;

  const _StageLegendItem({
    required this.dotColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '$label $value',
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: RecovaColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
