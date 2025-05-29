import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quote_canvas/core/result.dart';
import 'package:quote_canvas/data/model/enum/theme_mode_setting.dart';
import 'package:quote_canvas/data/model/settings.dart';
import 'package:quote_canvas/data/repository/package_info_repository.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/presentation/settings/settings_event.dart';
import 'package:quote_canvas/presentation/settings/settings_state.dart';
import 'package:quote_canvas/utils/logger.dart';

class SettingsViewModel with ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final QuoteRepository _quoteRepository;
  final PackageInfoRepository _packageInfoRepository;
  SettingsState _state;

  SettingsState get state => _state;

  final _eventController = StreamController<SettingsEvent>();

  Stream<SettingsEvent> get eventStream => _eventController.stream;

  SettingsViewModel({
    required QuoteRepository quoteRepository,
    required SettingsRepository settingsRepository,
    required PackageInfoRepository packageInfoRepository,
    required SettingsState state,
  }) : _state = state,
       _settingsRepository = settingsRepository,
       _quoteRepository = quoteRepository,
       _packageInfoRepository = packageInfoRepository;

  Future<void> initialize() async {
    await loadSettings();
    await getAppVersion();
  }

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }

  Future<void> loadSettings() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _settingsRepository.getSettings();

    switch (result) {
      case Success():
        _state = state.copyWith(settings: result.data);
        break;
      case Error():
        final error = result.error;
        readyErrorMessage(
          message: error.userFriendlyMessage,
          error: error.error,
          stacktrace: error.stackTrace,
        );
        break;
    }
    _state = state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeModeSetting themeMode) async {
    final updatedSettings = state.settings.copyWith(themeMode: themeMode);
    await saveSettings(updatedSettings);
  }

  Future<void> saveSettings(Settings settings) async {
    final result = await _settingsRepository.saveSettings(settings);

    switch (result) {
      case Success():
        _state = state.copyWith(settings: settings);
        notifyListeners();
        break;
      case Error():
        final error = result.error;
        readyErrorMessage(
          message: error.userFriendlyMessage,
          error: error.error,
          stacktrace: error.stackTrace,
        );
        break;
    }
  }

  Future<void> deleteAllData() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _quoteRepository.deleteAllQuotes();

    switch (result) {
      case Success():
        logger.info('모든 명언 데이터가 삭제되었습니다.');
        break;
      case Error():
        final error = result.error;
        readyErrorMessage(
          message: error.userFriendlyMessage,
          error: error.error,
          stacktrace: error.stackTrace,
        );
        break;
    }

    _state = state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> getAppVersion() async {
    final result = await _packageInfoRepository.getPackageInfo();

    switch (result) {
      case Success():
        _state = state.copyWith(appVersion: result.data);
        break;
      case Error():
        final error = result.error;
        logger.error(
          error.toString(),
          error: error.error,
          stackTrace: error.stackTrace,
        );
        _state = state.copyWith(appVersion: '0.0.0');
        break;
    }
  }

  void readyErrorMessage({
    required String message,
    Object? error,
    StackTrace? stacktrace,
  }) {
    logger.error(message, error: error, stackTrace: stacktrace);
    _eventController.add(SettingsEvent.showSnackbar(message));
    notifyListeners();
  }
}
