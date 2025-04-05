import 'package:flutter/material.dart';
import 'package:quote_canvas/data/model_class/enum/settings_keys.dart';
import 'package:quote_canvas/data/services/shared_preferences/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quote_canvas/data/model_class/settings.dart';
import 'package:quote_canvas/data/model_class/enum/quote_language.dart';

class SettingsServiceImpl implements SettingsService {
  final SharedPreferencesAsync _prefs;

  SettingsServiceImpl(this._prefs);

  Future<Settings> getSettings() async {
    return Settings(
      isDarkMode: await _prefs.getBool(SettingsKeys.isDarkMode.name) ?? false,
      enableNotifications:
          await _prefs.getBool(SettingsKeys.enableNotifications.name) ?? true,
      notificationTime:
          await _prefs.containsKey(SettingsKeys.notificationTimeHour.name)
              ? TimeOfDay(
                hour: await _prefs.getInt(SettingsKeys.notificationTimeHour.name) ?? 0,
                minute:
                    await _prefs.getInt(SettingsKeys.notificationTimeMinute.name) ?? 0,
              )
              : null,
      language: QuoteLanguage.fromCode(
        await _prefs.getString(SettingsKeys.language.name) ?? 'en',
      ),
      isAppFirstLaunch: await _prefs.getBool(SettingsKeys.isAppFirstLaunch.name) ?? false
    );
  }

  Future<bool> saveSettings(Settings settings) async {
    await _prefs.setBool(SettingsKeys.isDarkMode.name, settings.isDarkMode);
    await _prefs.setBool(SettingsKeys.enableNotifications.name, settings.enableNotifications);

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

    await _prefs.setString(SettingsKeys.language.name, settings.language.code);
    await _prefs.setBool(SettingsKeys.isAppFirstLaunch.name, settings.isAppFirstLaunch);

    return true;
  }
}
