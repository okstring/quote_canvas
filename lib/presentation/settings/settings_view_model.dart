import 'package:flutter/material.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/presentation/settings/settings_state.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:quote_canvas/utils/result.dart';

class SettingsViewModel with ChangeNotifier {
  final SettingsRepository _settingsRepository;
  SettingsState _state;

  SettingsState get state => _state;

  SettingsViewModel({
    required SettingsRepository settingsRepository,
    required SettingsState state,
  }) : _state = state,
       _settingsRepository = settingsRepository {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _settingsRepository.getSettings();

    switch (result) {
      case Success():
        _state = state.copyWith(settings: result.data);
        print(_state);
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

  void readyErrorMessage({
    required String message,
    Object? error,
    StackTrace? stacktrace,
  }) {
    logger.error(message, error: error, stackTrace: stacktrace);
    _state = state.copyWith(errorMessage: message);
  }
}
