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

    return Container(
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
              Text(
                steps > 0 ? '${(stepRatio * 100).toInt()}% GOAL' : '--',
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: RecovaColors.monochromeWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── 3 Column Activity Metrics ──
          Row(
            children: [
              // Steps
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STEPS',
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
                      '/ 10,000',
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
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      final str = number.toString();
      return '${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}';
    }
    return number.toString();
  }
}
