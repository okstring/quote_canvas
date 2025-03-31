import 'http_client.dart';
import '../../../models/quote.dart';
import '../../../utils/result.dart';
import '../quote_service.dart';

class QuoteEndpoints {
  static const String random = '/quotes';
}

class QuoteServiceImpl implements QuoteService {
  final HttpClient _client;

  QuoteServiceImpl({required HttpClient client}) : _client = client;

  /// 여러 랜덤 명언 가져오기
  Future<Result<List<Quote>>> getRandomQuotes() async {
    return _client.get<List<Quote>>(
      path: QuoteEndpoints.random,
      decoder: (data) {
        final quotesJson = data as List;
        return quotesJson.map((json) => Quote.fromJson(json)).toList();
      },
    );
  }
}
