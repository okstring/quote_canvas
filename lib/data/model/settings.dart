import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';
import 'package:quote_canvas/data/model/enum/theme_mode_setting.dart';

part 'settings.freezed.dart';

@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    @Default(ThemeModeSetting.system) ThemeModeSetting themeMode,
    required bool enableNotifications,
    TimeOfDay? notificationTime,
    required QuoteLanguage language,
    required bool isAppFirstLaunch,
    required int adTriggerCount,
    required bool hasAskedPhotoPermission,
  }) = _Settings;

  factory Settings.defaultSettings() => const Settings(
    themeMode: ThemeModeSetting.system,
    enableNotifications: true,
    language: QuoteLanguage.english,
    isAppFirstLaunch: true,
    adTriggerCount: 0,
    hasAskedPhotoPermission: false,
  );
}

extension SettingsExtension on Settings {
  int get maxAdTriggerCount => 5;
}