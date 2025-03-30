import 'package:flutter/foundation.dart';

/// 로그 레벨 정의
enum LogLevel {
  info,
  warning,
  error;

}

/// 앱 로거 구현 클래스
class AppLogger {
  /// 싱글톤 인스턴스
  static final AppLogger _instance = AppLogger._internal();

  /// 팩토리 생성자
  factory AppLogger() => _instance;

  /// 내부 생성자
  AppLogger._internal();

  /// 현재 로그 레벨 (기본값: 디버그 모드에서는 모든 로그, 릴리즈 모드에서는 경고 이상)
  LogLevel _currentLevel = LogLevel.warning;

  /// 로그 태그 (기본값: "AppLogger")
  String _tag = "AppLogger";

  /// 로그 활성화 여부 (기본값: true)
  bool _enabled = true;

  /// 로그 레벨 설정
  void setLevel(LogLevel level) {
    _currentLevel = level;
  }

  /// 로그 태그 설정
  void setTag(String tag) {
    _tag = tag;
  }

  /// 로그 활성화/비활성화
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// 정보 로그
  void info(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.info,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 경고 로그
  void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.warning,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 에러 로그
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 내부 로그 출력 메소드
  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logTag = tag ?? _tag;
    final now = DateTime.now();
    final timeString =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}";

    String prefix;
    switch (level) {
      case LogLevel.info:
        prefix = '💡 I';
      case LogLevel.warning:
        prefix = '⚠️ W';
      case LogLevel.error:
        prefix = '❌ E';
    }

    final logMessage = "[$timeString] $prefix/$logTag: $message";

    // 디버그 콘솔에 출력
    debugPrint(logMessage);

    // 에러 및 스택트레이스가 있는 경우 추가 출력
    if (error != null) {
      debugPrint("[$timeString] $prefix/$logTag: Error: $error");
    }

    if (stackTrace != null) {
      debugPrint("[$timeString] $prefix/$logTag: StackTrace: $stackTrace");
    }
  }
}

final logger = AppLogger();
