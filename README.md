# Recova — Athletic Recovery Tracker

A Flutter application that reads wearable health data via Android Health Connect (and iOS HealthKit), persists it offline-first using Drift, and computes derived fitness metrics.

## Architecture

Clean Architecture with Cubit/BLoC state management:

```
lib/
├── core/          # Constants, error types, utilities
├── data/          # Database (Drift), datasources, repository impl
├── domain/        # Entities, repository interface, use cases
├── presentation/  # Cubits (state management) and screens
└── services/      # Background sync (workmanager)
```

## Health Data Availability Constraints

The Nothing X / CMF Watch surfaces the following via Health Connect. **HRV, VO2max, stress, and recovery scores are NOT provided by the wearable** and must be computed locally.

| Data Type | Available | Source |
|-----------|-----------|--------|
| Heart Rate | ✅ | Health Connect / HealthKit |
| Resting Heart Rate | ✅ | Health Connect / HealthKit |
| Sleep Sessions | ✅ | Health Connect / HealthKit |
| SpO2 (Blood Oxygen) | ✅ | Health Connect / HealthKit |
| Steps | ✅ | Health Connect / HealthKit |
| Exercise Sessions | ✅ | Health Connect / HealthKit |
| Total Calories Burned | ✅ | Health Connect / HealthKit |
| HRV | ❌ | Not exposed by this wearable |
| VO2 max | ❌ | Computed locally (estimate) |
| Recovery Score | ❌ | Computed locally (composite) |
| Stress | ❌ | Not available |

## Derived Metrics

### Estimated VO2 Max
```
VO2max ≈ 15.3 × (HRmax / HRrest)
```
- **HRrest**: 7-day rolling median of daily minimum resting HR
- **HRmax**: Highest HR during exercise sessions (last 60 days), or age-predicted fallback (220 − age)
- ⚠️ This is an **estimate**, not a clinical measurement

### Recovery Score (0–100)
Composite of three components since HRV is unavailable:
- **Resting HR** (50% weight): Deviation from 7-day baseline
- **Sleep** (35% weight): Duration vs. 7-day baseline
- **SpO2** (15% weight): Level vs. 7-day baseline

## Sync Mechanism

There is **no push/webhook** from Health Connect to third-party apps. Sync is implemented as:

1. **Background polling**: `workmanager` periodic task (minimum 15-minute intervals on Android)
2. **Manual sync**: "Sync Now" button in the dashboard
3. **Delta-only**: Each sync only queries records since `lastSyncedAt` per data type
4. **Graceful degradation**: Background-read permission (Android 14+) is optional; falls back to foreground-only sync on older devices

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Testing

```bash
flutter test
flutter analyze
```
