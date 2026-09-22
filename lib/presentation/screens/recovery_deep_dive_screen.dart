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
    final score = summary?.recoveryScore;
    final tier = RecoveryTier.fromScore(score);
    final vo2 = summary?.estimatedVo2Max;

    // Convert real 14-day database history to chart spots
    final history = summary?.recoveryHistory14d ?? [];
    final List<FlSpot> spots = [];
    if (history.isNotEmpty) {
      final now = DateTime.now();
      for (final h in history) {
        final daysAgo = now.difference(h.date).inDays;
        final x = (14 - daysAgo).clamp(0, 14).toDouble();
        spots.add(FlSpot(x, h.score));
      }
      spots.sort((a, b) => a.x.compareTo(b.x));
    } else if (score != null) {
      spots.add(FlSpot(14, score));
    }

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
                      'Baselines calibrating. Pull biometrics to compute recovery breakdown.',
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: RecovaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildMetricProgressRow(
                  label: 'HEART RATE VARIABILITY (HRV)',
                  weight: '40% WEIGHT',
                  score: summary?.recoveryComponentHrv,
                  valueText: summary?.hrvMs != null
                      ? '${summary!.hrvMs!.toInt()} ms'
                      : '--',
                  color: RecovaColors.monochromeWhite,
                ),
                const SizedBox(height: 14),
                _buildMetricProgressRow(
                  label: 'RESTING HEART RATE',
                  weight: '30% WEIGHT',
                  score: summary?.recoveryComponentRhr,
                  valueText: summary?.restingHr != null
                      ? '${summary!.restingHr!.toInt()} bpm'
                      : '--',
                  color: RecovaColors.recoveryEmerald,
                ),
                const SizedBox(height: 14),
                _buildMetricProgressRow(
                  label: 'SLEEP DURATION & ARCHITECTURE',
                  weight: '20% WEIGHT',
                  score: summary?.recoveryComponentSleep,
                  valueText: summary?.sleepHours != null
                      ? '${summary!.sleepHours!.toStringAsFixed(1)} hrs'
                      : '--',
                  color: RecovaColors.restorativeAzure,
                ),
                const SizedBox(height: 14),
                _buildMetricProgressRow(
                  label: 'BLOOD OXYGEN & RESPIRATION',
                  weight: '10% WEIGHT',
                  score: summary?.recoveryComponentSpo2,
                  valueText: summary?.spo2 != null
                      ? '${summary!.spo2!.toStringAsFixed(0)}%'
                      : '--',
                  color: RecovaColors.kineticAmberGold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Estimated VO2 Max Card (100% Real Uth-Sørensen) ──
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
                      child: Text(
                        vo2 != null ? 'CALCULATED' : 'AWAITING LOGS',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: vo2 != null
                              ? RecovaColors.recoveryEmerald
                              : RecovaColors.textMuted,
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
                      vo2 != null ? vo2.toStringAsFixed(1) : '--',
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
                    if (vo2 != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: RecovaColors.recoveryEmeraldContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: RecovaColors.recoveryEmeraldBorder),
                        ),
                        child: Text(
                          vo2 >= 50
                              ? 'SUPERIOR TIER'
                              : vo2 >= 42
                                  ? 'EXCELLENT TIER'
                                  : 'STANDARD TIER',
                          style: const TextStyle(
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
                  'Uth–Sørensen Formula: VO₂max ≈ 15.3 × (HRmax / HRrest)\nCalculated directly from resting HR baseline and workout peak HR via Health Connect.',
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

          // ── 14-Day Recovery Trend Chart (100% Real Database History) ──
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
                      '14-DAY RECOVERY TREND',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                    Text(
                      spots.isNotEmpty
                          ? '${spots.length} DAYS RECORDED'
                          : 'CALIBRATING',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: spots.isNotEmpty
                            ? RecovaColors.recoveryEmerald
                            : RecovaColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (spots.isEmpty)
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: const Text(
                      'No recovery history stored yet.\nSync daily with Health Connect to build your 14-day trend.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: RecovaColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  )
                else
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
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: spots.length > 2,
                            color: RecovaColors.monochromeWhite,
                            barWidth: 2.0,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                final isLatest = index == barData.spots.length - 1;
                                return FlDotCirclePainter(
                                  radius: isLatest ? 4 : 2,
                                  color: isLatest
                                      ? RecovaColors.nothingRed
                                      : RecovaColors.monochromeSilver,
                                  strokeColor: Colors.white,
                                  strokeWidth: isLatest ? 1.5 : 0,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.10),
                                  Colors.white.withValues(alpha: 0.0),
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
    required double? score,
    required String valueText,
    required Color color,
  }) {
    final validScore = score != null;
    final percent = (score ?? 0.0) / 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: RecovaColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  weight,
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: RecovaColors.textMuted,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  validScore ? '${score.round()}%' : '--',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: validScore ? color : RecovaColors.textMuted,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  valueText,
                  style: const TextStyle(
                    fontSize: 10,
                    color: RecovaColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 4,
            child: LinearProgressIndicator(
              value: validScore ? percent.clamp(0.0, 1.0) : 0.0,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
