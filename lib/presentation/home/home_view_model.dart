import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:quote_canvas/data/repository/file_repository.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/presentation/home/home_event.dart';
import 'package:quote_canvas/presentation/home/home_state.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:quote_canvas/core/result.dart';

class HomeViewModel with ChangeNotifier {
  final QuoteRepository _quoteRepository;
  final SettingsRepository _settingsRepository;
  final FileRepository _fileRepository;

  HomeState _state;

  HomeState get state => _state;

  final _eventController = StreamController<HomeEvent>();

  Stream<HomeEvent> get eventStream => _eventController.stream;

  HomeViewModel({
    required QuoteRepository quoteRepository,
    required SettingsRepository settingsRepository,
    required FileRepository fileRepository,
    required HomeState state,
  }) : _quoteRepository = quoteRepository,
       _settingsRepository = settingsRepository,
       _fileRepository = fileRepository,
       _state = state {
    notifyListeners();
  }


  Future<void> initialize() async {
    await loadQuote();
    await loadSettings();
  }

  /// 명언 가져오기
  Future<void> loadQuote() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final language = state.settings.language;
    final result = await _quoteRepository.getQuote(language);

    switch (result) {
      case Success():
        _state = state.copyWith(
            currentQuote: result.data,
            lastUpdateTime: DateTime.now(),
            isLoading: false,
            quoteFetchErrorMessage: null
        );
        break;
      case Error():
        final error = result.error;
        _state = state.copyWith(
            quoteFetchErrorMessage: error.userFriendlyMessage,
            isLoading: false);
        readyToErrorMessage(
          message: error.userFriendlyMessage,
          error: error.error,
          stacktrace: error.stackTrace,
        );
        break;
    }
    notifyListeners();
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
        readyToErrorMessage(
          message: error.userFriendlyMessage,
          error: error.error,
          stacktrace: error.stackTrace,
        );
        break;
    }

    _state = state.copyWith(isLoading: false);
    notifyListeners();
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite() async {
    _state = state.copyWith(isLoading: true);

    final result = await _quoteRepository.toggleFavorite(state.currentQuote);
    switch (result) {
      case Success():
        _state = state.copyWith(
          currentQuote: result.data,
          lastUpdateTime: DateTime.now(),
        );
        break;
      case Error():
        final error = result.error;
        readyToErrorMessage(
          message: error.userFriendlyMessage,
          error: error.error,
          stacktrace: error.stackTrace,
        );
        break;
    }

    _state = state.copyWith(isLoading: false);
    logger.info(state.currentQuote.toString());
  }

  /// 명언 이미지 임시 저장
  Future<void> saveTempQuoteImage(Uint8List pngBytes) async {
    final result = await _fileRepository.saveTempQuoteImage(pngBytes);

    switch (result) {
      case Success():
        final filePath = result.data;
        _eventController.add(HomeEvent.shareFile(filePath, state.shareText, state.shareTitle));
      case Error():
        final error = result.error;
        readyToErrorMessage(message: error.userFriendlyMessage, error: error);
    }
  }

  void readyToErrorMessage({
    required String message,
    Object? error,
    StackTrace? stacktrace,
  }) {
    logger.error(message, error: error, stackTrace: stacktrace);
    _eventController.add(HomeEvent.showSnackbar(message));
  }

  void readytToShowSnackBar({
    required String message
  }) {
    _eventController.add(HomeEvent.showSnackbar(message));
  }

  void setPhotoPermissionStatus(bool hasAsked) {
    _state = state.copyWith(settings: state.settings.copyWith(hasAskedPhotoPermission: hasAsked));
  }

  void setQuoteBackgroundColor(Color color) {
    _state = state.copyWith(quoteBackgroundColor: color);
    notifyListeners();
  }

  void setQuoteFontColor(Color color) {
    _state = state.copyWith(quoteFontColor: color);
    notifyListeners();
  }
}