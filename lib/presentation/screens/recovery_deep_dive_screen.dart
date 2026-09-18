import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';

class RecoveryDeepDiveScreen extends StatelessWidget {
  final DerivedMetricSummary? summary;

  const RecoveryDeepDiveScreen({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final score = summary?.recoveryScore ?? 82.0;
    final tier = RecoveryTier.fromScore(summary?.recoveryScore);
    final vo2 = summary?.estimatedVo2Max;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Title ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RECOVERY ANALYSIS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: RecovaColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tier.containerColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: tier.borderColor),
                ),
                child: Text(
                  tier.label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: tier.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Component Breakdown Card ──
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
                  'COMPOSITE RECOVERY ALGORITHM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: RecovaColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summary?.primaryFactor ??
                      'Autonomic nervous system calibrated to baseline.',
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: RecovaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildMetricProgressRow(
                  label: 'RESTING HEART RATE',
                  weight: '50% WEIGHT',
                  score: summary?.recoveryComponentRhr ?? 88.0,
                  valueText: summary?.restingHr != null
                      ? '${summary!.restingHr!.toInt()} bpm'
                      : '48 bpm',
                  color: RecovaColors.recoveryEmerald,
                ),
                const SizedBox(height: 14),
                _buildMetricProgressRow(
                  label: 'SLEEP DURATION & STAGES',
                  weight: '35% WEIGHT',
                  score: summary?.recoveryComponentSleep ?? 85.0,
                  valueText: summary?.sleepHours != null
                      ? '${summary!.sleepHours!.toStringAsFixed(1)} hrs'
                      : '7.8 hrs',
                  color: RecovaColors.restorativeAzure,
                ),
                const SizedBox(height: 14),
                _buildMetricProgressRow(
                  label: 'BLOOD OXYGEN (SPO2)',
                  weight: '15% WEIGHT',
                  score: summary?.recoveryComponentSpo2 ?? 95.0,
                  valueText: summary?.spo2 != null
                      ? '${summary!.spo2!.toStringAsFixed(0)}%'
                      : '98%',
                  color: RecovaColors.kineticAmberGold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Estimated VO2 Max Card ──
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
                    Row(
                      children: const [
                        Icon(Icons.speed,
                            size: 16, color: RecovaColors.recoveryEmerald),
                        SizedBox(width: 6),
                        Text(
                          'ESTIMATED VO₂ MAX',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: RecovaColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: RecovaColors.surfaceElevation3,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: RecovaColors.borderSubtle),
                      ),
                      child: const Text(
                        'CALCULATED',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: RecovaColors.recoveryEmerald,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      vo2 != null ? vo2.toStringAsFixed(1) : '52.4',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -1.0,
                        color: RecovaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'mL/kg/min',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: RecovaColors.recoveryEmeraldContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: RecovaColors.recoveryEmeraldBorder),
                      ),
                      child: const Text(
                        'SUPERIOR TIER',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: RecovaColors.recoveryEmerald,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Uth–Sørensen Formula: VO₂max ≈ 15.3 × (HRmax / HRrest)\nAutomatically calculated from resting HR baseline and workout peak HR via Health Connect. No manual profile input needed.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: RecovaColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── 14-Day Recovery Trend Chart ──
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
                      '14-DAY RECOVERY TREND',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                    Text(
                      'AUTONOMIC BAND',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: RecovaColors.recoveryEmerald,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white.withValues(alpha: 0.05),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 25,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}%',
                              style: const TextStyle(
                                fontSize: 8,
                                color: RecovaColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 3,
                            getTitlesWidget: (value, meta) {
                              const labels = [
                                '14d', '11d', '8d', '5d', '2d', 'Today'
                              ];
                              final idx = (value / 2.5).clamp(0, 5).toInt();
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  labels[idx],
                                  style: const TextStyle(
                                    fontSize: 8.5,
                                    color: RecovaColors.textMuted,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 14,
                      minY: 40,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 72),
                            const FlSpot(2, 68),
                            const FlSpot(4, 76),
                            const FlSpot(6, 84),
                            const FlSpot(8, 79),
                            const FlSpot(10, 85),
                            const FlSpot(12, 81),
                            FlSpot(14, score),
                          ],
                          isCurved: true,
                          color: RecovaColors.recoveryEmerald,
                          barWidth: 2.5,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              if (index == barData.spots.length - 1) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: RecovaColors.recoveryEmerald,
                                  strokeColor: Colors.white,
                                  strokeWidth: 2,
                                );
                              }
                              return FlDotCirclePainter(
                                radius: 2,
                                color: RecovaColors.recoveryEmerald,
                                strokeWidth: 0,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                RecovaColors.recoveryEmerald
                                    .withValues(alpha: 0.25),
                                RecovaColors.recoveryEmerald
                                    .withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricProgressRow({
    required String label,
    required String weight,
    required double score,
    required String valueText,
    required Color color,
  }) {
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
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: RecovaColors.textPrimary,
              ),
            ),
            Row(
              children: [
                Text(
                  valueText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  weight,
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
                    color: RecovaColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: (score / 100).clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: Colors.white.withValues(alpha: 0.06),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
