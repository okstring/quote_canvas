import 'package:quote_canvas/models/index.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseService {
  Future<Database> get database;

  Future<int> insertQuote(Quote quote);

  Future<List<int>> insertQuotes(List<Quote> quotes);

  Future<int> updateQuote(Quote quote);

  Future<int> updateQuoteShownStatus(String id, bool isPreviouslyShown);

  Future<int> updateQuoteFavoriteStatus(String id, bool isFavorite);

  Future<Quote?> getQuote(String id);

  Future<Quote?> getUnshownQuote();

  Future<List<Quote>> getAllQuotes();

  Future<int> countShownQuotes();

  Future<int> countUnshownQuotes();

  Future<List<Quote>> getFavoriteQuotes();

  Future<int> deleteQuote(String id);

  Future<void> close();
}
