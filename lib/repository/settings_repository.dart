import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
import 'dart:convert';

class SettingsRepository {
  static const String _settingsKey = 'user_settings';

  Future<Settings> getSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final settingsJson = preferences.getString(_settingsKey);
    if (settingsJson == null) {

      return Settings();
    }

    try {
      return Settings.fromJson(jsonDecode(settingsJson));
    } catch (e) {
      return Settings();
    }

  }
}