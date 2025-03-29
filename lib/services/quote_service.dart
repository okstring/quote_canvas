import '../core/network/http_client.dart';
import '../models/quote.dart';
import '../utils/result.dart';

class QuoteEndpoints {
  static const String random = '/quotes/random';
}

class QuoteService {
  final HttpClient _client;

  QuoteService({required HttpClient client}) : _client = client;


  /// 여러 명언 가져오기
  Future<Result<List<Quote>>> getQuotes({
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};

    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    return _client.get<List<Quote>>(
      path: QuoteEndpoints.random,
      queryParams: queryParams,
      decoder: (data) {
        final quotesJson = data as List;
        return quotesJson.map((json) => Quote.fromJson(json)).toList();
      },
    );
  }
}