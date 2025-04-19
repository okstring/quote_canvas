import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/data_source/API/client/http_method.dart';
import 'package:quote_canvas/data/data_source/API/client/network_config.dart';
import 'package:quote_canvas/utils/extensions/http_response_extentions.dart';

// Custom HTTP 클라이언트
class HttpClient {
  final NetworkConfig config;
  final http.Client _client;

  HttpClient({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  // GET 요청
  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    required T Function(dynamic data) decoder,
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
  Future<T> post<T>({
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    required T Function(dynamic data) decoder,
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
  Future<T> _request<T>({
    required HttpMethod method,
    required String path,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    required T Function(dynamic data) decoder,
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

      if (!response.isSuccess) {
        _handleErrorResponse(response);
      }

      final jsonData = json.decode(response.body);
      return decoder(jsonData);
    } catch (e, stackTrace) {
      if (e is http.ClientException) {
        throw AppException.network(
          message: '네트워크 요청 실패: ${e.message}',
          error: e,
          stackTrace: stackTrace,
        );
      }

      if (e is AppException) {
        throw e;
      }

      throw AppException.unknown(
        message: '알 수 없는 네트워크 요청 실패: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 에러 응답 처리
  void _handleErrorResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    throw AppException.api(
        message: 'API 에러: $body',
        statusCode: statusCode
    );
  }

  // URI 생성 메소드
  // 일관성: 모든 API 요청에서 일관된 URL 형식을 보장
  // 경로 정규화: 중복 슬래시나 빈 세그먼트를 제거
  Uri _buildUri(String path, Map<String, dynamic>? queryParams) {
    final baseUri = Uri.parse(config.baseUrl);
    // pathSegments 찾기
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

  void close() {
    _client.close();
  }
}