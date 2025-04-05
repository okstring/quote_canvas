// 네트워크 설정 클래스
class NetworkConfig {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> defaultHeaders;

  const NetworkConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });
}