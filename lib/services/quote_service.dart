import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quote_canvas/utils/extensions/http_response_extentions.dart';
import '../models/quote.dart';
import '../utils/result.dart';
import '../core/exceptions/app_exception.dart';

class QuoteService {
  final String baseUrl;
  final http.Client _client;

  QuoteService({
    this.baseUrl = 'https://api.quotable.io',
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<Result<Quote>> getRandomQuotes({int limit = 10}) async {
    final responseResult = await _get('$baseUrl/quotes/random', parameters: {'limit': limit});

    return responseResult.map(_parseQuote);
  }

  Future<Result<Map<String, dynamic>>> _get(String url, {Map<String, dynamic>? parameters = null}) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: parameters);
      final response = await _client.get(uri);

      if (response.isSuccess) {
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          return Result.success(json);
        } catch (e, stackTrace) {
          return Result.failure(
            AppException.parsing(
              message: '응답 데이터 파싱 중 오류가 발생했습니다.',
              error: e,
              stackTrace: stackTrace,
            ),
          );
        }
      }

      String errorMessage;
      if (response.isClientError) {
        errorMessage = '클라이언트 오류: ${response.statusCode}';
      } else if (response.isServerError) {
        errorMessage = '서버 오류: ${response.statusCode}';
      } else {
        errorMessage = '알 수 없는 HTTP 오류: ${response.statusCode}';
      }

      return Result.failure(
        AppException.api(
          message: errorMessage,
          statusCode: response.statusCode,
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(
        AppException.network(
          message: '네트워크 요청 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// 명언 데이터 파싱
  // Quote _parseQuote(Map<String, dynamic> json) {
  //   try {
  //     // API 응답 형식에 맞게 매핑 (실제 API에 따라 변경 필요)
  //     return Quote(
  //       id: json['_id'] ?? '',
  //       text: json['content'] ?? '',
  //       author: json['author'] ?? '',
  //       category: json['tags'] != null && (json['tags'] as List).isNotEmpty
  //           ? (json['tags'] as List).first.toString()
  //           : null,
  //       createdAt: json['dateAdded'] != null
  //           ? DateTime.parse(json['dateAdded'])
  //           : DateTime.now(),
  //     );
  //   } catch (e) {
  //     throw AppException.parsing(
  //       message: '명언 데이터 파싱 중 오류가 발생했습니다.',
  //       error: e,
  //     );
  //   }
  // }

  void dispose() {
    _client.close();
  }
}