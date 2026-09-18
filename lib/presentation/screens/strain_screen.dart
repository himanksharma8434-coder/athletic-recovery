import 'package:flutter/material.dart';
import '../../core/theme/recova_colors.dart';

class StrainScreen extends StatelessWidget {
  const StrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const dayStrain = 11.8;
    const targetStrain = 15.0;
    const activeCalories = 642;
    const totalCalories = 2180;

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
                  color: RecovaColors.kineticAmberContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: RecovaColors.kineticAmberBorder),
                ),
                child: const Text(
                  'MODERATE ACCUMULATION',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: RecovaColors.kineticAmberGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Strain Score Hero Card ──
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
                          children: const [
                            Text(
                              '$dayStrain',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1.0,
                                color: RecovaColors.textPrimary,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
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
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: RecovaColors.kineticAmberContainer,
                        border:
                            Border.all(color: RecovaColors.kineticAmberBorder),
                      ),
                      child: const Icon(
                        Icons.bolt,
                        size: 32,
                        color: RecovaColors.kineticAmberGold,
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
                      children: const [
                        Text(
                          'TARGET STRAIN: $targetStrain',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: RecovaColors.textSecondary,
                          ),
                        ),
                        Text(
                          '78% COMPLETED',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: RecovaColors.kineticAmberGold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: dayStrain / targetStrain,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.06),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            RecovaColors.kineticAmberGold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Caloric Load ──
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
                    children: const [
                      Text(
                        'ACTIVE CALORIES',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '$activeCalories kcal',
                        style: TextStyle(
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
                    children: const [
                      Text(
                        'TOTAL BURN',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '$totalCalories kcal',
                        style: TextStyle(
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

          // ── Heart Rate Zones ──
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
                  'HEART RATE ZONE INTENSITY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: RecovaColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 14),
                _buildZoneRow('Zone 5: Anaerobic (>172 bpm)', '4m', 0.08,
                    RecovaColors.stressCrimson),
                const SizedBox(height: 10),
                _buildZoneRow('Zone 4: Threshold (155–172 bpm)', '18m', 0.28,
                    RecovaColors.kineticAmber),
                const SizedBox(height: 10),
                _buildZoneRow('Zone 3: Aerobic (138–154 bpm)', '32m', 0.44,
                    RecovaColors.kineticAmberGold),
                const SizedBox(height: 10),
                _buildZoneRow('Zone 2: Moderate (120–137 bpm)', '46m', 0.65,
                    RecovaColors.recoveryEmerald),
                const SizedBox(height: 10),
                _buildZoneRow('Zone 1: Active Recovery (<120 bpm)', '1h 12m',
                    0.85, RecovaColors.restorativeAzure),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Activity Log ──
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
                  children: const [
                    Text(
                      'RECORDED WORKOUTS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                    Text(
                      'FROM WEARABLE',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        color: RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildWorkoutItem(
                  icon: Icons.directions_run,
                  title: 'Outdoor Interval Run',
                  time: '7:30 AM • 42 mins',
                  strain: '8.6',
                  avgHr: '158 bpm',
                ),
                const SizedBox(height: 10),
                _buildWorkoutItem(
                  icon: Icons.fitness_center,
                  title: 'Strength Conditioning',
                  time: 'Yesterday • 35 mins',
                  strain: '5.2',
                  avgHr: '132 bpm',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneRow(
      String label, String duration, double fraction, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: RecovaColors.textSecondary,
              ),
            ),
            Text(
              duration,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 4,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutItem({
    required IconData icon,
    required String title,
    required String time,
    required String strain,
    required String avgHr,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: RecovaColors.surfaceElevation3,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: RecovaColors.borderSubtle),
          ),
          child: Icon(icon, size: 18, color: RecovaColors.kineticAmberGold),
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
              Text(
                '$time • Avg $avgHr',
                style: const TextStyle(
                  fontSize: 10,
                  color: RecovaColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: RecovaColors.kineticAmberContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: RecovaColors.kineticAmberBorder),
          ),
          child: Text(
            '$strain STRAIN',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: RecovaColors.kineticAmberGold,
            ),
          ),
        ),
      ],
    );
  }
}
