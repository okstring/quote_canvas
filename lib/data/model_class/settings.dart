import 'package:flutter/material.dart';
import 'package:quote_canvas/data/model_class/enum/quote_language.dart';

class Settings {
  final bool isDarkMode;
  final bool enableNotifications;
  final TimeOfDay? notificationTime;
  final QuoteLanguage language;
  final bool isAppFirstLaunch;

  const Settings({
    this.isDarkMode = false,
    this.enableNotifications = true,
    this.notificationTime,
    this.language = QuoteLanguage.english,
    this.isAppFirstLaunch = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    final languageCode = json['language'] ?? 'en';

    return Settings(
      isDarkMode: json['is_dark_mode'] ?? false,
      enableNotifications: json['enable_notifications'] ?? true,
      notificationTime:
          json['notification_time'] != null
              ? TimeOfDay(
                hour: json['notification_time']['hour'] ?? 8,
                minute: json['notification_time']['minute'] ?? 0,
              )
              : null,
      language: QuoteLanguage.fromCode(languageCode),
      isAppFirstLaunch: json['is_app_first_launch'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_dark_mode': isDarkMode,
      'enable_notifications': enableNotifications,
      'notification_time':
          notificationTime != null
              ? {
                'hour': notificationTime!.hour,
                'minute': notificationTime!.minute,
              }
              : null,
      'language': language.code,
      'is_app_first_launch': isAppFirstLaunch,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    final languageCode = map['language'] ?? 'en';

    return Settings(
      isDarkMode: map['is_dark_mode'] == 1,
      enableNotifications: map['enable_notifications'] == 1,
      notificationTime:
          map['notification_time_hour'] != null &&
                  map['notification_time_minute'] != null
              ? TimeOfDay(
                hour: map['notification_time_hour'],
                minute: map['notification_time_minute'],
              )
              : null,
      language: QuoteLanguage.fromCode(languageCode),
      isAppFirstLaunch: map['is_app_first_launch'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'is_dark_mode': isDarkMode ? 1 : 0,
      'enable_notifications': enableNotifications ? 1 : 0,
      'notification_time_hour': notificationTime?.hour,
      'notification_time_minute': notificationTime?.minute,
      'language': language.code,
      'is_app_first_launch': isAppFirstLaunch ? 1 : 0,
    };
  }

  Settings copyWith({
    bool? isDarkMode,
    bool? enableNotifications,
    TimeOfDay? notificationTime,
    QuoteLanguage? language,
    bool? isAppFirstLaunch,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notificationTime: notificationTime ?? this.notificationTime,
      language: language ?? this.language,
      isAppFirstLaunch: isAppFirstLaunch ?? this.isAppFirstLaunch,
    );
  }

  @override
  String toString() {
    return 'Settings{isDarkMode: $isDarkMode, enableNotifications: $enableNotifications, notificationTime: $notificationTime, language: $language, isAppFirstLaunch: $isAppFirstLaunch}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          runtimeType == other.runtimeType &&
          isDarkMode == other.isDarkMode &&
          enableNotifications == other.enableNotifications &&
          notificationTime == other.notificationTime &&
          language == other.language &&
          isAppFirstLaunch == other.isAppFirstLaunch;

  @override
  int get hashCode =>
      isDarkMode.hashCode ^
      enableNotifications.hashCode ^
      notificationTime.hashCode ^
      language.hashCode ^
      isAppFirstLaunch.hashCode;
}
