import 'package:flutter/material.dart';
import 'app.dart';
import 'database/database_helper.dart';

void main() async {
  // Flutter 바인딩 초기화 (데이터베이스 액세스 등 네이티브 코드를 호출하기 전에 필요)
  WidgetsFlutterBinding.ensureInitialized();

  // 데이터베이스 인스턴스 초기화
  await DatabaseHelper.shared.database;

  runApp(const QuoteCanvasApp());
}
