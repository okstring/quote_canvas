import 'package:quote_canvas/data/dto/settings_dto.dart';
import 'package:quote_canvas/data/model/settings.dart';

extension SettingsDtoMapper on Settings {
  SettingsDto toDto() {
    return SettingsDto(
      isDarkMode: isDarkMode,
      enableNotifications: enableNotifications,
      notificationHour: notificationTime?.hour,
      notificationMinute: notificationTime?.minute,
      language: language.code,
      isAppFirstLaunch: isAppFirstLaunch,
    );
  }
}
