import 'quote.dart';

class Favorites {
  final List<Quote> quotes;

  const Favorites({this.quotes = const []});

  factory Favorites.fromJson(Map<String, dynamic> json) {
    final quotesJson = json['quotes'] as List<dynamic>?;
    return Favorites(
      quotes:
          quotesJson != null
              ? quotesJson
                  .map((quoteJson) => Quote.fromJson(quoteJson))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'quotes': quotes.map((quote) => quote.toJson()).toList()};
  }

  Favorites copyWith({List<Quote>? quotes}) {
    return Favorites(quotes: quotes ?? this.quotes);
  }

  Favorites addQuote(Quote quote) {
    if (quotes.any((q) => q.id == quote.id)) {
      return this;
    }
    return Favorites(quotes: [...quotes, quote]);
  }

  Favorites removeQuote(String quoteId) {
    return Favorites(
      quotes: quotes.where((quote) => quote.id != quoteId).toList(),
    );
  }

  bool contains(String quoteId) {
    return quotes.any((quote) => quote.id == quoteId);
  }
}
