import 'package:quote_canvas/data/model_class/enum/quote_language.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/services/API/quote_service.dart';
import 'package:quote_canvas/data/services/database/database_service.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/utils/result.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteService _quoteService;
  final DatabaseService _databaseService;

  // TODO: SettingManager 구현
  QuoteLanguage _selectedLanguage = QuoteLanguage.english;

  QuoteRepositoryImpl({
    required QuoteService quoteService,
    required DatabaseService databaseHelper,
  }) : _quoteService = quoteService,
       _databaseService = databaseHelper;

  /// 명언 한 개 가져오기
  /// 로컬 DB에 표시되지 않은 명언이 없으면 API에서 새로 가져옴
  Future<Result<Quote>> getQuote() async {
    try {
      final unshownCount = await _databaseService.countUnshownQuotes(
        _selectedLanguage.code,
      );

      // 표시되지 않은 영어 명언이 없으면 새로운 명언을 API 통해 20개 요청하기
      if (_selectedLanguage == QuoteLanguage.english && unshownCount == 0) {
        final quotes = await _quoteService.getRandomQuotes();

        await _databaseService.insertQuotes(quotes);
      }
      // 표시되지 않은 명언이 이미 있는 경우
      return await _getAndMarkQuoteAsShown();
    } catch (e, stackTrace) {
      if (e is UnknownException) {
        return Result.failure(
          AppException.unknown(
            message: '명언을 가져오는 중 오류가 발생했습니다.',
            error: e,
            stackTrace: stackTrace,
          ),
        );
      } else {
        return await Result.failure(e as AppException);
      }
    }
  }

  /// 데이터베이스에서 표시되지 않은 명언을 가져와서 표시 상태로 변경
  Future<Result<Quote>> _getAndMarkQuoteAsShown() async {
    final quote = await _databaseService.getUnshownQuote(
      _selectedLanguage.code,
    );

    if (quote == null) {
      return Result.failure(
        AppException.database(message: '표시할 명언을 찾을 수 없습니다.'),
      );
    }

    // 표시 상태로 변경
    final updatedQuote = quote.copyWith(isPreviouslyShown: true);
    await _databaseService.updateQuoteShownStatus(quote.id, true);
    return Result.success(updatedQuote);
  }

  /// 즐겨찾기 추가/제거
  Future<Result<Quote>> toggleFavorite(Quote quote) async {
    try {
      final newFavoriteStatus = !quote.isFavorite;
      await _databaseService.updateQuoteFavoriteStatus(
        quote.id,
        newFavoriteStatus,
      );

      final updatedQuote = quote.copyWith(
        isFavorite: newFavoriteStatus,
        favoriteDate: newFavoriteStatus ? DateTime.now() : null,
      );

      return Result.success(updatedQuote);
    } catch (e, stackTrace) {
      return Result.failure(
        AppException.database(
          message: '즐겨찾기 상태를 변경하는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// 즐겨찾기 목록 가져오기
  Future<Result<List<Quote>>> getFavorites() async {
    try {
      final favorites = await _databaseService.getFavoriteQuotes(
        _selectedLanguage.code,
      );
      return Result.success(favorites);
    } catch (e, stackTrace) {
      return Result.failure(
        AppException.database(
          message: '즐겨찾기 목록을 가져오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
