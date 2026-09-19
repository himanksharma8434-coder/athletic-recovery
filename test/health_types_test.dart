import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:whoop/core/constants/health_types.dart';

void main() {
  group('HealthTypes Platform Adaptability', () {
    test('Android does not request HEART_RATE_VARIABILITY_SDNN or DISTANCE_WALKING_RUNNING', () {
      if (Platform.isAndroid) {
        expect(
          HealthTypes.platformRequestedTypes,
          isNot(contains(HealthDataType.HEART_RATE_VARIABILITY_SDNN)),
        );
        expect(
          HealthTypes.platformRequestedTypes,
          contains(HealthDataType.HEART_RATE_VARIABILITY_RMSSD),
        );
        expect(
          HealthTypes.platformRequestedTypes,
          isNot(contains(HealthDataType.DISTANCE_WALKING_RUNNING)),
        );
        expect(
          HealthTypes.platformRequestedTypes,
          contains(HealthDataType.DISTANCE_DELTA),
        );
        expect(
          HealthTypes.coreTypes,
          contains(HealthDataType.SLEEP_SESSION),
        );
      }
    });

    test('requestedTypes returns platform-appropriate types without error', () {
      final types = HealthTypes.requestedTypes;
      expect(types, isNotEmpty);
      expect(types, contains(HealthDataType.HEART_RATE));
      expect(types, contains(HealthDataType.RESTING_HEART_RATE));
      expect(types, contains(HealthDataType.BLOOD_OXYGEN));
      expect(types, contains(HealthDataType.STEPS));

      final perms = HealthTypes.permissions;
      expect(perms.length, equals(types.length));
    });
  });
}
