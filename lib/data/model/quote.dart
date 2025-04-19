import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quote_canvas/data/model/enum/quote_language.dart';
import 'package:uuid/uuid.dart';

part 'quote.freezed.dart';

@freezed
abstract class Quote with _$Quote {
  static final uuid = Uuid();

  const factory Quote({
    required String id,
    required String content,
    required String author,
    required DateTime createdAt,
    DateTime? favoriteDate,
    @Default(false) bool isFavorite,
    @Default(false) bool isPreviouslyShown,
    @Default(QuoteLanguage.english) QuoteLanguage language,
  }) = _Quote;

  factory Quote.empty() =>
      Quote(id: uuid.v4(), content: '', author: '', createdAt: DateTime.now());
}
