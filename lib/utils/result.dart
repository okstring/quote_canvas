import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/utils/logger.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success;

  const factory Result.failure(AppException error) = Failure;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  // 동기 버전의 when
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
    void Function()? onComplete,
  });

  // 비동기 버전의 whenAsync
  Future<R>? whenAsync<R>({
    required Future<R> Function(T data) success,
    required Future<R> Function(AppException error) failure,
    Future<void> Function()? onComplete,
  }) async {
    try {
      return await when<Future<R>>(
        success: (data) => success(data),
        failure: (error) => failure(error),
        onComplete: null,
      );
    } finally {
      if (onComplete != null) {
        await onComplete();
      }
    }
  }

  Result<R> map<R>(R Function(T data) mapper) {
    return switch (this) {
      Success(data: final data) => Result.success(mapper(data)),
      Failure(error: final error) => Result.failure(error),
    };
  }

  /// 결과를 로그로 출력하는 메소드
  Result<T> log({String? tag}) {
    switch (this) {
      case Success(data: final data):
        logger.info('Success: $data', tag: tag);
      case Failure(error: final error):
        logger.error(
          'Failure: ${error.message}',
          tag: tag,
          error: error.error,
          stackTrace: error.stackTrace,
        );
    }
    return this;
  }
}

final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
    void Function()? onComplete,
  }) {
    try {
      return success(data);
    } finally {
      onComplete ?? (() => null)();
    }
  }
}

final class Failure<T> extends Result<T> {
  final AppException error;

  const Failure(this.error);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
    void Function()? onComplete,
  }) {
    try {
      return failure(error);
    } finally {
      onComplete ?? (() => null)();
    }
  }
}