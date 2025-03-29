import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper shared = DatabaseHelper._init();
  static Database? _database;

  static const quotesDBName = 'quotes_database.db';

  DatabaseHelper._init();

  // SQLite 데이터베이스 인스턴스를 가져오는 메서드
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB(quotesDBName);
      return _database!;
    }
  }
}

// 데이터베이스 초기화 및 테이블 생성
Future<Database> _initDB(String filePath) async {
  // 데이터베이스 파일 경로 생성
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);

  // 데이터베이스 열기 (없으면 생성)
  return await openDatabase(
    path,
    version: 1,
    onCreate: _createDB,
  );
}

// 데이터베이스 테이블 생성
Future<void> _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE quotes(
      id TEXT PRIMARY KEY,
      text TEXT NOT NULL,
      author TEXT NOT NULL,
      category TEXT,
      created_at TEXT
    )
    ''');
}

// 데이터베이스 닫기
Future close() async {
  final db = await DatabaseHelper.shared.database;
  db.close();
}