import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:quote_canvas/models/quote.dart';
import 'package:quote_canvas/services/database/database_service.dart';

// 테스트용 DatabaseService 구현체
class TestDatabaseService implements DatabaseService {
  final Database _db;

  TestDatabaseService(this._db);

  @override
  Future<Database> get database async => _db;

  @override
  Future<void> close() async {
    await _db.close();
  }

  @override
  Future<int> countShownQuotes() async {
    final result = await _db.rawQuery(
      'SELECT COUNT(*) as count FROM quotes WHERE is_previously_shown = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<int> countUnshownQuotes() async {
    final result = await _db.rawQuery(
      'SELECT COUNT(*) as count FROM quotes WHERE is_previously_shown = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<int> deleteQuote(String id) async {
    return await _db.delete('quotes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Quote>> getAllQuotes() async {
    final maps = await _db.query('quotes');
    return List.generate(maps.length, (i) {
      return Quote.fromMap(maps[i]);
    });
  }

  @override
  Future<List<Quote>> getFavoriteQuotes() async {
    final maps = await _db.query(
      'quotes',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'favorite_date DESC',
    );
    return List.generate(maps.length, (i) {
      return Quote.fromMap(maps[i]);
    });
  }

  @override
  Future<Quote?> getQuote(String id) async {
    final maps = await _db.query('quotes', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Quote.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<Quote?> getUnshownQuote() async {
    final maps = await _db.query(
      'quotes',
      where: 'is_previously_shown = ?',
      whereArgs: [0],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Quote.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> insertQuote(Quote quote) async {
    return await _db.insert(
      'quotes',
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<int>> insertQuotes(List<Quote> quotes) async {
    final batch = _db.batch();

    for (var quote in quotes) {
      batch.insert(
        'quotes',
        quote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    final results = await batch.commit();
    return results.cast<int>();
  }

  @override
  Future<int> updateQuote(Quote quote) async {
    return await _db.update(
      'quotes',
      quote.toMap(),
      where: 'id = ?',
      whereArgs: [quote.id],
    );
  }

  @override
  Future<int> updateQuoteFavoriteStatus(String id, bool isFavorite) async {
    final updateData = {
      'is_favorite': isFavorite ? 1 : 0,
      'favorite_date': isFavorite ? DateTime.now().toIso8601String() : null,
    };

    return await _db.update(
      'quotes',
      updateData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> updateQuoteShownStatus(String id, bool isPreviouslyShown) async {
    return await _db.update(
      'quotes',
      {'is_previously_shown': isPreviouslyShown ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

void main() {
  // SQLite FFI 초기화
  sqfliteFfiInit();

  late Database db;
  late DatabaseService databaseService;

  setUp(() async {
    // 인메모리 데이터베이스 생성
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          // 테이블 생성
          await db.execute('''
          CREATE TABLE quotes(
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
        },
      ),
    );

    // 테스트용 DatabaseService 인스턴스 생성
    databaseService = TestDatabaseService(db);
  });

  tearDown(() async {
    // 테스트 후 데이터베이스 닫기
    await db.close();
  });

  group('DatabaseService 테스트', () {
    test('명언 추가 및 조회', () async {
      // 테스트용 명언 생성
      final testQuote = Quote(
        content: '인생은 아름다워',
        author: '테스트 작가',
      );

      // 명언 추가
      final insertId = await databaseService.insertQuote(testQuote);
      expect(insertId, isNotNull);

      // 명언 조회
      final retrievedQuote = await databaseService.getQuote(testQuote.id);
      expect(retrievedQuote, isNotNull);
      expect(retrievedQuote!.content, equals('인생은 아름다워'));
      expect(retrievedQuote.author, equals('테스트 작가'));
    });

    test('여러 명언 일괄 추가', () async {
      // 테스트용 명언 생성
      final quotes = [
        Quote(content: '명언 1', author: '작가 1'),
        Quote(content: '명언 2', author: '작가 2'),
        Quote(content: '명언 3', author: '작가 3'),
      ];

      // 여러 명언 일괄 추가
      final insertResults = await databaseService.insertQuotes(quotes);
      expect(insertResults.length, equals(3));

      // 명언 개수 확인
      final allQuotes = await databaseService.getAllQuotes();
      expect(allQuotes.length, equals(3));
    });

    test('명언 업데이트', () async {
      // 테스트용 명언 생성
      final testQuote = Quote(
        content: '원본 명언',
        author: '원본 작가',
      );

      // 명언 추가
      await databaseService.insertQuote(testQuote);

      // 명언 업데이트
      final updatedQuote = testQuote.copyWith(
        content: '수정된 명언',
        author: '수정된 작가',
      );
      await databaseService.updateQuote(updatedQuote);

      // 업데이트된 명언 조회
      final retrievedQuote = await databaseService.getQuote(testQuote.id);
      expect(retrievedQuote!.content, equals('수정된 명언'));
      expect(retrievedQuote.author, equals('수정된 작가'));
    });

    test('즐겨찾기 상태 업데이트', () async {
      // 테스트용 명언 생성
      final testQuote = Quote(
        content: '즐겨찾기 테스트',
        author: '테스트 작가',
      );

      // 명언 추가
      await databaseService.insertQuote(testQuote);

      // 즐겨찾기 상태 업데이트
      await databaseService.updateQuoteFavoriteStatus(testQuote.id, true);

      // 업데이트된 명언 조회
      final retrievedQuote = await databaseService.getQuote(testQuote.id);
      expect(retrievedQuote!.isFavorite, isTrue);

      // 즐겨찾기 상태 다시 업데이트
      await databaseService.updateQuoteFavoriteStatus(testQuote.id, false);

      // 다시 업데이트된 명언 조회
      final updatedQuote = await databaseService.getQuote(testQuote.id);
      expect(updatedQuote!.isFavorite, isFalse);
    });

    test('표시 상태 업데이트', () async {
      // 테스트용 명언 생성
      final testQuote = Quote(
        content: '표시 상태 테스트',
        author: '테스트 작가',
      );

      // 명언 추가
      await databaseService.insertQuote(testQuote);

      // 표시 상태 업데이트
      await databaseService.updateQuoteShownStatus(testQuote.id, true);

      // 표시된 명언 개수 확인
      final shownCount = await databaseService.countShownQuotes();
      expect(shownCount, equals(1));

      // 표시되지 않은 명언 개수 확인
      final unshownCount = await databaseService.countUnshownQuotes();
      expect(unshownCount, equals(0));
    });

    test('미표시 명언 조회', () async {
      // 테스트용 명언 생성
      final quotes = [
        Quote(content: '명언 1', author: '작가 1'),
        Quote(content: '명언 2', author: '작가 2'),
        Quote(content: '명언 3', author: '작가 3'),
      ];

      // 명언 추가
      await databaseService.insertQuotes(quotes);

      // 첫 번째 명언 표시 상태 업데이트
      await databaseService.updateQuoteShownStatus(quotes[0].id, true);

      // 표시되지 않은 명언 조회
      final unshownQuote = await databaseService.getUnshownQuote();
      expect(unshownQuote, isNotNull);

      // 표시되지 않은 명언 중 하나인지 확인
      expect(
          quotes.where((q) => q.id != quotes[0].id).any((q) => q.id == unshownQuote!.id),
          isTrue
      );
    });

    test('즐겨찾기 명언 목록 조회', () async {
      // 테스트용 명언 생성
      final quotes = [
        Quote(content: '명언 1', author: '작가 1'),
        Quote(content: '명언 2', author: '작가 2'),
        Quote(content: '명언 3', author: '작가 3'),
      ];

      // 명언 추가
      await databaseService.insertQuotes(quotes);

      // 첫 번째와 세 번째 명언 즐겨찾기 상태 업데이트
      await databaseService.updateQuoteFavoriteStatus(quotes[0].id, true);
      await databaseService.updateQuoteFavoriteStatus(quotes[2].id, true);

      // 즐겨찾기 명언 목록 조회
      final favoriteQuotes = await databaseService.getFavoriteQuotes();
      expect(favoriteQuotes.length, equals(2));

      // 즐겨찾기 명언 ID 확인
      final favoriteIds = favoriteQuotes.map((q) => q.id).toList();
      expect(favoriteIds, containsAll([quotes[0].id, quotes[2].id]));
    });

    test('명언 삭제', () async {
      // 테스트용 명언 생성
      final testQuote = Quote(
        content: '삭제 테스트',
        author: '테스트 작가',
      );

      // 명언 추가
      await databaseService.insertQuote(testQuote);

      // 명언 삭제
      final deleteResult = await databaseService.deleteQuote(testQuote.id);
      expect(deleteResult, equals(1));

      // 삭제된 명언 조회
      final retrievedQuote = await databaseService.getQuote(testQuote.id);
      expect(retrievedQuote, isNull);
    });
  });
}