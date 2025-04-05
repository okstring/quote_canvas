import 'package:quote_canvas/data/model_class/settings.dart';

abstract interface class SettingsService {
  Future<Settings> getSettings();
  Future<bool> saveSettings(Settings settings);
}