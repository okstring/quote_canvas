import 'package:flutter/material.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/model_class/enum/settings_keys.dart';
import 'package:quote_canvas/data/services/shared_preferences/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quote_canvas/data/model_class/settings.dart';
import 'package:quote_canvas/data/model_class/enum/quote_language.dart';
import 'package:quote_canvas/utils/logger.dart';

class SettingsServiceImpl implements SettingsService {
  final SharedPreferencesAsync _prefs;

  SettingsServiceImpl(this._prefs);

  @override
  Future<Settings> getSettings() async {
    try {
      final isDarkMode = await _prefs.getBool(SettingsKeys.isDarkMode.name) ?? false;
      final enableNotifications =
          await _prefs.getBool(SettingsKeys.enableNotifications.name) ?? true;

      TimeOfDay? notificationTime;
      if (await _prefs.containsKey(SettingsKeys.notificationTimeHour.name)) {
        final hour = await _prefs.getInt(SettingsKeys.notificationTimeHour.name) ?? 0;
        final minute = await _prefs.getInt(SettingsKeys.notificationTimeMinute.name) ?? 0;
        notificationTime = TimeOfDay(hour: hour, minute: minute);
      }

      final languageCode = await _prefs.getString(SettingsKeys.language.name) ?? 'en';
      final isAppFirstLaunch =
          await _prefs.getBool(SettingsKeys.isAppFirstLaunch.name) ?? false;

      return Settings(
        isDarkMode: isDarkMode,
        enableNotifications: enableNotifications,
        notificationTime: notificationTime,
        language: QuoteLanguage.fromCode(languageCode),
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
  Future<bool> saveSettings(Settings settings) async {
    try {
      // 다크 모드 설정 저장
      await _prefs.setBool(SettingsKeys.isDarkMode.name, settings.isDarkMode);

      // 알림 설정 저장
      await _prefs.setBool(
          SettingsKeys.enableNotifications.name,
          settings.enableNotifications
      );

      // 알림 시간 설정 저장
      if (settings.notificationTime != null) {
        await _prefs.setInt(
          SettingsKeys.notificationTimeHour.name,
          settings.notificationTime?.hour ?? 0,
        );
        await _prefs.setInt(
          SettingsKeys.notificationTimeMinute.name,
          settings.notificationTime?.minute ?? 0,
        );
      } else {
        await _prefs.remove(SettingsKeys.notificationTimeHour.name);
        await _prefs.remove(SettingsKeys.notificationTimeMinute.name);
      }

      // 언어 설정 저장
      await _prefs.setString(SettingsKeys.language.name, settings.language.code);

      // 앱 첫 실행 여부 저장
      await _prefs.setBool(
          SettingsKeys.isAppFirstLaunch.name,
          settings.isAppFirstLaunch
      );

      logger.info('사용자 설정이 성공적으로 저장되었습니다: $settings');
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