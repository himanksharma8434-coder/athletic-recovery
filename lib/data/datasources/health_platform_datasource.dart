import 'dart:io';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/health_types.dart';
import '../../domain/entities/health_record.dart';

/// Wraps the `health` package. This is the ONLY place in the codebase
/// that imports `package:health/health.dart` directly.
class HealthPlatformDatasource {
  Health? _health;

  Health get health => _health ??= Health();

  /// Configure the health plugin. Must be called before any other method.
  Future<void> configure() async {
    await health.configure();
  }

  /// Request read authorization for all configured data types.
  Future<bool> requestPermissions() async {
    await configure();
    try {
      await health.requestAuthorization(
        HealthTypes.requestedTypes,
        permissions: HealthTypes.permissions,
      );
    } catch (_) {
      try {
        await health.requestAuthorization(
          HealthTypes.coreTypes,
          permissions: HealthTypes.corePermissions,
        );
      } catch (_) {}
    }

    return await hasPermissions();
  }

  /// Check whether we have permission to read health data.
  Future<bool> hasPermissions() async {
    try {
      // 1. Check if core types are granted
      final coreResult = await health.hasPermissions(
        HealthTypes.coreTypes,
        permissions: HealthTypes.corePermissions,
      );
      if (coreResult == true) return true;

      // 2. Check individual key types
      for (final type in [
        HealthDataType.HEART_RATE,
        HealthDataType.STEPS,
        HealthDataType.SLEEP_SESSION,
        HealthDataType.RESTING_HEART_RATE,
      ]) {
        final granted = await health.hasPermissions(
          [type],
          permissions: [HealthDataAccess.READ],
        );
        if (granted == true) return true;
      }
    } catch (_) {}
    return false;
  }

  /// Check and request background-read permission (Android 14+ only).
  /// On iOS or older Android, returns false without error.
  Future<bool> requestBackgroundReadPermission() async {
    if (!Platform.isAndroid) return false;
    try {
      // Store the result in shared preferences for the background worker
      final granted = await health.requestAuthorization(
        HealthTypes.requestedTypes,
        permissions: HealthTypes.permissions,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('backgroundReadGranted', granted);
      return granted;
    } catch (_) {
      return false;
    }
  }

  /// Check if background read was previously granted.
  Future<bool> hasBackgroundReadPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('backgroundReadGranted') ?? false;
  }

  /// Fetch health data from the platform store for a given time window.
  Future<List<HealthRecord>> fetchRecords({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final dataPoints = await health.getHealthDataFromTypes(
      types: HealthTypes.requestedTypes,
      startTime: startTime,
      endTime: endTime,
    );

    // Remove duplicates from the health package
    final unique = health.removeDuplicates(dataPoints);

    return unique.map(_toHealthRecord).toList();
  }

  /// Convert a platform HealthDataPoint to our domain entity.
  HealthRecord _toHealthRecord(HealthDataPoint point) {
    double value;
    double? valueSecondary;

    // Extract numeric value based on the data point type
    final numValue = point.value;
    if (numValue is NumericHealthValue) {
      value = numValue.numericValue.toDouble();
    } else if (numValue is ElectrocardiogramHealthValue) {
      value = numValue.voltageValues.length.toDouble();
    } else {
      // For workout/sleep sessions, use duration in minutes
      value = point.dateTo.difference(point.dateFrom).inMinutes.toDouble();
    }

    return HealthRecord(
      recordType: point.type.name,
      value: value,
      valueSecondary: valueSecondary,
      unit: point.unit.name,
      startTime: point.dateFrom,
      endTime: point.dateTo,
      sourceId: point.sourceName,
      syncedAt: DateTime.now(),
    );
  }

  /// Attempts to fetch the user's date of birth from the platform health store.
  /// Used for age-based HRmax fallback without asking the user manually.
  Future<DateTime?> fetchDateOfBirth() async {
    try {
      final records = await health.getHealthDataFromTypes(
        types: [HealthDataType.BIRTH_DATE],
        startTime: DateTime(1900),
        endTime: DateTime.now(),
      );
      if (records.isNotEmpty) {
        return records.first.dateFrom;
      }
    } catch (_) {
      // Platform doesn't support reading birth date directly
    }
    return null;
  }
}
