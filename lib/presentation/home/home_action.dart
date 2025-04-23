import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_action.freezed.dart';

@freezed
sealed class HomeAction with _$HomeAction {
  const factory HomeAction.reloadQuote() = ReloadQuote;

  const factory HomeAction.onTapQInteractiveBookmarkButton() =
      OnTapQInteractiveBookmarkButton;

  const factory HomeAction.readyToErrorMessage({
    required String message,
    Object? error,
    StackTrace? stacktrace,
  }) = ReadyErrorMessage;

  const factory HomeAction.readyToSnackBarMessage({
    required String message,
    Object? error,
    StackTrace? stacktrace,
  }) = ReadyToSnackBarMessage;

  const factory HomeAction.prepareQuoteImageForSharing({
    required Uint8List pngBytes,
  }) = PrepareQuoteImageForSharing;
}
