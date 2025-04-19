import 'package:quote_canvas/data/dto/settings_dto.dart';

abstract interface class SettingsDataSource {
  /// Settings를 가져온다
  Future<SettingsDto> getSettings();

  /// settings를 저장한다. 성공 여부는 bool로 반환한다.
  Future<bool> saveSettings(SettingsDto settings);
}
