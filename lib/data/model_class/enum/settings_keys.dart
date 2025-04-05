enum SettingsKeys {
  isDarkMode,
  enableNotifications,
  notificationTimeHour,
  notificationTimeMinute,
  language,
  isAppFirstLaunch;

  String get name {
    switch (this) {
      case isDarkMode:
        return 'settingsIsDarkMode';
      case enableNotifications:
        return 'settingsEnableNotifications';
      case notificationTimeHour:
        return 'settingsNotificationTimeHour';
      case notificationTimeMinute:
        return 'settingsNotificationTimeMinute';
      case language:
        return 'settingsLanguage';
      case isAppFirstLaunch:
        return 'settingsIsAppFirstLaunch';
    }
  }
}

