class DateTimeUtils {
  static DateTime timestampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static int dateTimeToTimestamp(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }
}
