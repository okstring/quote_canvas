import 'package:quote_canvas/data/model/settings.dart';
import 'package:quote_canvas/utils/result.dart';

abstract interface class SettingsRepository {
  /// 유저 설정 가져오기
  Future<Result<Settings>> getSettings();

  /// 유저 설정 저장하기
  Future<Result<bool>> saveSettings(Settings settings);
}
