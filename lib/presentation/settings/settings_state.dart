import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_canvas/data/model/settings.dart';

part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isLoading,
    required Settings settings,
    @Default('0.0.0') String appVersion,
  }) = _SettingsState;
}
