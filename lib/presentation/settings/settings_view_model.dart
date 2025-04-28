import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/presentation/home/home_event.dart';
import 'package:quote_canvas/presentation/settings/settings_state.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:quote_canvas/core/result.dart';

class SettingsViewModel with ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final QuoteRepository _quoteRepository;
  SettingsState _state;

  SettingsState get state => _state;

  final _eventController = StreamController<HomeEvent>();

  Stream<HomeEvent> get eventStream => _eventController.stream;

  SettingsViewModel({
    required QuoteRepository quoteRepository,
    required SettingsRepository settingsRepository,
    required SettingsState state,
  }) : _state = state,
       _settingsRepository = settingsRepository,
       _quoteRepository = quoteRepository {
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

  Future<void> deleteAllData() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _quoteRepository.deleteAllQuotes();

    switch (result) {
      case Success():
        readyErrorMessage(
          message: '모든 데이터가 성공적으로 삭제되었습니다.',
          error: null,
          stacktrace: null,
        );
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
