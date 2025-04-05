import 'package:flutter/foundation.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/data/model_class/settings.dart';
import 'package:quote_canvas/utils/logger.dart';

class SplashViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Settings? _settings;

  Settings? get settings => _settings;

  SplashViewModel({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  Future<void> initialize() async {
    try {
      _setLoading(true);

      // 설정 로드
      final settingsResult = await _settingsRepository.getSettings();

      settingsResult.whenCompleteAsync(
        success: (settings) async {
          _settings = settings;
          _errorMessage = null;
          logger.info('설정 로드 성공: $settings');
        },
        failure: (_) async {
          _saveFirstSettings();
        },
        onComplete: () async {
          if (_settings?.isAppFirstLaunch ?? false) {
            // TODO: 앱 최초 실행 시 한글 명언 가져오기
          }
        },
      );

      // 1.5초 후 앱 초기화 완료
      await Future.delayed(const Duration(milliseconds: 1500));

      _isInitialized = true;
    } catch (e, stackTrace) {
      _errorMessage = '앱 초기화 중 오류가 발생했습니다.';
      logger.error('앱 초기화 중 오류', error: e, stackTrace: stackTrace);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveFirstSettings() async {
    final firstSettings = Settings();
    _settings = firstSettings;

    final firstSettingsResults = await _settingsRepository.saveSettings(
      firstSettings,
    );

    firstSettingsResults.when(
      success: (success) {
        logger.info('설정 로드 실패: 초기 settings으로 설정됩니다. $firstSettings');
      },
      failure: (error) {
        _errorMessage = error.userFriendlyMessage;
        logger.error('초기 설정 저장 실패: ${error.message}');
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
