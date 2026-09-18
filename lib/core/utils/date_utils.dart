/// Date/time helpers for trailing-window computations.
class AppDateUtils {
  AppDateUtils._();

  /// Returns midnight (start of day) for the given [dateTime].
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Returns the start of day N days ago from [now].
  static DateTime daysAgo(int days, {DateTime? from}) {
    final ref = from ?? DateTime.now();
    return startOfDay(ref.subtract(Duration(days: days)));
  }

  /// Returns a list of dates from [start] to [end] inclusive.
  static List<DateTime> dateRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = startOfDay(start);
    final endDay = startOfDay(end);
    while (!current.isAfter(endDay)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }
    return dates;
  }
}
