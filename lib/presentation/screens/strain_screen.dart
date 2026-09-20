import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';

class StrainScreen extends StatelessWidget {
  final DerivedMetricSummary? summary;

  const StrainScreen({
    super.key,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final hasStrain = summary?.dayStrain != null && summary!.dayStrain! > 0.0;
    final dayStrain = summary?.dayStrain ?? 0.0;
    final targetStrain = summary?.targetStrain ?? 14.0;
    final activeCalories = summary?.activeCalories?.toInt();
    final totalCalories = summary?.totalCalories?.toInt();
    final todaySteps = summary?.todaySteps;
    final workouts = summary?.workouts ?? [];

    final progressRatio = targetStrain > 0 ? (dayStrain / targetStrain).clamp(0.0, 1.0) : 0.0;
    final progressPercent = (progressRatio * 100).round();

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
                'STRAIN & WORKOUTS',
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
                      color: hasStrain
                          ? RecovaColors.borderMedium
                          : RecovaColors.borderSubtle),
                ),
                child: Text(
                  hasStrain
                      ? (dayStrain >= 14
                          ? 'HIGH ACCUMULATION'
                          : dayStrain >= 8
                              ? 'MODERATE LOAD'
                              : 'LIGHT ACCUMULATION')
                      : 'NO STRAIN LOGGED',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: hasStrain
                        ? RecovaColors.textPrimary
                        : RecovaColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Strain Score Hero Card (100% Real Accumulated Load) ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation1,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: RecovaColors.borderSubtle),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DAY STRAIN',
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
                              hasStrain ? dayStrain.toStringAsFixed(1) : '--',
                              style: const TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1.0,
                                color: RecovaColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '/ 21.0',
                              style: TextStyle(
                                fontSize: 14,
                                color: RecovaColors.textMuted,
                              ),
                            ),
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
                            color: hasStrain
                                ? RecovaColors.borderMedium
                                : RecovaColors.borderSubtle),
                      ),
                      child: Icon(
                        Icons.bolt,
                        size: 28,
                        color: hasStrain
                            ? RecovaColors.monochromeWhite
                            : RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Target progress
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TARGET STRAIN: ${targetStrain.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: RecovaColors.textSecondary,
                          ),
                        ),
                        Text(
                          hasStrain ? '$progressPercent% MET' : 'STANDBY',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: hasStrain
                                ? RecovaColors.textPrimary
                                : RecovaColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progressRatio,
                        minHeight: 5,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            RecovaColors.monochromeWhite),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),      ),
          const SizedBox(height: 14),

          // ── Caloric & Step Load (100% Real from Health Connect) ──
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
                        'ACTIVE ENERGY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activeCalories != null
                            ? '$activeCalories kcal'
                            : (totalCalories != null
                                ? '$totalCalories kcal'
                                : '--'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: RecovaColors.kineticAmberGold,
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
                        'PEDOMETER STEPS',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        todaySteps != null ? '$todaySteps' : '--',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: RecovaColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Real Activity & Workout Log ──
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RECORDED WORKOUTS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                    Text(
                      workouts.isNotEmpty
                          ? '${workouts.length} LOGGED'
                          : 'AWAITING SENSOR',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        color: workouts.isNotEmpty
                            ? RecovaColors.recoveryEmerald
                            : RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (workouts.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.center,
                    child: Column(
                      children: const [
                        Icon(Icons.directions_run,
                            size: 28, color: RecovaColors.textMuted),
                        SizedBox(height: 8),
                        Text(
                          'No workouts logged today.\nStart a workout on your CMF Watch or Nothing X app.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: RecovaColors.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...workouts.map((w) {
                    final timeStr =
                        '${w.startTime.hour.toString().padLeft(2, '0')}:${w.startTime.minute.toString().padLeft(2, '0')}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildWorkoutItem(
                        icon: Icons.fitness_center,
                        title: w.title,
                        time: '$timeStr • ${w.durationMinutes} mins',
                        strain: (w.durationMinutes * 0.15).clamp(1.0, 18.0).toStringAsFixed(1),
                        avgHr: w.calories != null ? '${w.calories!.toInt()} kcal' : null,
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem({
    required IconData icon,
    required String title,
    required String time,
    required String strain,
    String? avgHr,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RecovaColors.surfaceElevation2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RecovaColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: RecovaColors.monochromeWhite),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: RecovaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: RecovaColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt,
                      size: 13, color: RecovaColors.monochromeWhite),
                  Text(
                    strain,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: RecovaColors.monochromeWhite,
                    ),
                  ),
                ],
              ),
              if (avgHr != null)
                Text(
                  avgHr,
                  style: const TextStyle(
                    fontSize: 9,
                    color: RecovaColors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
