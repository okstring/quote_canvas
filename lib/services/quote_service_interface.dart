import '../models/quote.dart';
import '../utils/result.dart';

abstract class QuoteServiceInterface {
  Future<Result<List<Quote>>> getRandomQuotes({int limit = 20});
}