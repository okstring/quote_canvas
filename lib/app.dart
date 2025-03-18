import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/settings_view.dart';
import 'views/favorites_view.dart';

class QuoteCanvasApp extends StatelessWidget {
  const QuoteCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Canvas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Pretendard', // 기본 글꼴 설정
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/settings': (context) => const SettingsView(),
        '/favorites': (context) => const FavoritesView(),
      },
    );
  }
}