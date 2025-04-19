import 'package:flutter/material.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/presentation/home/home_state.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:quote_canvas/utils/result.dart';

class HomeViewModel with ChangeNotifier {
  final QuoteRepository _quoteRepository;
  final SettingsRepository _settingsRepository;

  HomeState _state;

  HomeState get state => _state;

  HomeViewModel({
    required QuoteRepository quoteRepository,
    required SettingsRepository settingsRepository,
    required HomeState state,
  }) : _quoteRepository = quoteRepository,
       _settingsRepository = settingsRepository,
       _state = state {
    notifyListeners();
  }


  /// 명언 가져오기
  Future<void> loadQuote() async {
    _state = state.copyWith(isLoading: true);

    final language = state.settings.language;
    final result = await _quoteRepository.getQuote(language);

    switch (result) {
      case Success():
        _state = state.copyWith(
          currentQuote: result.data,
          lastUpdateTime: DateTime.now(),
          errorMessage: null,
        );
        notifyListeners();
        break;
      case Error():
        final error = result.error;
        logger.error(
          error.message,
          error: error.error,
          stackTrace: error.stackTrace,
        );
        _state = state.copyWith(errorMessage: error.userFriendlyMessage);
        notifyListeners();
        break;
    }

    _state = state.copyWith(isLoading: false);
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite() async {
    // TODO: 즐겨찾기 서비스 구현
    debugPrint('즐겨찾기 기능은 아직 구현되지 않았습니다.');
  }

  /// 명언 공유하기
  void shareQuote() {
    // TODO: 공유 서비스 구현
    debugPrint('공유 기능은 아직 구현되지 않았습니다.');
  }

  /// 명언 이미지 저장하기
  Future<void> saveQuoteImage() async {
    // TODO: 이미지 저장 서비스 구현
    debugPrint('이미지 저장 기능은 아직 구현되지 않았습니다.');
  }
}
