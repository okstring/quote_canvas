import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/data_source/shared_preferences/settings_data_source.dart';
import 'package:quote_canvas/data/dto_mapper/settings_dto_mapper.dart';
import 'package:quote_canvas/data/model/settings.dart';
import 'package:quote_canvas/data/model_mapper/settings_mapper.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/utils/result.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource _settingsDataSource;

  SettingsRepositoryImpl(this._settingsDataSource);

  @override
  Future<Result<Settings>> getSettings() async {
    try {
      final settingsDto = await _settingsDataSource.getSettings();
      final settings = settingsDto.toModel();
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
      final settingsDto = settings.toDto();
      final result = await _settingsDataSource.saveSettings(settingsDto);
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
