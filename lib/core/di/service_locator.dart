import 'package:http/http.dart' as http;
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'package:quote_canvas/services/API/implements/quote_service_impl.dart';
import 'package:quote_canvas/services/API/quote_service.dart';
import 'package:quote_canvas/services/database/database_service.dart';
import 'package:quote_canvas/services/database/implements/database_service_impl.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'package:quote_canvas/viewmodels/home_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/http_client.dart';
import '../../repository/quote_repository.dart';

/// 서비스 로케이터 (DI Container) 클래스
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() => _instance;

  ServiceLocator._internal();

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

  T getRequired<T extends Object>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }

    if (_factories.containsKey(T)) {
      return (_factories[T] as Function)() as T;
    }

    throw AppException.di(
        message: '의존성 $T가 등록되어 있지 않습니다.'
    );
  }

  // 등록된 모든 싱글톤 인스턴스를 초기화하는 메서드
  void reset() {
    _singletons.clear();
    _factories.clear();
  }
}

/// 전역 서비스 로케이터 인스턴스
final serviceLocator = ServiceLocator();

/// 앱의 의존성 주입을 설정합니다.
Future<void> setupDependencies() async {
  // 외부 서비스 초기화
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  // HTTP 클라이언트
  final httpClient = http.Client();
  serviceLocator.registerSingleton<http.Client>(httpClient);

  // 네트워크 설정
  const networkConfig = NetworkConfig(
    baseUrl: 'https://api.quotable.io',
  );
  serviceLocator.registerSingleton<NetworkConfig>(networkConfig);

  // HTTP 클라이언트 래퍼
  final httpClientWrapper = HttpClient(
    config: networkConfig,
    client: httpClient,
  );
  serviceLocator.registerSingleton<HttpClient>(httpClientWrapper);

  // 데이터베이스 헬퍼
  serviceLocator.registerSingleton<DatabaseService>(DatabaseServiceImpl());

  // 서비스 레이어
  final quoteService = QuoteServiceImpl(client: httpClientWrapper);
  serviceLocator.registerSingleton<QuoteService>(quoteService);

  // 리포지토리 레이어
  final quoteRepository = QuoteRepository(
    quoteService: quoteService,
    databaseHelper: DatabaseServiceImpl(),
  );
  serviceLocator.registerSingleton<QuoteRepository>(quoteRepository);

  // 뷰모델 팩토리 등록
  serviceLocator.registerFactory<HomeViewModel>(() =>
      HomeViewModel(
        quoteRepository: quoteRepository,
      )
  );
}