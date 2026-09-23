import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/recova_colors.dart';
import '../../data/database/app_database.dart';
import '../../domain/repositories/health_source_repository.dart';

/// VO2 Max time-period options for averaging.
enum Vo2Period {
  sevenDays('7D', 7),
  thirtyDays('30D', 30),
  allTime('ALL', 0);

  final String label;
  final int days;
  const Vo2Period(this.label, this.days);
}

class RecoveryDeepDiveScreen extends StatefulWidget {
  final DerivedMetricSummary? summary;

  const RecoveryDeepDiveScreen({
    super.key,
    required this.summary,
  });

  @override
  State<RecoveryDeepDiveScreen> createState() => _RecoveryDeepDiveScreenState();
}

class _RecoveryDeepDiveScreenState extends State<RecoveryDeepDiveScreen> {
  Vo2Period _selectedPeriod = Vo2Period.sevenDays;
  double? _averageVo2;
  bool _loadingAverage = false;

  @override
  void initState() {
    super.initState();
    _loadVo2Average();
  }

  Future<void> _loadVo2Average() async {
    setState(() => _loadingAverage = true);
    try {
      final dao = AppDatabase.instance.derivedMetricDao;
      double? avg;
      if (_selectedPeriod == Vo2Period.allTime) {
        avg = await dao.getAllTimeAverageVo2Max();
      } else {
        avg = await dao.getAverageVo2Max(_selectedPeriod.days);
      }
      if (mounted) {
        setState(() {
          _averageVo2 = avg;
          _loadingAverage = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingAverage = false);
    }
  }

  void _onPeriodChanged(Vo2Period period) {
    setState(() => _selectedPeriod = period);
    _loadVo2Average();
  }

  void _showVo2Explainer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: RecovaColors.surfaceElevation1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => const _Vo2ExplainerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = widget.summary?.recoveryScore;
    final tier = RecoveryTier.fromScore(score);
    final vo2 = widget.summary?.estimatedVo2Max;

    // Convert real 14-day database history to chart spots
    final history = widget.summary?.recoveryHistory14d ?? [];
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

          // ── Estimated VO₂ Max Card ──
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
                // Title row
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
                    GestureDetector(
                      onTap: _showVo2Explainer,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: RecovaColors.surfaceElevation3,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: RecovaColors.borderSubtle),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.info_outline,
                                size: 11, color: RecovaColors.textTertiary),
                            SizedBox(width: 4),
                            Text(
                              'HOW IT WORKS',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: RecovaColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Current VO2 value
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      vo2 != null ? vo2.toStringAsFixed(1) : '--',
                      style: const TextStyle(
                        fontSize: 36,
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
                              ? 'SUPERIOR'
                              : vo2 >= 42
                                  ? 'EXCELLENT'
                                  : vo2 >= 35
                                      ? 'GOOD'
                                      : 'FAIR',
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
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── VO₂ Average Period Selector ──
          Container(
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
                    const Text(
                      'AVERAGE VO₂ MAX',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: RecovaColors.textTertiary,
                      ),
                    ),
                    // Period pills
                    Row(
                      children: Vo2Period.values.map((p) {
                        final isSelected = p == _selectedPeriod;
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: GestureDetector(
                            onTap: () => _onPeriodChanged(p),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? RecovaColors.monochromeWhite
                                    : RecovaColors.surfaceElevation3,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? RecovaColors.monochromeWhite
                                      : RecovaColors.borderSubtle,
                                ),
                              ),
                              child: Text(
                                p.label,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: isSelected
                                      ? RecovaColors.canvasBase
                                      : RecovaColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Average value display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (_loadingAverage)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: RecovaColors.monochromeWhite,
                        ),
                      )
                    else
                      Text(
                        _averageVo2 != null
                            ? _averageVo2!.toStringAsFixed(1)
                            : '--',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.5,
                          color: RecovaColors.textPrimary,
                        ),
                      ),
                    const SizedBox(width: 6),
                    Text(
                      'mL/kg/min avg',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: RecovaColors.textTertiary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedPeriod == Vo2Period.allTime
                      ? 'Averaged across all recorded data'
                      : 'Averaged over the last ${_selectedPeriod.days} days',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: RecovaColors.textMuted,
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
                          ? '${spots.length} DAYS'
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
                      'No recovery history yet.\nSync daily to build your trend.',
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
                              interval: 7,
                              getTitlesWidget: (value, meta) {
                                if (value == 0) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text('14d',
                                        style: TextStyle(
                                            fontSize: 8.5,
                                            color: RecovaColors.textMuted)),
                                  );
                                } else if (value == 7) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text('7d',
                                        style: TextStyle(
                                            fontSize: 8.5,
                                            color: RecovaColors.textMuted)),
                                  );
                                } else if (value == 14) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text('Today',
                                        style: TextStyle(
                                            fontSize: 8.5,
                                            color: RecovaColors.textMuted)),
                                  );
                                }
                                return const SizedBox.shrink();
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
                                final isLatest =
                                    index == barData.spots.length - 1;
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
}

/// Bottom sheet explaining how VO₂ Max is calculated.
class _Vo2ExplainerSheet extends StatelessWidget {
  const _Vo2ExplainerSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: RecovaColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Row(
            children: const [
              Icon(Icons.science_outlined,
                  size: 18, color: RecovaColors.recoveryEmerald),
              SizedBox(width: 8),
              Text(
                'HOW VO₂ MAX IS CALCULATED',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: RecovaColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Formula card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Uth–Sørensen–Overgaard–Pedersen Formula',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: RecovaColors.textTertiary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'VO₂max ≈ 15.3 × (HRmax ÷ HRrest)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                    color: RecovaColors.monochromeWhite,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Data sources
          _explainerRow(
            icon: Icons.favorite_border,
            title: 'HRrest — Resting Heart Rate',
            description:
                'Rolling 7-day median of your daily minimum resting heart rate, measured by your wearable during sleep or rest.',
          ),
          const SizedBox(height: 12),
          _explainerRow(
            icon: Icons.directions_run,
            title: 'HRmax — Maximum Heart Rate',
            description:
                'Highest heart rate recorded during an exercise session in the last 60 days via Health Connect.',
          ),
          const SizedBox(height: 12),
          _explainerRow(
            icon: Icons.cake_outlined,
            title: 'Age Fallback',
            description:
                'If no exercise data is available, HRmax is estimated as 220 − age using your date of birth from Health Connect.',
          ),
          const SizedBox(height: 16),

          // Disclaimer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: RecovaColors.surfaceElevation2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.info_outline,
                    size: 14, color: RecovaColors.textMuted),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This is an estimate derived from heart rate data. It is not a clinical VO₂ max test. Values may vary from lab-measured results.',
                    style: TextStyle(
                      fontSize: 10.5,
                      height: 1.45,
                      color: RecovaColors.textMuted,
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

  static Widget _explainerRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: RecovaColors.surfaceElevation3,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: RecovaColors.monochromeWhite),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: RecovaColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 10.5,
                  height: 1.4,
                  color: RecovaColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
