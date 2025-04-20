import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:quote_canvas/data/repository/file_repository.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/presentation/home/home_state.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:quote_canvas/utils/result.dart';

class HomeViewModel with ChangeNotifier {
  final QuoteRepository _quoteRepository;
  final SettingsRepository _settingsRepository;
  final FileRepository _fileRepository;

  HomeState _state;

  HomeState get state => _state;

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

  String get shareText =>
      '${state.currentQuote.content} - ${state.currentQuote.author}';

  String get shareTitle => 'Quote Canvas';

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
          errorMessage: null,
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

  /// 즐겨찾기 토글
  Future<void> toggleFavorite() async {
    _state = state.copyWith(isLoading: true);

    final result = await _quoteRepository.toggleFavorite(state.currentQuote);
    switch (result) {
      case Success():
        _state = state.copyWith(
          currentQuote: result.data,
          lastUpdateTime: DateTime.now(),
          errorMessage: null,
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
    logger.info(state.currentQuote.toString());
  }

  /// 명언 이미지 저장하기
  Future<void> saveQuoteImage() async {
    // TODO: 이미지 저장 서비스 구현
    debugPrint('이미지 저장 기능은 아직 구현되지 않았습니다.');
  }

  /// 명언 이미지 임시 저장하고 실패하면 에러 던지기
  Future<String> saveTempQuoteImageOrThrow(Uint8List pngBytes) async {
    final result = await _fileRepository.saveTempQuoteImage(pngBytes);

    switch (result) {
      case Success():
        return result.data;
      case Error():
        final error = result.error;
        throw error;
    }
  }

  void clearErrorMessage() {
    _state = state.copyWith(errorMessage: null);
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
