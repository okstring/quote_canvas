import 'package:quote_canvas/data/model_class/enum/quote_language.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/services/API/quote_service.dart';
import 'package:quote_canvas/data/services/database/database_service.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/data/services/file_service/file_service.dart';
import 'package:quote_canvas/utils/result.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteService _quoteService;
  final DatabaseService _databaseService;
  final FileService _fileService;

  QuoteRepositoryImpl({
    required QuoteService quoteService,
    required DatabaseService databaseHelper,
    required FileService fileService,
  }) : _quoteService = quoteService,
       _databaseService = databaseHelper,
        _fileService = fileService;

  Future<Result<Quote>> getQuote(QuoteLanguage language) async {
    try {
      final unshownCount = await _databaseService.countUnshownQuotes(
        language.code,
      );

      // 영어 명언일 경우 표시되지 않은 영어 명언이 없으면 새로운 명언을 API 통해 20개 요청하기
      if (language == QuoteLanguage.english && unshownCount == 0) {
        final quotes = await _quoteService.getRandomQuotes();

        await _databaseService.insertQuotes(quotes);

        // 한글 명언일 경우 bundle에서 가져와 DB에 넣어두고 하나 가져옴
      } else if (language == QuoteLanguage.korean && unshownCount == 0) {
        final quotes = await _fileService.readKoreanQuotes();

        await _databaseService.insertQuotes(quotes);
      }
      // 1개의 명언을 읽음처리하고 가져온다.
      return await _getAndMarkQuoteAsShown(language);
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
  Future<Result<List<Quote>>> getFavorites(QuoteLanguage language) async {
    try {
      final favorites = await _databaseService.getFavoriteQuotes(
        language.code,
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

  // 1개의 명언을 읽음처리하고 가져온다.
  Future<Result<Quote>> _getAndMarkQuoteAsShown(QuoteLanguage language) async {
    final quote = await _databaseService.getUnshownQuote(
      language.code,
    );

    if (quote == null) {
      return Result.failure(
        AppException.database(message: '표시할 명언을 찾을 수 없습니다.'),
      );
    }

    final updatedQuote = quote.copyWith(isPreviouslyShown: true);
    // 표시 상태로 변경
    await _databaseService.updateQuoteShownStatus(quote.id, true);
    return Result.success(updatedQuote);
  }

}
