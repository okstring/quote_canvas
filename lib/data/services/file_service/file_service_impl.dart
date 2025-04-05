import 'dart:convert';
import 'dart:io';

import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/data/services/file_service/file_service.dart';
import 'package:quote_canvas/utils/logger.dart';

// TODO: result로 반환해야 함
class FileServiceImpl implements FileService {
  final path = 'assets/json_data/korean_quotes.json';
  @override
  Future<List<Quote>> readKoreanQuotes() async {
    final file = File(path);

    if (await file.exists()) {
      final String jsonString = await file.readAsString();
      final List<dynamic> json = jsonDecode(jsonString);
      final quotes = json.map((json) => Quote.fromJson(json)).toList();
      return quotes;
    } else {
      logger.error('korean 명언을 불러오는데 실패했습니다.');
      return [];
    }
  }
}