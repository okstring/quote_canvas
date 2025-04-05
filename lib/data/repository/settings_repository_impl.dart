import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/model_class/settings.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/data/services/shared_preferences/settings_service.dart';
import 'package:quote_canvas/utils/result.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsService _settingsService;

  SettingsRepositoryImpl(this._settingsService);

  @override
  Future<Result<Settings>> getSettings() async {
    try {
      final settings = await _settingsService.getSettings();
      return Result.success(settings);
    } catch (e, stackTrace) {
      return Result.failure(
        AppException.settings(
          message: '유저 설정을 불러오는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<bool>> saveSettings(Settings settings) async {
    try {
      final result = await _settingsService.saveSettings(settings);
      return Result.success(result);
    } catch (e, stackTrace) {
      return Result.failure(
        AppException.settings(
          message: '유저 설정을 저장하는 중 오류가 발생했습니다.',
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}