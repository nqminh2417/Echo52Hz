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

// check this
  static DateTime stringToDateTime(String dateTimeString, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    try {
      final formatter = DateFormat(format);
      return formatter.parse(dateTimeString);
    } on FormatException catch (e) {
      // Handle the exception, e.g., log the error, display an error message, or return a default value.
      print('Error parsing date: $e');
      return DateTime.now(); // Or handle the error differently
    }
  }
}
