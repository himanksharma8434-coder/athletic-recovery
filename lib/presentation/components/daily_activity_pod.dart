import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

/// Daily Movement & Energy Expenditure Card.
/// Replaces the ECG waveform with clear daily activity tracking (Steps & Calories).
class DailyActivityPod extends StatelessWidget {
  final int? todaySteps;
  final double? activeCalories;
  final double? totalCalories;

  const DailyActivityPod({
    super.key,
    this.todaySteps,
    this.activeCalories,
    this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    final steps = todaySteps ?? 0;
    final activeKcal = activeCalories?.toInt() ?? 0;
    final totalKcal = totalCalories?.toInt() ?? 0;

    const stepTarget = 10000;
    final stepRatio = (steps / stepTarget).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => _showDailyActivityDetails(context, steps, activeKcal, totalKcal, stepRatio),
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
                      Icon(Icons.directions_run,
                          size: 15, color: RecovaColors.monochromeWhite),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'DAILY ACTIVITY & ENERGY',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: RecovaColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      steps > 0 ? '${(stepRatio * 100).toInt()}% GOAL' : '--',
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: RecovaColors.monochromeWhite,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 12,
                      color: RecovaColors.textTertiary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── 3 Column Activity Metrics ──
            Row(
              children: [
                // Steps (Day Only)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'STEPS (TODAY)',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        steps > 0 ? _formatNumber(steps) : '--',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.5,
                          color: RecovaColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'TODAY • / 10,000',
                        style: TextStyle(
                          fontSize: 9,
                          color: RecovaColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

              Container(
                width: 1,
                height: 32,
                color: RecovaColors.borderSubtle,
              ),
              const SizedBox(width: 12),

              // Active Calories
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACTIVE BURN',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activeKcal > 0 ? '$activeKcal' : '--',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.5,
                        color: RecovaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'kcal active',
                      style: TextStyle(
                        fontSize: 9,
                        color: RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 1,
                height: 32,
                color: RecovaColors.borderSubtle,
              ),
              const SizedBox(width: 12),

              // Total Metabolic Burn
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL BURN',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      totalKcal > 0 ? '$totalKcal' : '--',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.5,
                        color: RecovaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'kcal with BMR',
                      style: TextStyle(
                        fontSize: 9,
                        color: RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Progress Bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: stepRatio,
              minHeight: 3.5,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(
                RecovaColors.monochromeWhite,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  String _formatNumber(int number) {
    if (number >= 1000) {
      final str = number.toString();
      return '${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}';
    }
    return number.toString();
  }

  void _showDailyActivityDetails(
    BuildContext context,
    int steps,
    int activeKcal,
    int totalKcal,
    double stepRatio,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: RecovaColors.surfaceElevation1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: RecovaColors.borderMedium,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DAILY ACTIVITY TELEMETRY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: RecovaColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: RecovaColors.surfaceElevation3,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RecovaColors.borderSubtle),
                      ),
                      child: const Text(
                        'DAY ONLY (00:00 - NOW)',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: RecovaColors.monochromeWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Detail Bento
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: RecovaColors.surfaceElevation2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RecovaColors.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pedometer Steps (Today)',
                            style: TextStyle(
                              fontSize: 11,
                              color: RecovaColors.textSecondary,
                            ),
                          ),
                          Text(
                            steps > 0 ? '${_formatNumber(steps)} steps' : '--',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: RecovaColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16, color: RecovaColors.borderSubtle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Goal Completion',
                            style: TextStyle(
                              fontSize: 11,
                              color: RecovaColors.textSecondary,
                            ),
                          ),
                          Text(
                            steps > 0 ? '${(stepRatio * 100).toInt()}% of 10k target' : '--',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: RecovaColors.monochromeWhite,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16, color: RecovaColors.borderSubtle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Active Energy Expenditure',
                            style: TextStyle(
                              fontSize: 11,
                              color: RecovaColors.textSecondary,
                            ),
                          ),
                          Text(
                            activeKcal > 0 ? '$activeKcal kcal' : '--',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: RecovaColors.kineticAmberGold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16, color: RecovaColors.borderSubtle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Caloric Burn (with BMR)',
                            style: TextStyle(
                              fontSize: 11,
                              color: RecovaColors.textSecondary,
                            ),
                          ),
                          Text(
                            totalKcal > 0 ? '$totalKcal kcal' : '--',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: RecovaColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: RecovaColors.surfaceElevation2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RecovaColors.borderSubtle),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.shield_outlined, size: 14, color: RecovaColors.textTertiary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Telemetry is strictly aggregated for today (from midnight to present). Multi-source overlaps (phone and watch) and weekly accumulations are de-duplicated to ensure 100% daily accuracy.',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: RecovaColors.textTertiary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

