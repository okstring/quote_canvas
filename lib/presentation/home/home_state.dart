import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/data/model/settings.dart';
import 'package:quote_canvas/ui/app_colors.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default(null) String? quoteFetchErrorMessage,
    required Quote currentQuote,
    required Settings settings,
    @Default(null) DateTime? lastUpdateTime,
    @Default(AppColors.teal40) Color quoteBackgroundColor,
  }) = _HomeState;
}

extension HomeStateExtension on HomeState {
  String get shareText => '${currentQuote.content} - ${currentQuote.author}';

  String get shareTitle => 'Quote Canvas';
}
