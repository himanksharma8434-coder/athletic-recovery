import 'dart:math';
import '../../data/database/app_database.dart';

/// Clean, deduplicated overnight sleep metrics.
class CleanNightSleep {
  final int deepMinutes;
  final int coreMinutes; // Light sleep
  final int remMinutes;
  final int awakeMinutes;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool hasStageData;
  final double totalHours;

  const CleanNightSleep({
    required this.deepMinutes,
    required this.coreMinutes,
    required this.remMinutes,
    required this.awakeMinutes,
    this.startTime,
    this.endTime,
    required this.hasStageData,
    required this.totalHours,
  });

  int get totalAsleepMinutes => deepMinutes + coreMinutes + remMinutes;
  int get totalTrackedMinutes => totalAsleepMinutes + awakeMinutes;
}

class SleepDataSanitizer {
  SleepDataSanitizer._();

  /// Merge overlapping or duplicate time intervals for the same sleep stage.
  /// This prevents double-counting when multiple apps report to Health Connect.
  static int calculateMergedMinutes(List<RawHealthRecord> records) {
    if (records.isEmpty) return 0;

    // Convert to sorted intervals
    final intervals = records
        .map((r) => (
              start: r.startTime,
              end: r.endTime.isAfter(r.startTime)
                  ? r.endTime
                  : r.startTime.add(Duration(minutes: max(1, r.value.round()))),
            ))
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    int totalMinutes = 0;
    DateTime? currentStart;
    DateTime? currentEnd;

    for (final interval in intervals) {
      if (currentStart == null) {
        currentStart = interval.start;
        currentEnd = interval.end;
      } else if (interval.start.isBefore(currentEnd!) ||
          interval.start.isAtSameMomentAs(currentEnd)) {
        // Overlapping or adjacent interval — extend current span
        if (interval.end.isAfter(currentEnd)) {
          currentEnd = interval.end;
        }
      } else {
        // Gap reached — commit previous interval
        totalMinutes += currentEnd.difference(currentStart).inMinutes.abs();
        currentStart = interval.start;
        currentEnd = interval.end;
      }
    }

    if (currentStart != null && currentEnd != null) {
      totalMinutes += currentEnd.difference(currentStart).inMinutes.abs();
    }

    return totalMinutes;
  }

  /// Extracts clean, deduplicated sleep stages for a specific overnight sleep.
  /// Filters out duplicate records across multiple sync sources (e.g. Nothing + Google Fit).
  static CleanNightSleep sanitizeOvernightStages({
    required List<RawHealthRecord> stageRecords,
    RawHealthRecord? sessionRecord,
    double? fallbackHours,
  }) {
    if (stageRecords.isEmpty && sessionRecord == null) {
      final h = fallbackHours ?? 6.0;
      final totalM = (h * 60).round();
      final deep = (totalM * 0.222).round();
      final rem = (totalM * 0.236).round();
      final core = max(30, totalM - deep - rem);
      return CleanNightSleep(
        deepMinutes: deep,
        coreMinutes: core,
        remMinutes: rem,
        awakeMinutes: 18,
        hasStageData: false,
        totalHours: h,
      );
    }

    // 1. Group records by source
    final bySource = <String, List<RawHealthRecord>>{};
    for (final r in stageRecords) {
      bySource.putIfAbsent(r.sourceId, () => []).add(r);
    }

    // Pick preferred wearable source if multiple exist to avoid double-counting
    List<RawHealthRecord> activeStageRecords = stageRecords;
    if (bySource.length > 1) {
      String? bestSource;
      for (final src in bySource.keys) {
        final lower = src.toLowerCase();
        if (lower.contains('nothing') ||
            lower.contains('cmf') ||
            lower.contains('watch') ||
            lower.contains('wearable') ||
            lower.contains('health')) {
          bestSource = src;
          break;
        }
      }
      bestSource ??= bySource.entries
          .reduce((a, b) => a.value.length >= b.value.length ? a : b)
          .key;
      activeStageRecords = bySource[bestSource] ?? stageRecords;
    }

    // 2. Calculate non-overlapping minutes per stage
    final deepRecs = activeStageRecords
        .where((r) => r.recordType == 'SLEEP_DEEP')
        .toList();
    final lightRecs = activeStageRecords
        .where((r) => r.recordType == 'SLEEP_LIGHT')
        .toList();
    final remRecs =
        activeStageRecords.where((r) => r.recordType == 'SLEEP_REM').toList();
    final awakeRecs = activeStageRecords
        .where((r) => r.recordType == 'SLEEP_AWAKE')
        .toList();

    int deep = calculateMergedMinutes(deepRecs);
    int core = calculateMergedMinutes(lightRecs);
    int rem = calculateMergedMinutes(remRecs);
    int awake = calculateMergedMinutes(awakeRecs);

    final hasStages = (deep + core + rem) > 0;

    // 3. Bound checking against session duration if available
    DateTime? minStart;
    DateTime? maxEnd;
    if (sessionRecord != null) {
      minStart = sessionRecord.startTime;
      maxEnd = sessionRecord.endTime;
    } else if (activeStageRecords.isNotEmpty) {
      minStart = activeStageRecords
          .map((r) => r.startTime)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      maxEnd = activeStageRecords
          .map((r) => r.endTime)
          .reduce((a, b) => a.isAfter(b) ? a : b);
    }

    int totalAsleep = deep + core + rem;
    if (!hasStages && sessionRecord != null) {
      // No stages, only session record
      final sessionM =
          sessionRecord.endTime.difference(sessionRecord.startTime).inMinutes.abs();
      totalAsleep = sessionM > 0 ? sessionM : sessionRecord.value.round();
      // Bound to realistic max 12h
      totalAsleep = totalAsleep.clamp(60, 720);
      deep = (totalAsleep * 0.222).round();
      rem = (totalAsleep * 0.236).round();
      core = max(30, totalAsleep - deep - rem);
      awake = 18;
    } else if (hasStages && minStart != null && maxEnd != null) {
      // Check that total stage minutes don't exceed the physical elapsed night duration
      final elapsedM = maxEnd.difference(minStart).inMinutes.abs();
      if (elapsedM > 0 && (totalAsleep + awake) > elapsedM) {
        final scale = elapsedM / (totalAsleep + awake);
        deep = (deep * scale).round();
        core = (core * scale).round();
        rem = (rem * scale).round();
        awake = (awake * scale).round();
        totalAsleep = deep + core + rem;
      }
    }

    // Clamp sleep to maximum 12 hours for a single night
    if (totalAsleep > 720) {
      final scale = 720.0 / totalAsleep;
      deep = (deep * scale).round();
      core = (core * scale).round();
      rem = (rem * scale).round();
      awake = (awake * scale).round();
      totalAsleep = deep + core + rem;
    }

    final double totalHours = totalAsleep / 60.0;

    return CleanNightSleep(
      deepMinutes: deep,
      coreMinutes: core,
      remMinutes: rem,
      awakeMinutes: awake,
      startTime: minStart,
      endTime: maxEnd,
      hasStageData: hasStages,
      totalHours: totalHours,
    );
  }
}
