import 'package:intl/intl.dart';

class Formatters {
  // Format date to readable string
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  // Format time to readable string
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
  
  // Format duration in seconds to readable string (e.g., "1h 25m")
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
  
  // Format weight with unit
  static String formatWeight(double weight, String unit) {
    return '$weight $unit';
  }
  
  // Format percentage
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
}
