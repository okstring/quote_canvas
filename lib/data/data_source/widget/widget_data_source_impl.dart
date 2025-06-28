import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/data_source/widget/widget_data_source.dart';
import 'package:quote_canvas/data/dto/quote_dto.dart';
import 'package:quote_canvas/utils/logger.dart';

class WidgetDataSourceImpl implements WidgetDataSource {
  static const String _favoriteQuotesKey = 'favorite_quotes';
  static const String _lastUpdateKey = 'last_update';
  static const String _noFavoritesMessageKey = 'no_favorites_message';
  static const String _widgetName = 'QuoteCanvasWidget';
  static const int _maxQuotesCount = 20; // 성능을 위한 제한

  @override
  Future<void> updateFavoriteQuotes(List<QuoteDto> favoriteQuotes) async {
    try {
      if (favoriteQuotes.isEmpty) {
        await clearWidgetData();
        return;
      }
      
      // 최대 개수 제한 적용
      final limitedQuotes = favoriteQuotes.take(_maxQuotesCount).toList();
      
      final quotesJson = limitedQuotes
          .map((dto) => dto.toWidgetJson())
          .toList();
      
      await HomeWidget.saveWidgetData<String>(
        _favoriteQuotesKey, 
        jsonEncode(quotesJson),
      );
      
      await HomeWidget.saveWidgetData<String>(
        _lastUpdateKey, 
        DateTime.now().toIso8601String(),
      );
      
      logger.info('위젯에 ${limitedQuotes.length}개의 즐겨찾기 명언 업데이트 완료');
      
    } catch (e, stackTrace) {
      logger.error('위젯 데이터 업데이트 실패', error: e, stackTrace: stackTrace);
      throw AppException.unknown(
        message: '위젯 데이터를 업데이트하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  @override
  Future<void> refreshWidget() async {
    try {
      await HomeWidget.updateWidget(
        iOSName: _widgetName,
      );
      logger.info('위젯 새로고침 요청 완료');
    } catch (e, stackTrace) {
      logger.error('위젯 새로고침 실패', error: e, stackTrace: stackTrace);
      throw AppException.unknown(
        message: '위젯을 새로고침하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  @override
  Future<void> clearWidgetData() async {
    try {
      await HomeWidget.saveWidgetData<String>(_favoriteQuotesKey, '[]');
      await HomeWidget.saveWidgetData<String>(
        _noFavoritesMessageKey, 
        'Add some quotes to favorites to see them here!',
      );
      logger.info('위젯 데이터 초기화 완료');
    } catch (e, stackTrace) {
      logger.error('위젯 데이터 초기화 실패', error: e, stackTrace: stackTrace);
      throw AppException.unknown(
        message: '위젯 데이터를 초기화하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  @override
  Future<List<QuoteDto>> getFavoriteQuotesFromWidget() async {
    try {
      final quotesJsonString = await HomeWidget.getWidgetData<String>(
        _favoriteQuotesKey,
        defaultValue: '[]',
      );
      
      if (quotesJsonString == null || quotesJsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> quotesJson = jsonDecode(quotesJsonString);
      return quotesJson
          .map((json) => QuoteDtoWidget.fromWidgetJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      logger.error('위젯에서 데이터 읽기 실패', error: e, stackTrace: stackTrace);
      return [];
    }
  }
}