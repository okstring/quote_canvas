import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/result.dart';
import 'package:quote_canvas/data/model/quote.dart';

abstract interface class WidgetRepository {
  /// 즐겨찾기 명언들을 위젯에 업데이트
  Future<Result<void, AppException>> updateFavoriteQuotes(List<Quote> favoriteQuotes);
  
  /// 위젯 새로고침
  Future<Result<void, AppException>> refreshWidget();
  
  /// 위젯 데이터 초기화
  Future<Result<void, AppException>> clearWidget();
}