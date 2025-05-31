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

  const factory AppException.ad({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = AdException;

  String get userFriendlyMessage {
    switch (this) {
      case NetworkException():
        return 'There is a problem with the network connection. Please check your internet connection.';
      case ApiException(:final statusCode):
        if (statusCode != null) {
          if (statusCode >= 500) {
            return 'A temporary problem has occurred on the server. Please try again later.';
          } else if (statusCode == 401 || statusCode == 403) {
            return 'Authentication failed. Please log in again.';
          } else if (statusCode == 404) {
            return 'The requested information could not be found.';
          }
        }
        return 'An error occurred while communicating with the server.';
      case ParsingException():
        return 'An error occurred while processing data. Please update the app to the latest version.';
      case DatabaseException():
        return 'An error occurred while accessing the storage.';
      case SettingsException():
        return 'An error occurred while accessing the user storage.';
      case UnknownException():
      case DIException():
        return 'An unexpected error has occurred. Please restart the app.';
      case FileException():
        return 'An error occurred while loading data in the app. Please restart the app.';
      case ResultException():
        return 'An error occurred while processing data in the app. Please restart the app.';
      case UiException():
        return 'An error occurred while rendering the screen.';
      case AdException():
        return '광고 서비스에 일시적인 문제가 발생했습니다. 잠시 후 다시 시도해주세요.';
    }
  }
}