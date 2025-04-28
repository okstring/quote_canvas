enum SettingsKeys {
  isDarkMode,
  enableNotifications,
  notificationTimeHour,
  notificationTimeMinute,
  language,
  isAppFirstLaunch,
  adTriggerCount,
  hasAskedPhotoPermission;

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
      case adTriggerCount:
        return 'settingsAdTriggerCount';
      case hasAskedPhotoPermission:
        return 'hasAskedPhotoPermission';
    }
  }
}
