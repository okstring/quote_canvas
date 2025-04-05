import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/utils/result.dart';

abstract interface class QuoteRepository {
  /// 명언 한 개 가져오기
  /// 로컬 DB에 표시되지 않은 명언이 없으면 API에서 새로 가져옴
  Future<Result<Quote>> getQuote();

  /// 즐겨찾기 추가/제거
  Future<Result<Quote>> toggleFavorite(Quote quote);

  /// 즐겨찾기 목록 가져오기
  Future<Result<List<Quote>>> getFavorites();
}