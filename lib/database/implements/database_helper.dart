import 'dart:async';
import 'package:path/path.dart';
import 'package:quote_canvas/database/database_helper_interface.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/quote.dart';

class DatabaseHelper implements DatabaseHelperInterface {
  static final DatabaseHelper shared = DatabaseHelper._init();
  static Database? _database;

  static const quotesDBName = 'quotes_database.db';
  static const quoteTable = 'quotes';

  DatabaseHelper._init();

  // SQLite 데이터베이스 인스턴스를 가져오는 메서드
  @override
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB(quotesDBName);
      return _database!;
    }
  }

  // 데이터베이스 초기화 및 테이블 생성
  Future<Database> _initDB(String filePath) async {
    // 데이터베이스 파일 경로 생성
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // 데이터베이스 열기 (없으면 생성)
    return await openDatabase(path, version: 1, onCreate: _createDB);
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
}
