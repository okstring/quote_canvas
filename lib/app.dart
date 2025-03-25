import 'package:flutter/material.dart';
import 'router/app_router.dart';

class QuoteCanvasApp extends StatelessWidget {
  const QuoteCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quote Canvas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Pretendard', // 기본 글꼴 설정
      ),
      routerConfig: appRouter,
    );
  }
}