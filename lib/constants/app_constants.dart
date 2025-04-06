// lib/config/constants/app_constants.dart

class AppConstants {
  // App info
  static const String appName = 'Workout Tracker';
  static const String appVersion = '1.0.0';
  
  // Database box names
  static const String exercisesBoxName = 'exercises';
  static const String workoutsBoxName = 'workouts';
  static const String settingsBoxName = 'settings';
  
  // Default settings
  static const String defaultLanguage = 'en';
  static const String defaultWeightUnit = 'kg';
  static const bool defaultDarkMode = false;
  
  // Notification channels
  static const String notificationChannelId = 'workout_reminder_channel';
  static const String notificationChannelName = 'Workout Reminders';
  static const String notificationChannelDescription = 'Notifications for workout reminders';
  
  // Time formats
  static const String timeFormat24h = 'HH:mm';
  static const String timeFormat12h = 'h:mm a';
  
  // Date formats
  static const String dateFormatFull = 'EEEE, MMMM d, y';
  static const String dateFormatShort = 'MMM d, y';
  
  // Muscle groups
  static const List<String> muscleGroups = [
    'Chest',
    'Back',
    'Shoulders',
    'Arms',
    'Legs',
    'Core',
    'Cardio',
    'Full Body',
  ];
}
