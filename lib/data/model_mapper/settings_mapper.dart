import 'package:flutter/material.dart';
import 'package:quote_canvas/data/dto/settings_dto.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';
import 'package:quote_canvas/data/model/settings.dart';

extension SettingsMapper on SettingsDto {
  Settings toModel() {
    TimeOfDay timeOfDay = TimeOfDay(
      hour: notificationHour ?? SettingsDto.defaultValueNotificationHour,
      minute: notificationMinute ?? SettingsDto.defaultValueNotificationMinute,
    );

    return Settings(
      isDarkMode: isDarkMode ?? SettingsDto.defaultValueIsDarkMode,
      enableNotifications:
          enableNotifications ?? SettingsDto.defaultValueEnableNotifications,
      notificationTime: timeOfDay,
      language:
          language != null
              ? QuoteLanguage.fromCode(language ?? '')
              : QuoteLanguage.english,
      isAppFirstLaunch:
          isAppFirstLaunch ?? SettingsDto.defaultValueIsAppFirstLaunch,
    );
  }
}
