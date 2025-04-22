import 'dart:typed_data';

import 'package:quote_canvas/data/dto/quote_dto.dart';

//TODO: Path_provider 적용
abstract interface class FileDataSource {
  /// assets/json_data/korean_quotes.json를 불러와 Quotes를 반환한다
  Future<List<QuoteDto>> readKoreanQuotes();

  Future<String> saveTempQuotePicture(Uint8List imageBytes);
}
