import 'package:flutter/material.dart';
import 'package:quote_canvas/core/di/service_locator.dart';
import 'package:quote_canvas/utils/logger.dart';
import 'app.dart';
import 'database/implements/database_helper.dart';

void main() async {
  // Flutter 바인딩 초기화 (데이터베이스 액세스 등 네이티브 코드를 호출하기 전에 필요)
  WidgetsFlutterBinding.ensureInitialized();

  logger.setTag('QuoteCanvas');

  // 데이터베이스 인스턴스 초기화
  await DatabaseHelper.shared.database;

  // 의존성 주입 setup
  await setupDependencies();

  runApp(const QuoteCanvasApp());
}