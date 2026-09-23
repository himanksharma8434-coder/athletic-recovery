import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';
import '../components/daily_activity_pod.dart';
import '../components/radial_score_gauge.dart';
import '../components/sleep_performance_card.dart';
import '../components/vital_metric_tile.dart';
import '../cubits/health_sync/health_sync_cubit.dart';
import '../cubits/health_sync/health_sync_state.dart';
import 'recovery_calculation_screen.dart';
import 'resting_hr_detail_screen.dart';
import 'blood_o2_detail_screen.dart';
import 'sleep_architecture_detail_screen.dart';
import 'hrv_detail_screen.dart';

class PulseScreen extends StatelessWidget {
  final DerivedMetricSummary? summary;
  final VoidCallback onSyncTap;

  const PulseScreen({
    super.key,
    required this.summary,
    required this.onSyncTap,
  });

  void _openHrvDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HrvDetailScreen(summary: summary),
      ),
    );
  }

  void _openRecoveryCalculation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecoveryCalculationScreen(summary: summary),
      ),
    );
  }

  void _openRestingHrDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RestingHrDetailScreen(summary: summary),
      ),
    );
  }

  void _openBloodO2Detail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BloodO2DetailScreen(summary: summary),
      ),
    );
  }

  void _openSleepArchitectureDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SleepArchitectureDetailScreen(summary: summary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic RHR delta vs baseline
    String rhrDeltaText = 'Awaiting sync';
    Color rhrDeltaColor = RecovaColors.textMuted;
    if (summary?.restingHr != null && summary?.baselineRestingHr != null) {
      final diff = (summary!.restingHr! - summary!.baselineRestingHr!).round();
      if (diff < 0) {
        rhrDeltaText = '$diff bpm basal';
        rhrDeltaColor = RecovaColors.textSecondary;
      } else if (diff > 0) {
        rhrDeltaText = '+$diff bpm basal';
        rhrDeltaColor = RecovaColors.nothingRed;
      } else {
        rhrDeltaText = 'On baseline';
        rhrDeltaColor = RecovaColors.textSecondary;
      }
    } else if (summary?.restingHr != null) {
      rhrDeltaText = 'Current basal';
      rhrDeltaColor = RecovaColors.textSecondary;
    }

    // Dynamic SpO2 delta / state
    String spo2DeltaText = 'Awaiting sync';
    Color spo2DeltaColor = RecovaColors.textMuted;
    if (summary?.spo2 != null) {
      if (summary!.spo2! >= 95) {
        spo2DeltaText = 'Optimal range';
        spo2DeltaColor = RecovaColors.textSecondary;
      } else {
        spo2DeltaText = 'Elevated desat';
        spo2DeltaColor = RecovaColors.nothingRed;
      }
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Clean Minimalist Top Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today, ${_currentDateFormatted()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      color: RecovaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: summary != null
                              ? RecovaColors.monochromeWhite
                              : RecovaColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        summary != null
                            ? 'Synced with wearable'
                            : 'Awaiting wearable sync',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                          color: RecovaColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Clean Sensor Sync Action Button
              BlocBuilder<HealthSyncCubit, HealthSyncState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: state is HealthSyncing ? null : onSyncTap,
                    style: IconButton.styleFrom(
                      backgroundColor: RecovaColors.surfaceElevation1,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: RecovaColors.borderSubtle),
                      ),
                    ),
                    icon: state is HealthSyncing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: RecovaColors.monochromeWhite,
                            ),
                          )
                        : const Icon(
                            Icons.sensors_outlined,
                            size: 18,
                            color: RecovaColors.monochromeWhite,
                          ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Signature Biometric Recovery Gauge (Clickable to Calculation Page) ──
          RadialScoreGauge(
            score: summary?.recoveryScore,
            size: 210,
            onTap: () => _openRecoveryCalculation(context),
          ),
          const SizedBox(height: 22),

          // ── Quick Vital Metrics ──
          Row(
            children: [
              Expanded(
                child: VitalMetricTile(
                  label: 'HRV (rMSSD)',
                  value: summary?.hrvMs != null
                      ? '${summary!.hrvMs!.toInt()}'
                      : '--',
                  unit: 'ms',
                  deltaText: summary?.hrvMs != null
                      ? 'Within range'
                      : 'Awaiting log',
                  deltaColor: summary?.hrvMs != null
                      ? RecovaColors.textSecondary
                      : RecovaColors.textMuted,
                  icon: Icons.monitor_heart_outlined,
                  onTap: () => _openHrvDetail(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: VitalMetricTile(
                  label: 'RESTING HR',
                  value: summary?.restingHr != null
                      ? '${summary!.restingHr!.toInt()}'
                      : '--',
                  unit: 'bpm',
                  deltaText: rhrDeltaText,
                  deltaColor: rhrDeltaColor,
                  icon: Icons.favorite_border,
                  onTap: () => _openRestingHrDetail(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: VitalMetricTile(
                  label: 'BLOOD O2',
                  value: summary?.spo2 != null
                      ? summary!.spo2!.toStringAsFixed(0)
                      : '--',
                  unit: '%',
                  deltaText: spo2DeltaText,
                  deltaColor: spo2DeltaColor,
                  icon: Icons.air,
                  onTap: () => _openBloodO2Detail(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Full-Width Sleep Architecture Bento (Replaces Split Day Strain Pod) ──
          SleepPerformanceCard(
            sleepHours: summary?.sleepHours,
            baselineSleepHours: summary?.baselineSleepHours,
            sleepStages: summary?.sleepStages,
            sleepSessions: summary?.sleepSessions ?? const [],
            onTap: () => _openSleepArchitectureDetail(context),
          ),
          const SizedBox(height: 14),

          // ── Daily Movement & Energy Expenditure (Replaces ECG Waveform) ──
          DailyActivityPod(
            todaySteps: summary?.todaySteps,
            activeCalories: summary?.activeCalories,
            totalCalories: summary?.totalCalories,
          ),
        ],
      ),
    );
  }

  String _currentDateFormatted() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]} ${now.day}';
  }
}
