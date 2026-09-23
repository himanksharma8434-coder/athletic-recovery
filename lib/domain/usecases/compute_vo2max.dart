/// Estimates VO2 max using the Uth–Sørensen–Overgaard–Pedersen formula:
///
///   VO2max ≈ 15.3 × (HRmax / HRrest)
///
/// - [restingHr7dBaseline]: rolling 7-day median of daily minimum resting HR.
///   NOT a single instantaneous low.
/// - [maxHrFromExercise]: highest HR observed during an ExerciseSession in the
///   last 30–60 days. Nullable — may not exist if the user hasn't exercised.
/// - [userAge]: used only for the fallback formula (220 − age) when no
///   exercise data is available. Nullable — if unavailable, and there's no
///   exercise data, VO2max simply cannot be computed.
///
/// ⚠️ This is an ESTIMATE. It should be visually/textually flagged as such
/// in any UI that displays it.
class ComputeVo2Max {
  const ComputeVo2Max();

  /// Returns the estimated VO2 max, or null if insufficient data.
  double? call({
    required double? restingHr7dBaseline,
    required double? maxHrFromExercise,
    int? userAge,
  }) {
    final hrRest = restingHr7dBaseline;
    if (hrRest == null || hrRest <= 0) return null;

    double hrMax;
    if (maxHrFromExercise != null && maxHrFromExercise > 0) {
      hrMax = maxHrFromExercise;
    } else if (userAge != null && userAge > 0 && userAge < 120) {
      hrMax = 220.0 - userAge;
    } else {
      return null; // Cannot compute without HRmax or age
    }

    // Guard against unreasonable ratios
    if (hrMax <= hrRest) return null;

    final vo2 = 15.3 * (hrMax / hrRest);
    if (vo2 < 15.0 || vo2 > 85.0) return null;

    return vo2;
  }
}

