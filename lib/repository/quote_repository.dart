import 'package:hive/hive.dart';
import '../models/quote.dart';

class QuoteRepository {
  final Box<Quote> _quotesBox = Hive.box<Quote>('quotes');

  List<Quote> getAllQuotes() {
    return _quotesBox.values.toList();
  }

  Future<void> addQuote(Quote quote) async {
    await _quotesBox.put(quote.id, quote);
  }

  Future<void> deleteQuote(String id) async {
    await _quotesBox.delete(id);
  }

  Quote? getQuoteById(String id) {
    return _quotesBox.get(id);
  }

  List<Quote> getQuotesByCategory(String category) {
    return _quotesBox.values
        .where((quote) => quote.category == category)
        .toList();
  }
}