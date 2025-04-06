import 'package:quote_canvas/utils/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quote_canvas/data/model_class/quote.dart';
import 'package:quote_canvas/core/exceptions/app_exception.dart';
import 'database_service.dart';

class DatabaseServiceImpl implements DatabaseService {
  // 인메모리 데이터베이스 경로 상수 추가
  static const String inMemoryDatabasePath = ':memory:';

  // 주입 가능한 필드들
  final String databaseName;
  final DatabaseFactory dbFactory;

  // 데이터베이스 인스턴스
  Database? _database;

  // 테이블 이름 상수
  static const quoteTable = 'quotes';

  // 생성자: 기본값은 실제 환경에 맞게 설정
  DatabaseServiceImpl({
    this.databaseName = 'quotes_database.db',
    DatabaseFactory? dbFactory,
  }) : dbFactory = dbFactory ??
      databaseFactory; // sqflite의 전역 databaseFactory 사용;

  // 데이터베이스 초기화 메서드
  @override
  Future<Database> get database async {
    try {
      return _database ??= await _initDB();
    } catch (e, stackTrace) {
      logger.error('데이터베이스 초기화 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '데이터베이스를 초기화하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 데이터베이스 초기화 로직
  Future<Database> _initDB() async {
    try {
      if (databaseName == inMemoryDatabasePath) {
        // 인메모리 데이터베이스 생성
        return await dbFactory.openDatabase(
          databaseName,
          options: OpenDatabaseOptions(
            version: 2,
            onCreate: _createDB,
            onUpgrade: _onUpgrade,
          ),
        );
      } else {
        // 일반 파일 경로 생성
        final dbPath = await dbFactory.getDatabasesPath();
        final path = join(dbPath, databaseName);

        // 데이터베이스 열기 (없으면 생성)
        return await dbFactory.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: 2,
            onCreate: _createDB,
            onUpgrade: _onUpgrade,
          ),
        );
      }
    } catch (e, stackTrace) {
      logger.error('DB 초기화 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '데이터베이스를 초기화하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 데이터베이스 테이블 생성
  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE $quoteTable(
        id TEXT PRIMARY KEY,
        content TEXT NOT NULL,
        author TEXT NOT NULL,
        tags TEXT,
        created_at TEXT,
        favorite_date TEXT,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        is_previously_shown INTEGER NOT NULL DEFAULT 0,
        language TEXT NOT NULL DEFAULT 'en'
      )
      ''');
    } catch (e, stackTrace) {
      logger.error('테이블 생성 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '데이터베이스 테이블을 생성하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 마이그레이션 시
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      // language 열 추가
      logger.info('데이터베이스 마이그레이션: $oldVersion -> $newVersion');

      if (oldVersion < 2) {
        // language 열이 있는지 확인
        var columns = await db.rawQuery('PRAGMA table_info($quoteTable)');
        bool hasLanguageColumn = columns.any((column) =>
        column['name'] == 'language');

        if (!hasLanguageColumn) {
          await db.execute(
              'ALTER TABLE $quoteTable ADD COLUMN language TEXT NOT NULL DEFAULT "en"');
          logger.info('language 열 추가 완료');
        }
      }
    } catch (e, stackTrace) {
      logger.error('마이그레이션 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '데이터베이스를 업그레이드하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 명언 저장 메서드
  @override
  Future<int> insertQuote(Quote quote) async {
    try {
      final db = await database;
      return await db.insert(
        quoteTable,
        quote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, stackTrace) {
      logger.error('명언 저장 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '명언을 저장하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 여러 명언 저장 메서드
  @override
  Future<List<int>> insertQuotes(List<Quote> quotes) async {
    try {
      final db = await database;
      final batch = db.batch();

      for (var quote in quotes) {
        batch.insert(
          quoteTable,
          quote.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      final results = await batch.commit();
      return results.cast<int>();
    } catch (e, stackTrace) {
      logger.error('여러 명언 저장 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '여러 명언을 저장하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 명언 업데이트 메서드
  @override
  Future<int> updateQuote(Quote quote) async {
    try {
      final db = await database;
      return await db.update(
        quoteTable,
        quote.toMap(),
        where: 'id = ?',
        whereArgs: [quote.id],
      );
    } catch (e, stackTrace) {
      logger.error('명언 업데이트 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '명언을 업데이트하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 명언 상태 업데이트 메서드
  @override
  Future<int> updateQuoteShownStatus(String id, bool isPreviouslyShown) async {
    try {
      final db = await database;
      return await db.update(
        quoteTable,
        {'is_previously_shown': isPreviouslyShown ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, stackTrace) {
      logger.error('명언 표시 상태 업데이트 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '명언 표시 상태를 업데이트하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 명언 상태 업데이트 메서드 (즐겨찾기)
  @override
  Future<int> updateQuoteFavoriteStatus(String id, bool isFavorite) async {
    try {
      final db = await database;

      final updateData = {
        'is_favorite': isFavorite ? 1 : 0,
        'favorite_date': isFavorite ? DateTime.now().toIso8601String() : null,
      };

      return await db.update(
        quoteTable,
        updateData,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, stackTrace) {
      logger.error('즐겨찾기 상태 업데이트 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '즐겨찾기 상태를 업데이트하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 명언 단일 조회 메서드
  @override
  Future<Quote?> getQuote(String id, String languageCode) async {
    try {
      final db = await database;
      final maps = await db.query(
          quoteTable,
          where: 'id = ? AND language = ?',
          whereArgs: [id, languageCode]
      );

      if (maps.isNotEmpty) {
        return Quote.fromMap(maps.first);
      }
      return null;
    } catch (e, stackTrace) {
      logger.error('명언 조회 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '명언을 조회하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 아직 표시되지 않은 명언 가져오기
  @override
  Future<Quote?> getUnshownQuote(String languageCode) async {
    try {
      final db = await database;
      final maps = await db.query(
        quoteTable,
        where: 'is_previously_shown = ? AND language = ?',
        whereArgs: [0, languageCode],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return Quote.fromMap(maps.first);
      }
      return null;
    } catch (e, stackTrace) {
      logger.error('표시되지 않은 명언 조회 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '표시되지 않은 명언을 조회하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 모든 명언 가져오기
  @override
  Future<List<Quote>> getAllQuotes(String languageCode) async {
    try {
      final db = await database;
      final maps = await db.query(
        quoteTable,
        where: 'language = ?',
        whereArgs: [languageCode],
      );

      return List.generate(maps.length, (i) {
        return Quote.fromMap(maps[i]);
      });
    } catch (e, stackTrace) {
      logger.error('모든 명언 조회 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '모든 명언을 조회하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 표시된 명언 개수 확인
  @override
  Future<int> countShownQuotes() async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $quoteTable WHERE is_previously_shown = 1',
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e, stackTrace) {
      logger.error('표시된 명언 개수 확인 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '표시된 명언 개수를 확인하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 표시되지 않은 명언 개수 확인
  @override
  Future<int> countUnshownQuotes(String languageCode) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $quoteTable WHERE is_previously_shown = 0 AND language = ?',
        [languageCode],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e, stackTrace) {
      logger.error('표시되지 않은 명언 개수 확인 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '표시되지 않은 명언 개수를 확인하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 즐겨찾기 명언 가져오기
  @override
  Future<List<Quote>> getFavoriteQuotes(String languageCode) async {
    try {
      final db = await database;
      final maps = await db.query(
        quoteTable,
        where: 'is_favorite = ? AND language = ?',
        whereArgs: [1, languageCode],
        orderBy: 'favorite_date DESC',
      );

      return List.generate(maps.length, (i) {
        return Quote.fromMap(maps[i]);
      });
    } catch (e, stackTrace) {
      logger.error('즐겨찾기 명언 조회 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '즐겨찾기 명언을 조회하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 명언 삭제 메서드
  @override
  Future<int> deleteQuote(String id) async {
    try {
      final db = await database;
      return await db.delete(quoteTable, where: 'id = ?', whereArgs: [id]);
    } catch (e, stackTrace) {
      logger.error('명언 삭제 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '명언을 삭제하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 데이터베이스 닫기
  @override
  Future<void> close() async {
    try {
      if (_database != null) {
        final db = await database;
        await db.close();
      }
    } catch (e, stackTrace) {
      logger.error('데이터베이스 닫기 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '데이터베이스를 닫는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 테스트 간 클린업을 위한 메서드
  @override
  Future<void> resetDatabase() async {
    try {
      await close();
      _database = null;
    } catch (e, stackTrace) {
      logger.error('데이터베이스 리셋 실패', error: e, stackTrace: stackTrace);
      throw AppException.database(
        message: '데이터베이스를 리셋하는 중 오류가 발생했습니다.',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}