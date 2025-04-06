import 'package:flutter/foundation.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/data/model_class/settings.dart';
import 'package:quote_canvas/ui/manager/app_settings_manager.dart';
import 'package:quote_canvas/utils/logger.dart';

class SplashViewModel extends ChangeNotifier {
  final AppSettingsManager _appSettingsManager;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  SplashViewModel({required AppSettingsManager appSettingsManager})
    : _appSettingsManager = appSettingsManager {
    _appSettingsManager.settingsNotifier.addListener(_handleAppSettingsChange);
    _appSettingsManager.errorNotifier.addListener(_handleAppSettingsError);
  }

  void _handleAppSettingsChange() {
    if (_appSettingsManager.currentSettings.isAppFirstLaunch) {

    }
    notifyListeners();
  }

  void _handleAppSettingsError() {
    _errorMessage = _appSettingsManager.currentError;
    notifyListeners();
  }



  Future<void> initialize() async {
    _setLoading(true);
    // 1.5초 후 앱 초기화 완료
    await Future.delayed(const Duration(milliseconds: 1500));
    _isInitialized = true;
    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
