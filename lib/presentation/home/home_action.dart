import 'dart:typed_data';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_canvas/data/model/quote.dart';

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

  const factory HomeAction.updatePhotoPermissionStatus({
    required bool hasAsked,
  }) = UpdatePhotoPermissionStatus;

  const factory HomeAction.onTapBackgroundColorSelect({
    required Color color,
  }) = OnTapBackgroundColorSelect;

  const factory HomeAction.onTapFontColorSelect({
    required Color color,
  }) = OnTapFontColorSelect;

  const factory HomeAction.onTapFavoriteQuote({
    required Quote quote,
  }) = OnTapFavoriteQuote;
}
