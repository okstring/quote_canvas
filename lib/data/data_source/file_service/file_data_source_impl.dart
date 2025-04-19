import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/data_source/file_service/file_data_source.dart';
import 'package:quote_canvas/data/dto/quote_dto.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';
import 'package:quote_canvas/utils/logger.dart';

class FileDataSourceImpl implements FileDataSource {
  final String path = 'assets/json_data/korean_quotes.json';

  @override
  Future<List<QuoteDto>> readKoreanQuotes() async {
    try {
      final String jsonString = await rootBundle.loadString(path);

      try {
        final List<dynamic> json = jsonDecode(jsonString);

        // 한국 명언 분류
        final quoteDtos =
            json
                .map((json) => QuoteDto.fromJson(json))
                .map((e) => e.copyWith(language: QuoteLanguage.korean.name))
                .toList();

        logger.info('한국어 명언 ${quoteDtos.length}개를 성공적으로 로드했습니다.');
        return quoteDtos;
      } catch (e, stackTrace) {
        logger.error('한국어 명언 JSON 파싱 실패', error: e, stackTrace: stackTrace);
        throw AppException.parsing(
          message: '한국어 명언 데이터를 파싱하는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        );
      }
    } catch (e, stackTrace) {
      logger.error('한국어 명언 파일 로드 실패', error: e, stackTrace: stackTrace);
      throw AppException.unknown(
        message: '한국어 명언 파일을 로드하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
