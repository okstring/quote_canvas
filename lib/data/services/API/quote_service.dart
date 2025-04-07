import 'package:quote_canvas/data/model_class/quote.dart';


abstract interface class QuoteService {
  /// 랜덤 명언 가져오기(20개)
  Future<List<Quote>> getRandomQuotes();
}