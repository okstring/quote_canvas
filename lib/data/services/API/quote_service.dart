import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/utils/result.dart';


abstract interface class QuoteService {
  Future<Result<List<Quote>>> getRandomQuotes();
}