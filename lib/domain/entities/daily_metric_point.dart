/// A single daily data point for trend charting and analysis.
class DailyMetricPoint {
  final DateTime date;
  final double value;

  const DailyMetricPoint({
    required this.date,
    required this.value,
  });

  @override
  String toString() => 'DailyMetricPoint(date: $date, value: $value)';
}
