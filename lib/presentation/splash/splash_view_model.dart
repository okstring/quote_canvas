import 'package:flutter/foundation.dart';
import 'package:quote_canvas/presentation/splash/splash_state.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel();

  SplashState _state = const SplashState();
  SplashState get state => _state;

  Future<void> initialize(void Function() completion) async {
    _state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 1500));
    _state = state.copyWith(isLoading: false, isInitialized: true);
    completion();
  }
}