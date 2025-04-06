import 'package:quote_canvas/data/model_class/quote.dart';


abstract interface class QuoteService {
  Future<List<Quote>> getRandomQuotes();
}