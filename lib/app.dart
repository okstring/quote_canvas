import 'package:flutter/material.dart';
import 'package:quote_canvas/presentation/splash/splash_screen.dart';

class QuoteCanvasApp extends StatelessWidget {
  const QuoteCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Canvas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
      home: const SplashScreen(),
    );
  }
}