import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/utils/result.dart';

abstract interface class QuoteRepository {
  /// 명언 한 개 가져오기
  /// (영어 명언)로컬 DB에 표시되지 않은 명언이 없으면 API에서 새로 가져와 DB에 넣어두고 하나 가져옴
  /// (한글 명언)없으면 bundle에서 가져와 DB에 넣어두고 하나 가져옴
  Future<Result<Quote, AppException>> getQuote(QuoteLanguage language);

  /// 즐겨찾기 추가/제거
  Future<Result<Quote, AppException>> toggleFavorite(Quote quote);

  /// 즐겨찾기 목록 가져오기
  Future<Result<List<Quote>, AppException>> getFavorites(QuoteLanguage language);
}
