import 'package:quote_canvas/data/dto/quote_dto.dart';

abstract interface class WidgetDataSource {
  /// 즐겨찾기 명언들을 위젯에 전달
  Future<void> updateFavoriteQuotes(List<QuoteDto> favoriteQuotes);
  
  /// 위젯 새로고침 요청
  Future<void> refreshWidget();
  
  /// 위젯 데이터 초기화
  Future<void> clearWidgetData();
  
  /// 위젯에서 즐겨찾기 목록 가져오기 (디버깅 용도)
  Future<List<QuoteDto>> getFavoriteQuotesFromWidget();
}