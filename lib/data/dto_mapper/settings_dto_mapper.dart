import 'package:quote_canvas/data/dto/settings_dto.dart';
import 'package:quote_canvas/data/model/settings.dart';

extension SettingsDtoMapper on Settings {
  SettingsDto toDto() {
    return SettingsDto(
      themeMode: themeMode.value,
      enableNotifications: enableNotifications,
      notificationHour: notificationTime?.hour,
      notificationMinute: notificationTime?.minute,
      language: language.code,
      isAppFirstLaunch: isAppFirstLaunch,
      adTriggerCount: adTriggerCount,
      hasAskedPhotoPermission: hasAskedPhotoPermission,
    );
  }
}
