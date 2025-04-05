import 'package:flutter/material.dart';
import 'package:quote_canvas/ui/views/splash_screen.dart';

class QuoteCanvasApp extends StatelessWidget {
  const QuoteCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote Canvas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Pretendard',
      ),
      home: const SplashScreen(),
    );
  }
}