import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;

class DateTimeUtil {
  static String toDateString(DateTime date) {
    return DateFormat.yMMMMEEEEd()
        .format(date); // 'Wednesday, January 10, 2012'
  }

  static String toShortDateString(DateTime date) {
    return DateFormat.yMMMMd().format(date); // 'Wednesday, January 10, 2012'
  }

  static String toTimeString(DateTime date) {
    return DateFormat('hh:mm a').format(date); // 'Wednesday, January 10, 2012'
  }

  // static String timeAgo(DateTime date) {
  //   return timeago.format(date);
  // }
}
