import '../result.dart';
import '../../core/exceptions/app_exception.dart';

extension FutureExtensions<T> on Future<T> {
  Future<Result<T, AppException>> toResult({
    String errorMessage = '작업을 수행하는 중 오류가 발생했습니다.',
    AppException Function(String message, Object? error, StackTrace stackTrace)?
    exceptionFactory,
  }) async {
    try {
      final data = await this;
      return Result.success(data);
    } catch (e, stackTrace) {
      final factory =
          exceptionFactory ??
          ((message, error, stackTrace) => AppException.unknown(
            message: message,
            error: error,
            stackTrace: stackTrace,
          ));

      return Result.error(factory(errorMessage, e, stackTrace));
    }
  }

  Future<Result<T, AppException>> toNetworkResult([String? errorMessage]) => toResult(
    errorMessage: errorMessage ?? '네트워크 요청 중 오류가 발생했습니다.',
    exceptionFactory:
        (msg, err, stack) =>
            AppException.network(message: msg, error: err, stackTrace: stack),
  );

  Future<Result<T, AppException>> toDatabaseResult([String? errorMessage]) => toResult(
    errorMessage: errorMessage ?? '데이터베이스 작업 중 오류가 발생했습니다.',
    exceptionFactory:
        (msg, err, stack) =>
            AppException.database(message: msg, error: err, stackTrace: stack),
  );

  Future<Result<T, AppException>> toApiResult({String? errorMessage, int? statusCode}) =>
      toResult(
        errorMessage: errorMessage ?? 'API 요청 중 오류가 발생했습니다.',
        exceptionFactory:
            (msg, err, stack) => AppException.api(
              message: msg,
              statusCode: statusCode,
              error: err,
              stackTrace: stack,
            ),
      );

  Future<Result<T, AppException>> toParsingResult([String? errorMessage]) => toResult(
    errorMessage: errorMessage ?? '데이터 처리 중 오류가 발생했습니다.',
    exceptionFactory:
        (msg, err, stack) =>
            AppException.parsing(message: msg, error: err, stackTrace: stack),
  );
}
