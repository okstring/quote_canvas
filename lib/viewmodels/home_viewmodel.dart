import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../repository/quote_repository.dart';

/// 홈 화면의 ViewModel
class HomeViewModel extends ChangeNotifier {
  final QuoteRepository _quoteRepository;

  // 현재 표시 중인 명언
  Quote? _currentQuote;

  Quote? get currentQuote => _currentQuote;

  // 로딩 상태
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // 에러 메시지
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // 업데이트 최근 시간
  DateTime? _lastUpdateTime;

  DateTime? get lastUpdateTime => _lastUpdateTime;

  HomeViewModel({required QuoteRepository quoteRepository})
    : _quoteRepository = quoteRepository {
    // loadQuote();
  }

  /// 명언 가져오기
  Future<void> loadQuote() async {
    if (_isLoading) {
      return; // 이미 로딩 중이면 중복 요청 방지
    }

    _setLoading(true);

    final result = await _quoteRepository.getQuote();

    result.when(
      success: (quote) {
        _currentQuote = quote;
        _errorMessage = null;
        _lastUpdateTime = DateTime.now();
      },
      failure: (error) {
        _errorMessage = error.userFriendlyMessage;
      },
    );

    _setLoading(false);
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

  /// 에러 메시지 초기화
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// 로딩 상태 변경 헬퍼 메서드
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    // 필요한 정리 작업 수행
    super.dispose();
  }
}
