import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/core/result.dart';
import 'package:quote_canvas/data/data_source/widget/widget_data_source.dart';
import 'package:quote_canvas/data/dto_mapper/quote_dto_mapper.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/data/repository/widget_repository.dart';

class WidgetRepositoryImpl implements WidgetRepository {
  final WidgetDataSource _widgetDataSource;

  const WidgetRepositoryImpl({
    required WidgetDataSource widgetDataSource,
  }) : _widgetDataSource = widgetDataSource;

  @override
  Future<Result<void, AppException>> updateFavoriteQuotes(List<Quote> favoriteQuotes) async {
    try {
      final quoteDtos = favoriteQuotes
          .map((quote) => quote.toDto())
          .toList();
      
      await _widgetDataSource.updateFavoriteQuotes(quoteDtos);
      await _widgetDataSource.refreshWidget();
      
      return const Result.success(null);
    } catch (e, stackTrace) {
      if (e is AppException) {
        return Result.error(e);
      }
      return Result.error(
        AppException.unknown(
          message: '위젯 즐겨찾기 업데이트 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> refreshWidget() async {
    try {
      await _widgetDataSource.refreshWidget();
      return const Result.success(null);
    } catch (e, stackTrace) {
      if (e is AppException) {
        return Result.error(e);
      }
      return Result.error(
        AppException.unknown(
          message: '위젯 새로고침 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void, AppException>> clearWidget() async {
    try {
      await _widgetDataSource.clearWidgetData();
      await _widgetDataSource.refreshWidget();
      return const Result.success(null);
    } catch (e, stackTrace) {
      if (e is AppException) {
        return Result.error(e);
      }
      return Result.error(
        AppException.unknown(
          message: '위젯 초기화 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}