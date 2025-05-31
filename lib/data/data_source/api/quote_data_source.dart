import 'package:quote_canvas/data/dto/quote_dto.dart';

abstract interface class QuoteDataSource {
  /// 랜덤 명언 가져오기(20개)
  Future<List<QuoteDto>> getRandomQuotes();
}
