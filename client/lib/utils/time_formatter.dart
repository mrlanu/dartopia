import 'package:intl/intl.dart';

class FormatUtil {
  FormatUtil._();

  static String formatTime(int timeSeconds) {
    // Calculate hours, minutes, and seconds
    int hours = (timeSeconds ~/ 3600);
    int minutes = (timeSeconds % 3600) ~/ 60;
    int seconds = timeSeconds % 60;

    // Convert to strings and add leading zeros if necessary
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    // Format the time in HH:MM:SS format
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  static String formatDateDifference(DateTime startDate, DateTime endDate) {
    Duration difference = startDate.difference(endDate);
    String formattedDifference = DateFormat('HH:mm:ss').format(
      DateTime(0, 1, 1, difference.inHours, difference.inMinutes % 60, difference.inSeconds % 60),
    );
    return formattedDifference;
  }

}
