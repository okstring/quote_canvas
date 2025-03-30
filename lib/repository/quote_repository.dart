import 'package:quote_canvas/database/database_helper_interface.dart';
import 'package:quote_canvas/services/quote_service_interface.dart';
import '../models/quote.dart';
import '../utils/result.dart';
import '../core/exceptions/app_exception.dart';

//TODO: interface 구현
class QuoteRepository {
  final QuoteServiceInterface _quoteService;
  final DatabaseHelperInterface _databaseHelper;

  QuoteRepository({
    required QuoteServiceInterface quoteService,
    required DatabaseHelperInterface databaseHelper,
  }) : _quoteService = quoteService,
       _databaseHelper = databaseHelper;

  /// 명언 한 개 가져오기
  /// 로컬 DB에 표시되지 않은 명언이 없으면 API에서 새로 가져옴
  Future<Result<Quote>> getQuote() async {
    try {
      final unshownCount = await _databaseHelper.countUnshownQuotes();

      // 표시되지 않은 명언이 없으면 새로운 명언 20개 가져오기
      if (unshownCount == 0) {
        final result = await _quoteService.getRandomQuotes();

        return await result.when(
          success: (quotes) async {

            // API에서 가져온 명언들을 DB에 저장
            await _databaseHelper.insertQuotes(quotes);
            return _getAndMarkQuoteAsShown();
          },
          failure: (error) {
            return Result.failure(error);
          },
        );
      }

      // 표시되지 않은 명언이 이미 있는 경우
      return _getAndMarkQuoteAsShown();
    } catch (e, stackTrace) {
      return Result.failure(
        AppException.unknown(
          message: '명언을 가져오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// 데이터베이스에서 표시되지 않은 명언을 가져와서 표시 상태로 변경
  Future<Result<Quote>> _getAndMarkQuoteAsShown() async {
    final quote = await _databaseHelper.getUnshownQuote();

    if (quote == null) {
      return Result.failure(
        AppException.database(message: '표시할 명언을 찾을 수 없습니다.'),
      );
    }

    await _databaseHelper.updateQuoteShownStatus(quote.id, true);
    return Result.success(quote);
  }

  /// 즐겨찾기 추가/제거
  Future<Result<Quote>> toggleFavorite(Quote quote) async {
    try {
      final newFavoriteStatus = !quote.isFavorite;
      await _databaseHelper.updateQuoteFavoriteStatus(
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
      final favorites = await _databaseHelper.getFavoriteQuotes();
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
