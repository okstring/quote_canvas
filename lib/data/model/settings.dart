import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';

part 'settings.freezed.dart';

@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    required bool isDarkMode,
    required bool enableNotifications,
    TimeOfDay? notificationTime,
    required QuoteLanguage language,
    required bool isAppFirstLaunch,
  }) = _Settings;

  factory Settings.defaultSettings() =>
      const Settings(
        isDarkMode: false,
        enableNotifications: true,
        language: QuoteLanguage.english,
        isAppFirstLaunch: true,
      );
}