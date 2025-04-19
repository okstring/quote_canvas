import 'package:quote_canvas/data/dto/quote_dto.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:sqflite/sqflite.dart';

/// 데이터베이스 서비스를 위한 인터페이스
abstract interface class DatabaseDataSource {
  /// SQLite 데이터베이스 인스턴스를 가져오는 메서드
  Future<Database> get database;

  // ===== CREATE (생성) 작업 =====

  /// 명언 저장 메서드
  Future<int> insertQuote(QuoteDto quote);

  /// 여러 명언 저장 메서드
  Future<List<int>> insertQuotes(List<QuoteDto> quotes);

  // ===== READ (조회) 작업 =====

  /// 명언 단일 조회 메서드
  Future<QuoteDto?> getQuote(String id, String languageCode);

  /// 아직 표시되지 않은 명언 가져오기
  Future<QuoteDto?> getUnshownQuote(String languageCode);

  /// 모든 명언 가져오기
  Future<List<QuoteDto>> getAllQuotes(String languageCode);

  /// 즐겨찾기 명언 가져오기
  Future<List<QuoteDto>> getFavoriteQuotes(String languageCode);

  /// 표시된 명언 개수 확인
  Future<int> countShownQuotes();

  /// 표시되지 않은 명언 개수 확인
  Future<int> countUnshownQuotes(String languageCode);

  // ===== UPDATE (수정) 작업 =====

  /// 명언 업데이트 메서드
  Future<int> updateQuote(QuoteDto quoteDto);

  /// 명언 상태 업데이트 메서드 (표시 여부)
  Future<int> updateQuoteShownStatus(String id, bool isPreviouslyShown);

  /// 명언 상태 업데이트 메서드 (즐겨찾기)
  Future<int> updateQuoteFavoriteStatus(String id, bool isFavorite);

  // ===== DELETE (삭제) 작업 =====

  /// 명언 삭제 메서드
  Future<int> deleteQuote(String id);

  // ===== 기타 관리 메서드 =====

  /// 데이터베이스 닫기
  Future<void> close();

  /// 테스트 간 클린업을 위한 메서드
  Future<void> resetDatabase();
}
