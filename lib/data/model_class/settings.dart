import 'package:flutter/material.dart';

class Settings {
  final bool isDarkMode;
  final bool enableNotifications;
  final TimeOfDay? notificationTime;
  final String language;

  const Settings({
    this.isDarkMode = false,
    this.enableNotifications = true,
    this.notificationTime,
    this.language = 'ko',
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
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
      language: json['language'] ?? 'ko',
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
      'language': language,
    };
  }

  Settings copyWith({
    bool? isDarkMode,
    bool? enableNotifications,
    TimeOfDay? notificationTime,
    String? language,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notificationTime: notificationTime ?? this.notificationTime,
      language: language ?? this.language,
    );
  }
}
