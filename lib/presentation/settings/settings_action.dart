import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_action.freezed.dart';

@freezed
sealed class SettingsAction with _$SettingsAction {
  const factory SettingsAction.onTap() = OnTap;
}