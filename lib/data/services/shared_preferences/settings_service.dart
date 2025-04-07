import 'package:quote_canvas/data/model_class/settings.dart';

abstract interface class SettingsService {
  /// Settings를 가져온다
  Future<Settings> getSettings();

  /// settings를 저장한다. 성공 여부는 bool로 반환한다.
  Future<bool> saveSettings(Settings settings);
}
