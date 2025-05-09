import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_canvas/data/model/enum/theme_mode_setting.dart';

part 'settings_action.freezed.dart';

@freezed
sealed class SettingsAction with _$SettingsAction {
  const factory SettingsAction.deleteAllQuotes() = DeleteAllQuotes;
  const factory SettingsAction.updateThemeMode({
    required ThemeModeSetting themeMode,
  }) = UpdateThemeMode;
}
