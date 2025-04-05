import 'package:quote_canvas/data/model_class/quote.dart';

abstract interface class FileService {
  Future<List<Quote>> readKoreanQuotes();
}