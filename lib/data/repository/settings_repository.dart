import 'package:quote_canvas/data/model_class/settings.dart';
import 'package:quote_canvas/utils/result.dart';

abstract interface class SettingsRepository {
  Future<Result<Settings>> getSettings();

  Future<Result<bool>> saveSettings(Settings settings);
}
