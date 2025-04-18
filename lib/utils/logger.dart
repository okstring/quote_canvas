import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error }

final logger = AppLogger();

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() => _instance;

  AppLogger._internal();

  String _tag = "AppLogger";

  void setTag(String tag) {
    _tag = tag;
  }

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

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logTag = tag ?? _tag;
    final now = DateTime.now();

    /// 시간 문자열 생성('14:05:23.045')
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
