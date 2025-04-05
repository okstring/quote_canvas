import 'package:flutter_test/flutter_test.dart';
import 'package:quote_canvas/data/services/database/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:quote_canvas/data/services/database/database_service_impl.dart';
import 'package:quote_canvas/data/model_class/quote.dart';

void main() {
  // 테스트 환경 설정
  // SQLite FFI 초기화
  sqfliteFfiInit();
  // databaseFactory 설정
  databaseFactory = databaseFactoryFfi;

  late DatabaseService databaseService;

  setUp(() async {
    // 각 테스트 전에 새 데이터베이스 서비스 인스턴스 생성
    databaseService = DatabaseServiceImpl(
      databaseName: DatabaseServiceImpl.inMemoryDatabasePath,
      dbFactory: databaseFactoryFfi,
    );
    // 데이터베이스 액세스 (초기화 트리거)
    await databaseService.database;
  });

  tearDown(() async {
    // 테스트 후 데이터베이스 리셋
    await databaseService.resetDatabase();
  });

  group('Database Service 테스트', () {
    test('명언 저장 및 조회가 정상적으로 이뤄져야 한다', () async {
      final testQuote = Quote(
        id: 'test-id',
        content: '테스트 명언',
        author: '테스트 작가',
      );

      final result = await databaseService.insertQuote(testQuote);
      expect(result, 1);

      final savedQuote = await databaseService.getQuote('test-id');
      expect(savedQuote, isNotNull);
      expect(savedQuote?.content, '테스트 명언');
    });
  });
}
