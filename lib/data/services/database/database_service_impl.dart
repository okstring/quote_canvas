import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quote_canvas/data/model_class/quote.dart';
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
  }): dbFactory = dbFactory ?? databaseFactory; // sqflite의 전역 databaseFactory 사용;

  // 데이터베이스 초기화 메서드
  @override
  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  // 데이터베이스 초기화 로직
  Future<Database> _initDB() async {
    if (databaseName == inMemoryDatabasePath) {
      // 인메모리 데이터베이스 생성
      return await dbFactory.openDatabase(
        databaseName,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _createDB,
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
          version: 1,
          onCreate: _createDB,
        ),
      );
    }
  }

  // 데이터베이스 테이블 생성
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $quoteTable(
      id TEXT PRIMARY KEY,
      content TEXT NOT NULL,
      author TEXT NOT NULL,
      tags TEXT,
      created_at TEXT,
      favorite_date TEXT,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      is_previously_shown INTEGER NOT NULL DEFAULT 0
    )
    ''');
  }

  // 명언 저장 메서드
  @override
  Future<int> insertQuote(Quote quote) async {
    final db = await database;
    return await db.insert(
      quoteTable,
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 여러 명언 저장 메서드
  @override
  Future<List<int>> insertQuotes(List<Quote> quotes) async {
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
  }

  // 명언 업데이트 메서드
  @override
  Future<int> updateQuote(Quote quote) async {
    final db = await database;
    return await db.update(
      quoteTable,
      quote.toMap(),
      where: 'id = ?',
      whereArgs: [quote.id],
    );
  }

  // 명언 상태 업데이트 메서드
  @override
  Future<int> updateQuoteShownStatus(String id, bool isPreviouslyShown) async {
    final db = await database;
    return await db.update(
      quoteTable,
      {'is_previously_shown': isPreviouslyShown ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 명언 상태 업데이트 메서드 (즐겨찾기)
  @override
  Future<int> updateQuoteFavoriteStatus(String id, bool isFavorite) async {
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
  }

  // 명언 단일 조회 메서드
  @override
  Future<Quote?> getQuote(String id) async {
    final db = await database;
    final maps = await db.query(quoteTable, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Quote.fromMap(maps.first);
    }
    return null;
  }

  // 아직 표시되지 않은 명언 가져오기
  @override
  Future<Quote?> getUnshownQuote() async {
    final db = await database;
    final maps = await db.query(
      quoteTable,
      where: 'is_previously_shown = ?',
      whereArgs: [0],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Quote.fromMap(maps.first);
    }
    return null;
  }

  // 모든 명언 가져오기
  @override
  Future<List<Quote>> getAllQuotes() async {
    final db = await database;
    final maps = await db.query(quoteTable);

    return List.generate(maps.length, (i) {
      return Quote.fromMap(maps[i]);
    });
  }

  // 표시된 명언 개수 확인
  @override
  Future<int> countShownQuotes() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $quoteTable WHERE is_previously_shown = 1',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // 표시되지 않은 명언 개수 확인
  @override
  Future<int> countUnshownQuotes() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $quoteTable WHERE is_previously_shown = 0',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // 즐겨찾기 명언 가져오기
  @override
  Future<List<Quote>> getFavoriteQuotes() async {
    final db = await database;
    final maps = await db.query(
      quoteTable,
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'favorite_date DESC',
    );

    return List.generate(maps.length, (i) {
      return Quote.fromMap(maps[i]);
    });
  }

  // 명언 삭제 메서드
  @override
  Future<int> deleteQuote(String id) async {
    final db = await database;
    return await db.delete(quoteTable, where: 'id = ?', whereArgs: [id]);
  }

  // 데이터베이스 닫기
  @override
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // 테스트 간 클린업을 위한 메서드
  Future<void> resetDatabase() async {
    await close();
    _database = null;
  }
}
