import 'package:json_annotation/json_annotation.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';
import 'package:quote_canvas/data/model/enum/settings_keys.dart';
import 'package:quote_canvas/data/model/enum/theme_mode_setting.dart';

part 'settings_dto.g.dart';

@JsonSerializable()
class SettingsDto {
  final String? themeMode;
  final bool? enableNotifications;
  final int? notificationHour;
  final int? notificationMinute;
  final String? language;
  final bool? isAppFirstLaunch;
  final int? adTriggerCount;
  final bool? hasAskedPhotoPermission;

  SettingsDto({
    this.themeMode,
    this.enableNotifications,
    this.notificationHour,
    this.notificationMinute,
    this.language,
    this.isAppFirstLaunch,
    this.adTriggerCount,
    this.hasAskedPhotoPermission,
  });

  static const String defaultValueThemeMode = 'system';
  static const bool defaultValueEnableNotifications = false;
  static const int defaultValueNotificationHour = 0;
  static const int defaultValueNotificationMinute = 0;
  static String defaultValueLanguage() => QuoteLanguage.english.code;
  static const bool defaultValueIsAppFirstLaunch = false;
  static const int defaultValueAdTriggerCount = 0;
  static const bool defaultValueHasAskedPhotoPermission = false;

  factory SettingsDto.fromJson(Map<String, dynamic> json) =>
      _$SettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsDtoToJson(this);

  factory SettingsDto.fromMap(Map<String, dynamic> map) {
    final themeMode = map[SettingsKeys.themeMode.name];
    final enableNotifications = map[SettingsKeys.enableNotifications.name] == 1;
    final notificationTimeHour = map[SettingsKeys.notificationTimeHour.name];
    final notificationTimeMinute =
        map[SettingsKeys.notificationTimeMinute.name];
    final language = map[SettingsKeys.language.name];
    final isAppFirstLaunch = map[SettingsKeys.isAppFirstLaunch.name] == 1;
    final adTriggerCount = map[SettingsKeys.adTriggerCount.name];
    final hasAskedPhotoPermission =
        map[SettingsKeys.hasAskedPhotoPermission.name] == 1;

    return SettingsDto(
      themeMode: themeMode,
      enableNotifications: enableNotifications,
      notificationHour: notificationTimeHour,
      notificationMinute: notificationTimeMinute,
      language: language,
      isAppFirstLaunch: isAppFirstLaunch,
      adTriggerCount: adTriggerCount,
      hasAskedPhotoPermission: hasAskedPhotoPermission,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SettingsKeys.themeMode.name: themeMode,
      SettingsKeys.enableNotifications.name:
          enableNotifications == true ? 1 : 0,
      SettingsKeys.notificationTimeHour.name: notificationHour,
      SettingsKeys.notificationTimeMinute.name: notificationMinute,
      SettingsKeys.language.name: language,
      SettingsKeys.isAppFirstLaunch.name: isAppFirstLaunch == true ? 1 : 0,
      SettingsKeys.adTriggerCount.name: adTriggerCount,
      SettingsKeys.hasAskedPhotoPermission.name:
          hasAskedPhotoPermission == true ? 1 : 0,
    };
  }
}
