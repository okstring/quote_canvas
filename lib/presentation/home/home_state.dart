import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/data/model/settings.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    required Quote currentQuote,
    required Settings settings,
    @Default(null) DateTime? lastUpdateTime,
  }) = _HomeState;
}
