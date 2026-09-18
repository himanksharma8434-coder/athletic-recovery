/// Result of the recovery score computation.
/// Includes the final composite score plus per-component breakdown
/// so the UI can explain WHY the score is what it is.
class RecoveryResult {
  /// Composite score, 0–100. Higher = better recovered.
  final double score;

  /// Individual component scores, each 0–100.
  final double rhrComponent;
  final double sleepComponent;
  final double spo2Component;

  /// Human-readable explanation of the dominant factor.
  /// e.g. "Resting heart rate is elevated" or "Great recovery across all metrics".
  final String primaryFactor;

  const RecoveryResult({
    required this.score,
    required this.rhrComponent,
    required this.sleepComponent,
    required this.spo2Component,
    required this.primaryFactor,
  });
}

/// Computes a composite recovery score (0–100) from available health signals.
///
/// Because HRV is not available from the wearable, resting HR deviation
/// is weighted most heavily as the strongest proxy signal.
///
/// Weights:
///   - Resting HR: 50%
///   - Sleep:      35%
///   - SpO2:       15%
class ComputeRecoveryScore {
  const ComputeRecoveryScore();

  static const double _weightRhr = 0.50;
  static const double _weightSleep = 0.35;
  static const double _weightSpo2 = 0.15;

  /// Compute the recovery score.
  ///
  /// All baseline parameters are nullable — if a component is missing,
  /// the remaining components are re-weighted proportionally.
  RecoveryResult call({
    double? todayRhr,
    double? rhrBaseline7d,
    double? lastNightSleepMinutes,
    double? sleepBaseline7d,
    double? todaySpo2,
    double? spo2Baseline7d,
  }) {
    double? rhrScore;
    double? sleepScore;
    double? spo2Score;

    // ── RHR Component ──
    // 100 when at or below baseline, degrades linearly as RHR rises.
    // A 20% elevation above baseline → score of 0.
    if (todayRhr != null && rhrBaseline7d != null && rhrBaseline7d > 0) {
      final deviation = (todayRhr - rhrBaseline7d) / rhrBaseline7d;
      // deviation <= 0 → fully recovered (100)
      // deviation >= 0.20 → fully fatigued (0)
      rhrScore = (1.0 - (deviation / 0.20)).clamp(0.0, 1.0) * 100;
    }

    // ── Sleep Component ──
    // 100 when sleep duration >= baseline, degrades as it drops.
    // Sleeping 50% of baseline → score of 0.
    if (lastNightSleepMinutes != null &&
        sleepBaseline7d != null &&
        sleepBaseline7d > 0) {
      final ratio = lastNightSleepMinutes / sleepBaseline7d;
      // ratio >= 1.0 → fully rested (100)
      // ratio <= 0.5 → very poor (0)
      sleepScore = ((ratio - 0.5) / 0.5).clamp(0.0, 1.0) * 100;
    }

    // ── SpO2 Component ──
    // 100 when at/above baseline. Minor penalty for dips.
    // A 5% absolute drop → score of 0.
    if (todaySpo2 != null && spo2Baseline7d != null && spo2Baseline7d > 0) {
      final drop = spo2Baseline7d - todaySpo2; // positive = bad
      // drop <= 0 → normal (100)
      // drop >= 5 → concerning (0)
      spo2Score = (1.0 - (drop / 5.0)).clamp(0.0, 1.0) * 100;
    }

    // ── Weighted composite ──
    final components = <_Weighted>[];
    if (rhrScore != null) {
      components.add(_Weighted(_weightRhr, rhrScore));
    }
    if (sleepScore != null) {
      components.add(_Weighted(_weightSleep, sleepScore));
    }
    if (spo2Score != null) {
      components.add(_Weighted(_weightSpo2, spo2Score));
    }

    double finalScore;
    if (components.isEmpty) {
      finalScore = 50; // default neutral when no data
    } else {
      final totalWeight = components.fold(0.0, (sum, c) => sum + c.weight);
      finalScore =
          components.fold(0.0, (sum, c) => sum + c.weight * c.score) /
              totalWeight;
    }

    // Determine the primary factor
    final primaryFactor = _determinePrimaryFactor(
      rhrScore: rhrScore,
      sleepScore: sleepScore,
      spo2Score: spo2Score,
      finalScore: finalScore,
    );

    return RecoveryResult(
      score: finalScore.roundToDouble(),
      rhrComponent: (rhrScore ?? 50).roundToDouble(),
      sleepComponent: (sleepScore ?? 50).roundToDouble(),
      spo2Component: (spo2Score ?? 50).roundToDouble(),
      primaryFactor: primaryFactor,
    );
  }

  String _determinePrimaryFactor({
    double? rhrScore,
    double? sleepScore,
    double? spo2Score,
    required double finalScore,
  }) {
    if (finalScore >= 80) {
      return 'Great recovery across all metrics';
    }

    // Find the lowest scoring component
    final scores = <String, double>{
      'rhr': ?rhrScore,
      'sleep': ?sleepScore,
      'spo2': ?spo2Score,
    };

    if (scores.isEmpty) return 'Insufficient data for detailed analysis';

    final worstKey = scores.entries.reduce((a, b) => a.value < b.value ? a : b);

    return switch (worstKey.key) {
      'rhr' => 'Resting heart rate is elevated',
      'sleep' => 'Sleep duration was below baseline',
      'spo2' => 'Blood oxygen is lower than usual',
      _ => 'Recovery is below optimal',
    };
  }
}

class _Weighted {
  final double weight;
  final double score;
  const _Weighted(this.weight, this.score);
}
