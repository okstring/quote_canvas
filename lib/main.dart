import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quote_canvas/core/di/di_container.dart';
import 'package:quote_canvas/core/routing/router/router.dart';
import 'package:quote_canvas/data/data_source/database/database_data_source_impl.dart';
import 'package:quote_canvas/data/model/enum/theme_mode_setting.dart';
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:quote_canvas/presentation/settings/settings_view_model.dart';
import 'package:quote_canvas/presentation/splash/splash_view_model.dart';
import 'package:quote_canvas/ui/app_theme.dart';
import 'package:quote_canvas/utils/logger.dart';

void main() async {
  // Flutter 바인딩 초기화 (데이터베이스 액세스 등 네이티브 코드를 호출하기 전에 필요)
  WidgetsFlutterBinding.ensureInitialized();

  logger.setTag('QuoteCanvas');

  MobileAds.instance.initialize();

  // 데이터베이스 인스턴스 초기화
  DatabaseDataSourceImpl();

  // 의존성 주입 setup
  await setupDependencies();

  // 가로모드 방지
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
  ]);

  // 유저 정보 초기화
  final settingsViewModel = getIt<SettingsViewModel>();
  await settingsViewModel.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<HomeViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<SplashViewModel>()),
        ChangeNotifierProvider(create: (_) => settingsViewModel),
      ],
      child: const QuoteCanvasApp(),
    ),
  );
}

class QuoteCanvasApp extends StatelessWidget {
  const QuoteCanvasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 설정에서 테마 모드 설정 값 가져오기
    final settingsViewModel = Provider.of<SettingsViewModel>(context);
    final themeMode = settingsViewModel.state.settings.themeMode;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      // 테마 설정
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      // 테마 모드 설정
      themeMode: _getThemeMode(themeMode),
    );
  }

  // 테마 모드 결정 함수
  ThemeMode _getThemeMode(ThemeModeSetting themeModeSetting) {
    switch (themeModeSetting) {
      case ThemeModeSetting.dark:
        return ThemeMode.dark;
      case ThemeModeSetting.light:
        return ThemeMode.light;
      case ThemeModeSetting.system:
        return ThemeMode.system;
    }
  }
}
