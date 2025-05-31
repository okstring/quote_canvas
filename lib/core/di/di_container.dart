import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:quote_canvas/data/data_source/API/client/http_client.dart';
import 'package:quote_canvas/data/data_source/API/client/network_config.dart';
import 'package:quote_canvas/data/data_source/API/quote_data_source.dart';
import 'package:quote_canvas/data/data_source/API/quote_data_source_impl.dart';
import 'package:quote_canvas/data/data_source/database/database_data_source.dart';
import 'package:quote_canvas/data/data_source/database/database_data_source_impl.dart';
import 'package:quote_canvas/data/data_source/file_service/file_data_source.dart';
import 'package:quote_canvas/data/data_source/file_service/file_data_source_impl.dart';
import 'package:quote_canvas/data/data_source/package_info/package_info_data_source.dart';
import 'package:quote_canvas/data/data_source/package_info/package_info_data_source_impl.dart';
import 'package:quote_canvas/data/data_source/shared_preferences/settings_data_source.dart';
import 'package:quote_canvas/data/data_source/shared_preferences/settings_data_source_impl.dart';
import 'package:quote_canvas/data/model/quote.dart';
import 'package:quote_canvas/data/model/settings.dart';
import 'package:quote_canvas/data/repository/file_repository.dart';
import 'package:quote_canvas/data/repository/file_repository_impl.dart';
import 'package:quote_canvas/data/repository/package_info_repository.dart';
import 'package:quote_canvas/data/repository/package_info_repository_impl.dart';
import 'package:quote_canvas/data/data_source/ad/ad_data_source.dart';
import 'package:quote_canvas/data/data_source/ad/ad_data_source_impl.dart';
import 'package:quote_canvas/data/repository/ad_repository.dart';
import 'package:quote_canvas/data/repository/ad_repository_impl.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/repository/quote_repository_impl.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/data/repository/settings_repository_impl.dart';
import 'package:quote_canvas/presentation/home/home_state.dart';
import 'package:quote_canvas/presentation/home/home_view_model.dart';
import 'package:quote_canvas/presentation/settings/settings_state.dart';
import 'package:quote_canvas/presentation/settings/settings_view_model.dart';
import 'package:quote_canvas/presentation/splash/splash_view_model.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

/// 앱의 의존성 주입을 설정
Future<void> setupDependencies() async {
  try {
    //===== 외부 서비스 및 라이브러리 초기화 =====
    // SharedPreferences 초기화
    final SharedPreferencesAsync sharedPreferencesAsync =
        await SharedPreferencesAsync();
    getIt.registerSingleton<SharedPreferencesAsync>(sharedPreferencesAsync);

    //===== 서비스 레이어 등록 =====
    // SettingsService
    getIt.registerSingleton<SettingsDataSource>(
      SettingsDataSourceImpl(sharedPreferencesAsync),
    );

    // HTTP 클라이언트 및 네트워크 설정
    final httpClient = http.Client();
    getIt.registerSingleton<http.Client>(httpClient);

    const networkConfig = NetworkConfig(baseUrl: 'https://zenquotes.io/api');
    getIt.registerSingleton<NetworkConfig>(networkConfig);

    final HttpClient httpClientWrapper = HttpClient(
      config: networkConfig,
      client: httpClient,
    );
    getIt.registerSingleton<HttpClient>(httpClientWrapper);

    // 데이터베이스 서비스
    getIt.registerSingleton<DatabaseDataSource>(
      DatabaseDataSourceImpl() as DatabaseDataSource,
    );

    // Quote 서비스
    getIt.registerSingleton<QuoteDataSource>(
      QuoteDataSourceImpl(client: httpClientWrapper),
    );

    // 파일 서비스
    getIt.registerSingleton<FileDataSource>(FileDataSourceImpl());

    // Package Info 서비스
    getIt.registerSingleton<PackageInfoDataSource>(PackageInfoDataSourceImpl());

    // 광고 서비스
    getIt.registerSingleton<AdDataSource>(AdDataSourceImpl());

    //===== 리포지토리 레이어 등록 =====
    // 설정 리포지토리
    getIt.registerSingleton<SettingsRepository>(
      SettingsRepositoryImpl(getIt<SettingsDataSource>()),
    );

    // Quote 리포지토리
    getIt.registerSingleton<QuoteRepository>(
      QuoteRepositoryImpl(
        quoteDataSource: getIt<QuoteDataSource>(),
        databaseDataSource: getIt<DatabaseDataSource>(),
        fileDataSource: getIt<FileDataSource>(),
      ),
    );

    // File 리포지토리
    getIt.registerSingleton<FileRepository>(
      FileRepositoryImpl(fileDataSource: getIt<FileDataSource>()),
    );

    getIt.registerSingleton<PackageInfoRepository>(
      PackageInfoRepositoryImpl(
        packageInfoDataSource: getIt<PackageInfoDataSource>(),
      ),
    );

    // 광고 리포지토리
    getIt.registerSingleton<AdRepository>(
      AdRepositoryImpl(adDataSource: getIt<AdDataSource>()),
    );

    //===== 뷰모델 등록 =====
    // SplashViewModel
    getIt.registerFactory<SplashViewModel>(() => SplashViewModel());

    // HomeViewModel
    getIt.registerFactory<HomeViewModel>(() {
      final settingsRepository = getIt<SettingsRepository>();
      final quoteRepository = getIt<QuoteRepository>();
      final fileRepository = getIt<FileRepository>();
      final adRepository = getIt<AdRepository>(); // 추가

      final quote = Quote.empty();
      final settings = Settings.defaultSettings();

      return HomeViewModel(
        quoteRepository: quoteRepository,
        settingsRepository: settingsRepository,
        fileRepository: fileRepository,
        adRepository: adRepository, // 추가
        state: HomeState(currentQuote: quote, settings: settings),
      );
    });

    // HomeViewModel
    getIt.registerFactory<SettingsViewModel>(() {
      final settingsRepository = getIt<SettingsRepository>();
      final quoteRepository = getIt<QuoteRepository>();
      final settings = Settings.defaultSettings();
      final state = SettingsState(settings: settings);

      return SettingsViewModel(
        quoteRepository: quoteRepository,
        settingsRepository: settingsRepository,
        state: state,
        packageInfoRepository: getIt<PackageInfoRepository>(),
      );
    });
  } catch (e, stackTrace) {
    logger.error('의존성 설정 중 오류 발생: $e', error: e, stackTrace: stackTrace);
    rethrow;
  }
}
