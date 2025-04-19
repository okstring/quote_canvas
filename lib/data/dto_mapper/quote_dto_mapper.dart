import 'package:quote_canvas/data/dto/quote_dto.dart';
import 'package:quote_canvas/data/model/quote.dart';

extension QuoteDtoMapper on Quote {
  QuoteDto toDto() {
    return QuoteDto(
      id: id,
      content: content,
      author: author,
      createdAt: createdAt.toIso8601String(),
      favoriteDate: favoriteDate?.toIso8601String(),
      isFavorite: isFavorite,
      isPreviouslyShown: isPreviouslyShown,
      language: language.code,
    );
  }
}
