import 'package:sqflite/sqflite.dart';

import '../models/quote.dart';
import '../database/database_helper.dart';

class QuoteRepository {
  final dbHelper = DatabaseHelper.shared;

  // 모든 명언 가져오기
  Future<List<Quote>> getAllQuotes() async {
    final db = await dbHelper.database;
    final maps = await db.query('quotes');

    return maps.map((map) => Quote.fromMap(map)).toList();
  }

  // 새 명언 추가
  Future<void> addQuote(Quote quote) async {
    final db = await dbHelper.database;
    await db.insert(
      'quotes',
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 명언 삭제
  Future<void> deleteQuote(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      'quotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ID로 명언 검색
  Future<Quote?> getQuoteById(String id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'quotes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Quote.fromMap(maps.first);
    }
    return null;
  }

  // 카테고리별 명언 검색
  Future<List<Quote>> getQuotesByCategory(String category) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'quotes',
      where: 'category = ?',
      whereArgs: [category],
    );

    return maps.map((map) => Quote.fromMap(map)).toList();
  }
}