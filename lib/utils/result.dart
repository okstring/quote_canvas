import 'package:quote_canvas/core/exceptions/app_exception.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success;

  const factory Result.failure(AppException error) = Failure;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  });

  Result<R> map<R>(R Function(T data) mapper) {
    return switch (this) {
      Success(data: final data) => Result.success(mapper(data)),
      Failure(error: final error) => Result.failure(error),
    };
  }

  /// 결과를 로그로 출력하는 메소드
  Result<T> log() {
    switch (this) {
      case Success(data: final data):
        print('Success: $data');
      case Failure(error: final error):
        print('Failure: ${error.message}');
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
  }) {
    return success(data);
  }
}

final class Failure<T> extends Result<T> {
  final AppException error;

  const Failure(this.error);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    return failure(error);
  }
}

