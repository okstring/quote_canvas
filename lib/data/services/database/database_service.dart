import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:sqflite/sqflite.dart';

/// 데이터베이스 서비스를 위한 인터페이스
abstract interface class DatabaseService {
  /// SQLite 데이터베이스 인스턴스를 가져오는 메서드
  Future<Database> get database;

  /// 명언 저장 메서드
  Future<int> insertQuote(Quote quote);

  /// 여러 명언 저장 메서드
  Future<List<int>> insertQuotes(List<Quote> quotes);

  /// 명언 업데이트 메서드
  Future<int> updateQuote(Quote quote);

  /// 명언 상태 업데이트 메서드 (표시 여부)
  Future<int> updateQuoteShownStatus(String id, bool isPreviouslyShown);

  /// 명언 상태 업데이트 메서드 (즐겨찾기)
  Future<int> updateQuoteFavoriteStatus(String id, bool isFavorite);

  /// 명언 단일 조회 메서드
  Future<Quote?> getQuote(String id);

  /// 아직 표시되지 않은 명언 가져오기
  Future<Quote?> getUnshownQuote();

  /// 모든 명언 가져오기
  Future<List<Quote>> getAllQuotes();

  /// 표시된 명언 개수 확인
  Future<int> countShownQuotes();

  /// 표시되지 않은 명언 개수 확인
  Future<int> countUnshownQuotes();

  /// 즐겨찾기 명언 가져오기
  Future<List<Quote>> getFavoriteQuotes();

  /// 명언 삭제 메서드
  Future<int> deleteQuote(String id);

  /// 데이터베이스 닫기
  Future<void> close();
}