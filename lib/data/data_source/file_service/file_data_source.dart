import 'package:quote_canvas/data/dto/quote_dto.dart';

abstract interface class FileDataSource {
  /// assets/json_data/korean_quotes.json를 불러와 Quotes를 반환한다
  Future<List<QuoteDto>> readKoreanQuotes();
}
