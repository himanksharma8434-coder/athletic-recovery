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
    String rhrDeltaText = 'AWAITING SYNC';
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
        rhrDeltaText = 'ON BASELINE';
        rhrDeltaColor = RecovaColors.textSecondary;
      }
    } else if (summary?.restingHr != null) {
      rhrDeltaText = 'CURRENT BASAL';
      rhrDeltaColor = RecovaColors.textSecondary;
    }

    // Dynamic SpO2 delta / state
    String spo2DeltaText = 'AWAITING SYNC';
    Color spo2DeltaColor = RecovaColors.textMuted;
    if (summary?.spo2 != null) {
      if (summary!.spo2! >= 95) {
        spo2DeltaText = 'OPTIMAL RANGE';
        spo2DeltaColor = RecovaColors.textSecondary;
      } else {
        spo2DeltaText = 'ELEVATED DESAT';
        spo2DeltaColor = RecovaColors.nothingRed;
      }
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Top Athlete Telemetry Status Bar ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: RecovaColors.surfaceElevation3,
                      border: Border.all(color: RecovaColors.borderMedium),
                    ),
                    child: const Icon(Icons.bolt,
                        color: RecovaColors.monochromeWhite, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'TODAY',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: RecovaColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ', ${_currentDateFormatted()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: RecovaColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: summary != null
                                  ? RecovaColors.nothingRed
                                  : RecovaColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            summary != null
                                ? 'HEALTH CONNECT • SYNCED'
                                : 'AWAITING WEARABLE SYNC',
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: summary != null
                                  ? RecovaColors.textSecondary
                                  : RecovaColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // Sensor Sync Action Button
              BlocBuilder<HealthSyncCubit, HealthSyncState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: state is HealthSyncing ? null : onSyncTap,
                    style: IconButton.styleFrom(
                      backgroundColor: RecovaColors.surfaceElevation1,
                      shape: const CircleBorder(
                        side: BorderSide(color: RecovaColors.borderSubtle),
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
                            Icons.sensors,
                            size: 18,
                            color: RecovaColors.monochromeWhite,
                          ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Signature Biometric Recovery Gauge (Clickable to Calculation Page) ──
          RadialScoreGauge(
            score: summary?.recoveryScore,
            size: 210,
            onTap: () => _openRecoveryCalculation(context),
          ),
          const SizedBox(height: 20),

          // ── Quick Vital Metrics (100% Real Wearable Sensors & Optical PPG) ──
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
                      ? 'OPTICAL PPG'
                      : 'AWAITING LOG',
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
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${months[now.month - 1]} ${now.day}';
  }
}
