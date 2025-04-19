// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsDto _$SettingsDtoFromJson(Map<String, dynamic> json) => SettingsDto(
  isDarkMode: json['isDarkMode'] as bool?,
  enableNotifications: json['enableNotifications'] as bool?,
  notificationHour: (json['notificationHour'] as num?)?.toInt(),
  notificationMinute: (json['notificationMinute'] as num?)?.toInt(),
  language: json['language'] as String?,
  isAppFirstLaunch: json['isAppFirstLaunch'] as bool?,
);

Map<String, dynamic> _$SettingsDtoToJson(SettingsDto instance) =>
    <String, dynamic>{
      'isDarkMode': instance.isDarkMode,
      'enableNotifications': instance.enableNotifications,
      'notificationHour': instance.notificationHour,
      'notificationMinute': instance.notificationMinute,
      'language': instance.language,
      'isAppFirstLaunch': instance.isAppFirstLaunch,
    };
