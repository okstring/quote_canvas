import 'package:flutter/material.dart';
import 'app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/quote.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(QuoteAdapter());

  await Hive.openBox<Quote>('quotes');

  runApp(const QuoteCanvasApp());
}
