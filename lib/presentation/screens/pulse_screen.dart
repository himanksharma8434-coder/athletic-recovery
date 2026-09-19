import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/recova_colors.dart';
import '../../domain/repositories/health_source_repository.dart';
import '../components/bento_telemetry_pods.dart';
import '../components/coach_insight_card.dart';
import '../components/ecg_waveform_card.dart';
import '../components/radial_score_gauge.dart';
import '../components/vital_metric_tile.dart';
import '../cubits/health_sync/health_sync_cubit.dart';
import '../cubits/health_sync/health_sync_state.dart';

class PulseScreen extends StatelessWidget {
  final DerivedMetricSummary? summary;
  final VoidCallback onSyncTap;

  const PulseScreen({
    super.key,
    required this.summary,
    required this.onSyncTap,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic RHR delta vs baseline
    String rhrDeltaText = 'AWAITING SYNC';
    Color rhrDeltaColor = RecovaColors.textMuted;
    if (summary?.restingHr != null && summary?.baselineRestingHr != null) {
      final diff = (summary!.restingHr! - summary!.baselineRestingHr!).round();
      if (diff < 0) {
        rhrDeltaText = '$diff bpm basal';
        rhrDeltaColor = RecovaColors.recoveryEmerald;
      } else if (diff > 0) {
        rhrDeltaText = '+$diff bpm basal';
        rhrDeltaColor = RecovaColors.stressCrimson;
      } else {
        rhrDeltaText = 'ON BASELINE';
        rhrDeltaColor = RecovaColors.recoveryEmerald;
      }
    } else if (summary?.restingHr != null) {
      rhrDeltaText = 'CURRENT BASAL';
      rhrDeltaColor = RecovaColors.recoveryEmerald;
    }

    // Dynamic SpO2 delta / state
    String spo2DeltaText = 'AWAITING SYNC';
    Color spo2DeltaColor = RecovaColors.textMuted;
    if (summary?.spo2 != null) {
      if (summary!.spo2! >= 95) {
        spo2DeltaText = 'OPTIMAL RANGE';
        spo2DeltaColor = RecovaColors.recoveryEmerald;
      } else {
        spo2DeltaText = 'ELEVATED DESAT';
        spo2DeltaColor = RecovaColors.kineticAmberGold;
      }
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Top Athlete Telemetry Status ──
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
                        color: RecovaColors.recoveryEmerald, size: 18),
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
                                  ? RecovaColors.recoveryEmerald
                                  : RecovaColors.kineticAmberGold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            summary != null
                                ? 'HEALTH CONNECT • SYNCED'
                                : 'AWAITING WEARABLE SYNC',
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: summary != null
                                  ? RecovaColors.recoveryEmerald
                                  : RecovaColors.kineticAmberGold,
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
                              color: RecovaColors.recoveryEmerald,
                            ),
                          )
                        : const Icon(
                            Icons.sensors,
                            size: 18,
                            color: RecovaColors.recoveryEmerald,
                          ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Signature Biometric Recovery Gauge ──
          RadialScoreGauge(
            score: summary?.recoveryScore,
            size: 210,
          ),
          const SizedBox(height: 20),

          // ── 3-Column Quick Vital Metrics (100% Real Sensor Data) ──
          Row(
            children: [
              Expanded(
                child: VitalMetricTile(
                  label: Platform.isAndroid ? 'HRV (RMSSD)' : 'HRV (SDNN)',
                  value: summary?.hrvMs != null
                      ? '${summary!.hrvMs!.toInt()}'
                      : '--',
                  unit: 'ms',
                  deltaText: summary?.hrvMs != null
                      ? 'REAL SENSOR'
                      : 'NO SENSOR LOG',
                  deltaColor: summary?.hrvMs != null
                      ? RecovaColors.recoveryEmerald
                      : RecovaColors.textMuted,
                  icon: Icons.monitor_heart_outlined,
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── AI Daily Coach Insight Card ──
          CoachInsightCard(
            recoveryScore: summary?.recoveryScore,
            primaryFactor: summary?.primaryFactor,
          ),
          const SizedBox(height: 14),

          // ── Bento Dual Pods: Strain + Sleep ──
          BentoTelemetryPods(
            dayStrain: summary?.dayStrain,
            sleepHours: summary?.sleepHours,
            baselineSleepHours: summary?.baselineSleepHours,
            sleepStages: summary?.sleepStages,
          ),
          const SizedBox(height: 14),

          // ── Real-Time Vascular Telemetry ──
          EcgWaveformCard(
            restingHr: summary?.restingHr,
          ),
          const SizedBox(height: 16),

          // ── Sync Action CTA ──
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: onSyncTap,
              style: OutlinedButton.styleFrom(
                backgroundColor: RecovaColors.surfaceElevation1,
                side: const BorderSide(color: RecovaColors.borderMedium),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: RecovaColors.recoveryEmerald,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'PULL WEARABLE BIOMETRICS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: RecovaColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
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
