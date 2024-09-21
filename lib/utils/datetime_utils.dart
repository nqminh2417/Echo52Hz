import 'package:intl/intl.dart';

import 'string_utils.dart';

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

  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }

    try {
      return stringToDateTime(dateString);
    } catch (e) {
      // Handle the error, e.g., log the error or throw a custom exception
      StringUtils.debugLog('Error parsing date: $e');
      return null;
    }
  }
}
