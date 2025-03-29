import 'package:http/http.dart' as http;

extension HttpResponseExtension on http.Response {
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  bool get isClientError => statusCode >= 400 && statusCode < 500;

  bool get isServerError => statusCode >= 500;
}