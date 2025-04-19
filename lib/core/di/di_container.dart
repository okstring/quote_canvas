import 'package:http/http.dart' as http;
import 'package:quote_canvas/data/data_source/API/client/http_client.dart';
import 'package:quote_canvas/ui/view_models/home_view_model.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/data/repository/quote_repository.dart';
import 'package:quote_canvas/data/repository/quote_repository_impl.dart';
import 'package:quote_canvas/data/repository/settings_repository.dart';
import 'package:quote_canvas/data/repository/settings_repository_impl.dart';
import 'package:quote_canvas/data/data_source/API/client/network_config.dart';
import 'package:quote_canvas/data/data_source/API/quote_data_source.dart';
import 'package:quote_canvas/data/data_source/API/quote_data_source_impl.dart';
import 'package:quote_canvas/data/data_source/database/database_data_source.dart';
import 'package:quote_canvas/data/data_source/database/database_data_source_impl.dart';
import 'package:quote_canvas/data/data_source/file_service/file_data_source.dart';
import 'package:quote_canvas/data/data_source/file_service/file_data_source_impl.dart';
import 'package:quote_canvas/data/data_source/shared_preferences/settings_data_source.dart';
import 'package:quote_canvas/data/data_source/shared_preferences/settings_data_source_impl.dart';
import 'package:quote_canvas/ui/manager/app_settings_manager.dart';
import 'package:quote_canvas/ui/view_models/splash_view_model.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DIContainer {
  static final DIContainer _instance = DIContainer._internal();

  factory DIContainer() => _instance;

  DIContainer._internal();

  final Map<Type, Object> _singletons = {};
  final Map<Type, Function> _factories = {};

  // 싱글톤 인스턴스를 등록하는 메서드
  void registerSingleton<T extends Object>(T instance) {
    _singletons[T] = instance;
  }

  // 팩토리 함수를 등록하는 메서드
  void registerFactory<T extends Object>(T Function() factoryFunc) {
    _factories[T] = factoryFunc;
  }

  T? get<T extends Object>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }

    // 팩토리 함수가 등록되어 있으면 호출하여 인스턴스 생성 후 반환
    if (_factories.containsKey(T)) {
      return (_factories[T] as Function)() as T;
    }

    logger.error('객체가 등록되어 있지 않습니다. DI Container를 확인해주세요');
    return null;
  }

  // DI 생성 시 null 값을 반환하지 않는다.
  T getRequired<T extends Object>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }

    if (_factories.containsKey(T)) {
      return (_factories[T] as Function)() as T;
    }

    throw AppException.di(message: '의존성 $T가 등록되어 있지 않습니다.');
  }

  // 등록된 모든 싱글톤 인스턴스를 초기화하는 메서드
  void reset() {
    _singletons.clear();
    _factories.clear();
  }
}

final serviceLocator = DIContainer();

/// 앱의 의존성 주입을 설정
Future<void> setupDependencies() async {
  //===== 외부 서비스 및 라이브러리 초기화 =====
  // SharedPreferences 초기화
  final SharedPreferencesAsync sharedPreferencesAsync =
  await SharedPreferencesAsync();
  serviceLocator.registerSingleton<SharedPreferencesAsync>(
    sharedPreferencesAsync,
  );

  //===== 서비스 레이어 등록 =====
  // SettingsService
  final settingsService = SettingsDataSourceImpl(sharedPreferencesAsync);
  serviceLocator.registerSingleton<SettingsDataSource>(settingsService);

  // HTTP 클라이언트 및 네트워크 설정
  final httpClient = http.Client();
  serviceLocator.registerSingleton<http.Client>(httpClient);

  const networkConfig = NetworkConfig(baseUrl: 'https://zenquotes.io/api');
  serviceLocator.registerSingleton<NetworkConfig>(networkConfig);

  final HttpClient httpClientWrapper = HttpClient(
    config: networkConfig,
    client: httpClient,
  );
  serviceLocator.registerSingleton<HttpClient>(httpClientWrapper);

  // 데이터베이스 서비스
  serviceLocator.registerSingleton<DatabaseDataSource>(
    DatabaseDataSourceImpl() as DatabaseDataSource,
  );

  // Quote 서비스
  final QuoteDataSource quoteService = QuoteDataSourceImpl(client: httpClientWrapper);
  serviceLocator.registerSingleton<QuoteDataSource>(quoteService);

  // 파일 서비스
  final FileDataSource fileService = FileDataSourceImpl();
  serviceLocator.registerSingleton<FileDataSource>(fileService);

  //===== 리포지토리 레이어 등록 =====
  // 설정 리포지토리
  final SettingsRepository settingsRepository = SettingsRepositoryImpl(settingsService);
  serviceLocator.registerSingleton<SettingsRepository>(settingsRepository);

  // Quote 리포지토리
  final QuoteRepository quoteRepository = QuoteRepositoryImpl(
    quoteDataSource: quoteService,
    databaseDataSource: DatabaseDataSourceImpl(),
    fileDataSource: fileService,
  );
  serviceLocator.registerSingleton<QuoteRepository>(quoteRepository);

  //===== 매니저 등록 =====
  final AppSettingsManager appSettingsManager = AppSettingsManager(
    settingsRepository,
  );
  serviceLocator.registerSingleton<AppSettingsManager>(appSettingsManager);

  //===== 뷰모델 등록 =====
  // SplashViewModel
  serviceLocator.registerFactory<SplashViewModel>(
        () => SplashViewModel(appSettingsManager: appSettingsManager),
  );

  // HomeViewModel
  serviceLocator.registerFactory<HomeViewModel>(
        () => HomeViewModel(
      quoteRepository: quoteRepository,
      appSettingsManager: appSettingsManager,
    ),
  );
}