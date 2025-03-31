import '../../models/quote.dart';
import '../../utils/result.dart';

abstract interface class QuoteService {
  Future<Result<List<Quote>>> getRandomQuotes();
}