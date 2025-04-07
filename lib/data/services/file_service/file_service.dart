import 'package:quote_canvas/data/model_class/quote.dart';

abstract interface class FileService {
  /// assets/json_data/korean_quotes.json를 불러와 Quotes를 반환한다
  Future<List<Quote>> readKoreanQuotes();
}