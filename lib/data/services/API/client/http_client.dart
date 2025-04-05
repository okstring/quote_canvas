import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/services/API/client/http_method.dart';
import 'package:quote_canvas/data/services/API/client/network_config.dart';
import 'package:quote_canvas/utils/extensions/http_response_extentions.dart';
import 'package:quote_canvas/utils/result.dart';

// HTTP 클라이언트
class HttpClient {
  final NetworkConfig config;
  final http.Client _client;

  HttpClient({required this.config, http.Client? client})
    : _client = client ?? http.Client();

  // GET 요청
  Future<Result<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic data)? decoder,
  }) async {
    return _request<T>(
      method: HttpMethod.get,
      path: path,
      queryParams: queryParams,
      headers: headers,
      decoder: decoder,
    );
  }

  // POST 요청
  Future<Result<T>> post<T>({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic data)? decoder,
  }) async {
    return _request<T>(
      method: HttpMethod.post,
      path: path,
      body: body,
      queryParams: queryParams,
      headers: headers,
      decoder: decoder,
    );
  }

  // 공통 request 처리 메소드
  Future<Result<T>> _request<T>({
    required HttpMethod method,
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final uri = _buildUri(path, queryParams);
      final mergedHeaders = {...config.defaultHeaders, ...?headers};
      final bodyData = body != null ? json.encode(body) : null;

      final response = await _sendRequest(
        method: method,
        uri: uri,
        headers: mergedHeaders,
        body: bodyData,
      ).timeout(config.timeout);

      return _handleResponse<T>(response, decoder);
    } catch (e, stackTrace) {
      if (e is http.ClientException) {
        return Result.failure(
          AppException.network(
            message: '네트워크 요청 실패: ${e.message}',
            error: e,
            stackTrace: stackTrace,
          ),
        );
      }
      return Result.failure(
        AppException.unknown(
          message: '알 수 없는 네트워크 요청 실패: $e',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // URI 생성 메소드
  Uri _buildUri(String path, Map<String, dynamic>? queryParams) {
    final baseUri = Uri.parse(config.baseUrl);
    final pathSegments = [
      ...baseUri.pathSegments,
      ...path.split('/').where((s) => s.isNotEmpty),
    ];

    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port,
      pathSegments: pathSegments,
      queryParameters: queryParams,
    );
  }

  // HTTP 요청 전송 메소드
  Future<http.Response> _sendRequest({
    required HttpMethod method,
    required Uri uri,
    required Map<String, String> headers,
    String? body,
  }) async {
    switch (method) {
      case HttpMethod.get:
        return _client.get(uri, headers: headers);
      case HttpMethod.post:
        return _client.post(uri, headers: headers, body: body);
    }
  }

  // 응답 처리 메소드
  Result<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic data)? decoder,
  ) {
    final body = response.body;
    final statusCode = response.statusCode;

    if (response.isSuccess) {
      final jsonData = json.decode(body);

      if (decoder != null) {
        return Result.success(decoder(jsonData));
      }

      // 반환 타입이 dynamic이거나 Map, List 등인 경우
      if (T == dynamic || jsonData is T) {
        return Result.success(jsonData as T);
      }

      return Result.failure(
        AppException.parsing(message: '해당 타입에 대한 디코더가 제공되지 않습니다: $T'),
      );
    } else {
      return Result.failure(
        AppException.api(message: 'API 에러: $body', statusCode: statusCode),
      );
    }
  }

  void close() {
    _client.close();
  }
}
