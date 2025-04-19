import 'package:json_annotation/json_annotation.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';
import 'package:quote_canvas/data/model/enum/settings_keys.dart';

part 'settings_dto.g.dart';

@JsonSerializable()
class SettingsDto {
  final bool? isDarkMode;
  final bool? enableNotifications;
  final int? notificationHour;
  final int? notificationMinute;
  final String? language;
  final bool? isAppFirstLaunch;

  SettingsDto({
    this.isDarkMode,
    this.enableNotifications,
    this.notificationHour,
    this.notificationMinute,
    this.language,
    this.isAppFirstLaunch,
  });

  static const bool defaultValueIsDarkMode = false;
  static const bool defaultValueEnableNotifications = false;
  static const int defaultValueNotificationHour = 0;
  static const int defaultValueNotificationMinute = 0;
  static String defaultValueLanguage() => QuoteLanguage.english.code;
  static const bool defaultValueIsAppFirstLaunch = false;

  factory SettingsDto.fromJson(Map<String, dynamic> json) =>
      _$SettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsDtoToJson(this);

  factory SettingsDto.fromMap(Map<String, dynamic> map) {
    final isDarkMode = map[SettingsKeys.isDarkMode.name] == 1;
    final enableNotifications = map[SettingsKeys.enableNotifications.name] == 1;
    final notificationTimeHour = map[SettingsKeys.notificationTimeHour.name];
    final notificationTimeMinute =
        map[SettingsKeys.notificationTimeMinute.name];
    final language = map[SettingsKeys.language.name];
    final isAppFirstLaunch = map[SettingsKeys.isAppFirstLaunch.name] == 1;

    return SettingsDto(
      isDarkMode: isDarkMode,
      enableNotifications: enableNotifications,
      notificationHour: notificationTimeHour,
      notificationMinute: notificationTimeMinute,
      language: language,
      isAppFirstLaunch: isAppFirstLaunch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SettingsKeys.isDarkMode.name: isDarkMode == true ? 1 : 0,
      SettingsKeys.enableNotifications.name:
          enableNotifications == true ? 1 : 0,
      SettingsKeys.notificationTimeHour.name: notificationHour,
      SettingsKeys.notificationTimeMinute.name: notificationMinute,
      SettingsKeys.language.name: language,
      SettingsKeys.isAppFirstLaunch.name: isAppFirstLaunch == true ? 1 : 0,
    };
  }
}
