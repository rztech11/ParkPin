import 'package:intl/intl.dart';

class DateFormatter {
  /// Format: '12 Sept 2026 • 2:42 PM'
  static String formatFullDateTime(DateTime dateTime) {
    final dateStr = DateFormat('dd MMM yyyy').format(dateTime);
    final timeStr = DateFormat('h:mm a').format(dateTime);
    return '$dateStr • $timeStr';
  }

  /// Format: '2:42 PM'
  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Format: '12 Sept 2026'
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  /// Timer display format: '01:42' (HH:MM or MM:SS)
  static String formatTimer(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      final hoursStr = hours.toString().padLeft(2, '0');
      final minutesStr = minutes.toString().padLeft(2, '0');
      return '$hoursStr:$minutesStr';
    } else {
      final minutesStr = minutes.toString().padLeft(2, '0');
      final secondsStr = seconds.toString().padLeft(2, '0');
      return '$minutesStr:$secondsStr';
    }
  }

  /// Format for details: '1 hr 42 min' or '25 min'
  static String formatDurationReadable(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '$hours hr $minutes min';
    } else if (hours > 0) {
      return '$hours hr${hours > 1 ? 's' : ''}';
    } else {
      return '${minutes > 0 ? minutes : 1} min';
    }
  }
}
