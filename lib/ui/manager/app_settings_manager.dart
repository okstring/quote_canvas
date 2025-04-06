import 'package:flutter/material.dart';
import 'package:quote_canvas/data/model_class/enum/quote_language.dart';
import 'package:quote_canvas/data/model_class/settings.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/utils/logger.dart';

class AppSettingsManager extends ChangeNotifier {
  final ValueNotifier<Settings> settingsNotifier = ValueNotifier<Settings>(const Settings());
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  Settings get currentSettings => settingsNotifier.value;
  String? get currentError => errorNotifier.value;

  final SettingsRepository _repository;

  AppSettingsManager(this._repository) {
    settingsNotifier.addListener(notifyListeners);
    errorNotifier.addListener(notifyListeners);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final result = await _repository.getSettings();
    result.when(
        success: (settings) {
          settingsNotifier.value = settings;
          errorNotifier.value = null;
        },
        failure: (error) {
          errorNotifier.value = '설정을 불러오지 못했습니다: ${error.message}';
          logger.error('User의 settings값을 불러오지 못했습니다: $error');
        }
    );
  }

  Future<bool> _updateSettings(Settings newSettings) async {
    final result = await _repository.saveSettings(newSettings);
    return result.when(
        success: (_) {
          settingsNotifier.value = newSettings;
          errorNotifier.value = null;
          return true;
        },
        failure: (error) {
          errorNotifier.value = '설정을 저장하지 못했습니다: ${error.message}';
          logger.error('User의 settings값을 저장하지 못했습니다: $error');
          return false;
        }
    );
  }

  // 에러 초기화 메서드 추가
  void clearError() {
    errorNotifier.value = null;
  }

  @override
  void dispose() {
    settingsNotifier.removeListener(notifyListeners);
    errorNotifier.removeListener(notifyListeners);
    settingsNotifier.dispose();
    errorNotifier.dispose();
    super.dispose();
  }
}