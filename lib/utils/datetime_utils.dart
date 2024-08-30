import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTime timestampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static int dateTimeToTimestamp(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  static String dateTimeToString(DateTime dateTime, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  static DateTime stringToDateTime(String dateTimeString, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final formatter = DateFormat(format);
    return formatter.parse(dateTimeString);
  }
}
