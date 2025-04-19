import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/data_source/shared_preferences/settings_data_source.dart';
import 'package:quote_canvas/data/dto/settings_dto.dart';
import 'package:quote_canvas/data/model/enum/settings_keys.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDataSourceImpl implements SettingsDataSource {
  final SharedPreferencesAsync _prefs;

  SettingsDataSourceImpl(this._prefs);

  @override
  Future<SettingsDto> getSettings() async {
    try {
      final isDarkMode =
          await _prefs.getBool(SettingsKeys.isDarkMode.name) ?? false;
      final enableNotifications =
          await _prefs.getBool(SettingsKeys.enableNotifications.name) ?? true;

      final hour =
          await _prefs.getInt(SettingsKeys.notificationTimeHour.name) ?? 0;
      final minute =
          await _prefs.getInt(SettingsKeys.notificationTimeMinute.name) ?? 0;

      final languageCode =
          await _prefs.getString(SettingsKeys.language.name) ?? 'en';
      final isAppFirstLaunch =
          await _prefs.getBool(SettingsKeys.isAppFirstLaunch.name) ?? false;

      return SettingsDto(
        isDarkMode: isDarkMode,
        enableNotifications: enableNotifications,
        notificationHour: hour,
        notificationMinute: minute,
        language: languageCode,
        isAppFirstLaunch: isAppFirstLaunch,
      );
    } catch (e, stackTrace) {
      logger.error('설정 로드 중 오류 발생', error: e, stackTrace: stackTrace);
      throw AppException.settings(
        message: '사용자 설정을 불러오는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> saveSettings(SettingsDto settingsDto) async {
    try {
      // 다크 모드 설정 저장
      await _prefs.setBool(
        SettingsKeys.isDarkMode.name,
        settingsDto.isDarkMode ?? SettingsDto.defaultValueIsDarkMode,
      );

      // 알림 설정 저장
      await _prefs.setBool(
        SettingsKeys.enableNotifications.name,
        settingsDto.enableNotifications ??
            SettingsDto.defaultValueEnableNotifications,
      );

      // 알림 시간 설정 저장
      await _prefs.setInt(
        SettingsKeys.notificationTimeHour.name,
        settingsDto.notificationHour ??
            SettingsDto.defaultValueNotificationHour,
      );
      await _prefs.setInt(
        SettingsKeys.notificationTimeMinute.name,
        settingsDto.notificationMinute ??
            SettingsDto.defaultValueNotificationMinute,
      );

      // 언어 설정 저장
      await _prefs.setString(
        SettingsKeys.language.name,
        settingsDto.language ?? SettingsDto.defaultValueLanguage(),
      );

      // 앱 첫 실행 여부 저장
      await _prefs.setBool(
        SettingsKeys.isAppFirstLaunch.name,
        settingsDto.isAppFirstLaunch ??
            SettingsDto.defaultValueIsAppFirstLaunch,
      );

      logger.info('사용자 설정이 성공적으로 저장되었습니다: $settingsDto');
      return true;
    } catch (e, stackTrace) {
      logger.error('설정 저장 중 오류 발생', error: e, stackTrace: stackTrace);
      throw AppException.settings(
        message: '사용자 설정을 저장하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
