import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
sealed class AppException with _$AppException implements Exception {
  const AppException._();

  const factory AppException.network({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = NetworkException;

  const factory AppException.api({
    required String message,
    int? statusCode,
    Object? error,
    StackTrace? stackTrace,
  }) = ApiException;

  const factory AppException.parsing({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = ParsingException;

  const factory AppException.database({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = DatabaseException;

  const factory AppException.settings({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = SettingsException;

  const factory AppException.unknown({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = UnknownException;

  const factory AppException.di({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = DIException;

  const factory AppException.file({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = FileException;

  const factory AppException.result({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = ResultException;

  const factory AppException.ui({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = UiException;

  String get userFriendlyMessage {
    switch (this) {
      case NetworkException():
        return '네트워크 연결에 문제가 있습니다. 인터넷 연결을 확인해주세요.';
      case ApiException(:final statusCode):
        if (statusCode != null) {
          if (statusCode >= 500) {
            return '서버에 일시적인 문제가 발생했습니다. 잠시 후 다시 시도해주세요.';
          } else if (statusCode == 401 || statusCode == 403) {
            return '인증에 실패했습니다. 다시 로그인해주세요.';
          } else if (statusCode == 404) {
            return '요청한 정보를 찾을 수 없습니다.';
          }
        }
        return '서버와 통신 중 오류가 발생했습니다.';
      case ParsingException():
        return '데이터 처리 중 오류가 발생했습니다. 앱을 최신 버전으로 업데이트해주세요.';
      case DatabaseException():
        return '저장소에 접근하는 중 오류가 발생했습니다.';
      case SettingsException():
        return '유저 저장소에 접근하는 중 오류가 발생했습니다.';
      case UnknownException():
      case DIException():
        return '예상치 못한 오류가 발생했습니다. 앱을 다시 시작해주세요.';
      case FileException():
        return '앱 내 데이터를 불러오는 중 오류가 발생했습니다. 앱을 다시 시작해주세요.';
      case ResultException():
        return '앱 내 데이터를 처리하는 중 오류가 발생했습니다. 앱을 다시 시작해주세요.';
      case UiException():
        return '화면을 그리던 중 오류가 났습니다.';
    }
  }
}