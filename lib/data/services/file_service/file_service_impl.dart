import 'dart:convert';

import 'package:quote_canvas/data/model_class/enum/quote_language.dart';
import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/data/services/file_service/file_service.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:flutter/services.dart' show rootBundle;

class FileServiceImpl implements FileService {
  final path = 'assets/json_data/korean_quotes.json';

  @override
  Future<List<Quote>> readKoreanQuotes() async {
    try {
      final String jsonString = await rootBundle.loadString(path);
      final List<dynamic> json = jsonDecode(jsonString);
      final quotes =
          json
              .map((json) => Quote.fromJson(json))
              .map((e) => e.copyWith(language: QuoteLanguage.korean))
              .toList();
      return quotes;
    } catch (e) {
      logger.error('korean 명언을 불러오는데 실패했습니다.');
      return [];
    }
  }
}
