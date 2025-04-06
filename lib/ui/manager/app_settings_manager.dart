import 'package:flutter/material.dart';
import 'package:quote_canvas/data/model_class/settings.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/utils/logger.dart';

class AppSettingsManager extends ChangeNotifier {
  final ValueNotifier<Settings> settingsNotifier = ValueNotifier<Settings>(const Settings());
  Settings get currentSettings => settingsNotifier.value;

  final SettingsRepository _repository;

  AppSettingsManager(this._repository) {
    settingsNotifier.addListener(notifyListeners);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final result = await _repository.getSettings();
    result.when(
        success: (settings) => settingsNotifier.value = settings,
        failure: (_) {
          logger.error('User의 settings값을 불러오지 못했습니다');
        } // 기본값 유지
    );
  }

  Future<bool> _updateSettings(Settings newSettings) async {
    final result = await _repository.saveSettings(newSettings);
    return result.when(
        success: (_) {
          settingsNotifier.value = newSettings;
          return true;
        },
        failure: (_) {
          logger.error('User의 settings값을 저장하지 못했습니다');
          return false;
        }
    );
  }

  @override
  void dispose() {
    settingsNotifier.removeListener(notifyListeners);
    settingsNotifier.dispose();
    super.dispose();
  }
}