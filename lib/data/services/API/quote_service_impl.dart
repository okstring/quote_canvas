import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/utils/logger.dart';

import 'client/http_client.dart';
import 'quote_service.dart';

class QuoteEndpoints {
  static const String random = '/quotes';
}

class QuoteServiceImpl implements QuoteService {
  final HttpClient _client;

  QuoteServiceImpl({required HttpClient client}) : _client = client;

  /// 여러 랜덤 명언 가져오기
  @override
  Future<List<Quote>> getRandomQuotes() async {
    try {
      return await _client.get<List<Quote>>(
        path: QuoteEndpoints.random,
        decoder: (data) {
          try {
            final quotesJson = data as List;
            return quotesJson.map((json) => Quote.fromJson(json)).toList();
          } catch (e, stackTrace) {
            logger.error('명언 데이터 파싱 중 오류 발생', error: e, stackTrace: stackTrace);
            throw AppException.parsing(
              message: '명언 데이터를 파싱하는 중 오류가 발생했습니다.',
              error: e,
              stackTrace: stackTrace,
            );
          }
        },
      );
    } catch (e, stackTrace) {
      // 그 외 예외는 네트워크 예외로 변환
      logger.error('명언 데이터 가져오기 실패', error: e, stackTrace: stackTrace);
      throw AppException.network(
        message: '명언 데이터를 가져오는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
